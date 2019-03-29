module Global exposing
    ( Global
    , Msg
    , batch
    , getConfig
    , getKey
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
import Data.User exposing (User, UserId)
import List.Extra
import RemoteData as RD exposing (RemoteData(..), WebData)
import Request.User
import Task
import Time exposing (Posix)



-- COMMANDS --


getUsersCmd : Config -> Cmd Msg
getUsersCmd config =
    Request.User.getUsers config
        |> RD.sendRequest
        |> Cmd.map GetUsersResponse



-- MODEL


type alias Model =
    { config : Config
    , time : Posix
    , key : Key
    , users : WebData (List User)
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



-- UPDATE


type Msg
    = SetTime Posix
    | GetUsersResponse (WebData (List User))
    | Batch (List Msg)
    | NoOp


none : Msg
none =
    NoOp


batch : List Msg -> Msg
batch =
    Batch


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

        Batch msgs ->
            updateBatch model msgs

        NoOp ->
            set model



-- SUBSCRIPTIONS


subscriptions : Global -> Sub Msg
subscriptions global =
    Sub.none



-- PUBLIC GETTERS


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
