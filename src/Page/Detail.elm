module Page.Detail exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Config exposing (Config)
import Data.Repo exposing (Repo)
import Data.User exposing (User, UserId)
import Extra.Html.Styled exposing (Document)
import Global exposing (Global)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import RemoteData as RD exposing (RemoteData(..), WebData)
import Request.Repo
import Route



-- COMMANDS --


getRepos : Config -> UserId -> Cmd Msg
getRepos config userId =
    Request.Repo.getRepos config userId
        |> RD.sendRequest
        |> Cmd.map GetReposResponse



-- MODEL


type alias Model =
    { userId : UserId
    , repos : WebData (List Repo)
    }


init : Global -> UserId -> ( Model, Cmd Msg, Global.Msg )
init global userId =
    ( { userId = userId, repos = Loading }
    , getRepos (Global.getConfig global) userId
    , Global.none
    )



-- UPDATE


type Msg
    = GetReposResponse (WebData (List Repo))


update : Global -> Msg -> Model -> ( Model, Cmd Msg, Global.Msg )
update global msg model =
    let
        set updatedModel =
            ( updatedModel, Cmd.none, Global.none )
    in
    case msg of
        GetReposResponse response ->
            set { model | repos = response }



-- SUBSCRIPTIONS


subscriptions : Global -> Model -> Sub Msg
subscriptions global model =
    Sub.none



-- RESOURCES --


type alias Resources =
    { user : User
    , repos : List Repo
    }


getResources : Global -> Model -> WebData Resources
getResources global model =
    Resources
        |> RD.succeed
        |> RD.andMap (Global.getUserForId global model.userId)
        |> RD.andMap model.repos



-- VIEW


view : Global -> Model -> Document Msg
view global model =
    let
        resourcesWebData =
            getResources global model

        title =
            resourcesWebData
                |> RD.map (.user >> .username)
                |> RD.withDefault "Loading user..."
    in
    { title = title
    , body = [ viewPage resourcesWebData ]
    }


viewPage : WebData Resources -> Html Msg
viewPage resourcesWebData =
    Extra.Html.Styled.viewWebData resourcesWebData <|
        \resources ->
            div []
                [ h1 [] [ text <| "Repos for user: " ++ resources.user.username ]
                , viewRepos resources.repos
                , a [ Route.href Route.Index ] [ text "Home" ]
                ]


viewRepos : List Repo -> Html Msg
viewRepos repos =
    ul [] <| List.map (\repo -> li [] [ text repo.name ]) repos
