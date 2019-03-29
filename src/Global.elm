module Global exposing
    ( Global
    , Msg
    , batch
    , getConfig
    , getKey
    , getRepos
    , getReposForUserId
    , getTime
    , getUserForId
    , getUsers
    , init
    , none
    , subscriptions
    , update
    )

import Browser.Navigation exposing (Key)
import Config exposing (Config)
import Data.Repo exposing (Repo)
import Data.User exposing (User, UserId)
import Dict exposing (Dict)
import List.Extra
import RemoteData as RD exposing (RemoteData(..), WebData)
import Request.Repo
import Request.User
import Task
import Time exposing (Posix)



-- COMMANDS --


getUsersCmd : Config -> Cmd Msg
getUsersCmd config =
    Request.User.getUsers config
        |> RD.sendRequest
        |> Cmd.map GetUsersResponse


getReposCmd : Config -> UserId -> Cmd Msg
getReposCmd config userId =
    Request.Repo.getRepos config userId
        |> RD.sendRequest
        |> Cmd.map (GetReposResponse userId)



-- MODEL --


type alias Model =
    { config : Config
    , time : Posix
    , key : Key
    , users : WebData (List User)
    , reposByUserId : Dict UserId (WebData (List Repo))
    }


type Global
    = Global Model


init : Config -> Key -> ( Global, Cmd Msg )
init config key =
    ( Global
        { config = config
        , time = Time.millisToPosix 0
        , key = key
        , users = Loading
        , reposByUserId = Dict.empty
        }
    , Cmd.batch
        [ Task.perform SetTime Time.now
        , getUsersCmd config
        ]
    )


toModel : Global -> Model
toModel (Global model) =
    model


toGlobal : Model -> Global
toGlobal model =
    Global model



-- MSG --


type Msg
    = SetTime Posix
    | GetUsersResponse (WebData (List User))
    | GetRepos UserId
    | GetReposResponse UserId (WebData (List Repo))
    | Batch (List Msg)
    | NoOp



-- PUBLIC MSG --


none : Msg
none =
    NoOp


batch : List Msg -> Msg
batch =
    Batch


getRepos : UserId -> Msg
getRepos =
    GetRepos



-- UPDATE --


updateBatch : Model -> List Msg -> ( Global, Cmd Msg )
updateBatch model msgs =
    Tuple.mapSecond Cmd.batch <|
        List.foldl
            (\msg ( global, cmds ) ->
                update msg global
                    |> Tuple.mapSecond (\cmd -> cmd :: cmds)
            )
            ( toGlobal model, [] )
            msgs


update : Msg -> Global -> ( Global, Cmd Msg )
update msg (Global model) =
    let
        set nextModel =
            ( toGlobal nextModel, Cmd.none )
    in
    case msg of
        SetTime time ->
            set { model | time = time }

        GetUsersResponse response ->
            set { model | users = response }

        GetRepos userId ->
            let
                isSuccess =
                    model.reposByUserId
                        |> Dict.get userId
                        |> Maybe.withDefault NotAsked
                        |> RD.isSuccess

                reposByUserId =
                    if isSuccess then
                        model.reposByUserId

                    else
                        Dict.insert userId Loading model.reposByUserId
            in
            ( toGlobal { model | reposByUserId = reposByUserId }
            , getReposCmd model.config userId
            )

        GetReposResponse userId response ->
            set { model | reposByUserId = Dict.insert userId response model.reposByUserId }

        Batch msgs ->
            updateBatch model msgs

        NoOp ->
            set model



-- SUBSCRIPTIONS --


subscriptions : Global -> Sub Msg
subscriptions global =
    Sub.none



-- PUBLIC GETTERS --


getConfig : Global -> Config
getConfig =
    toModel >> .config


getTime : Global -> Posix
getTime =
    toModel >> .time


getKey : Global -> Key
getKey =
    toModel >> .key


getUsers : Global -> WebData (List User)
getUsers =
    toModel >> .users


getUserForId : Global -> UserId -> WebData User
getUserForId global userId =
    global
        |> getUsers
        |> RD.andThen
            (\users ->
                users
                    |> List.Extra.find (\user -> user.id == userId)
                    |> Maybe.map RD.succeed
                    |> Maybe.withDefault NotAsked
            )


getReposForUserId : Global -> UserId -> WebData (List Repo)
getReposForUserId global userId =
    global
        |> toModel
        |> .reposByUserId
        |> Dict.get userId
        |> Maybe.withDefault NotAsked
