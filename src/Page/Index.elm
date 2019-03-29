module Page.Index exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Config exposing (Config)
import Css exposing (..)
import Data.User exposing (User)
import Extra.Html.Styled exposing (Document)
import Global exposing (Global)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import RemoteData as RD exposing (RemoteData(..), WebData)
import Request.User
import Route



-- COMMANDS


getUsers : Config -> Cmd Msg
getUsers config =
    Request.User.getUsers config
        |> RD.sendRequest
        |> Cmd.map GetUsersResponse



-- MODEL


type alias Model =
    { users : WebData (List User)
    }


init : Global -> ( Model, Cmd Msg, Global.Msg )
init global =
    ( { users = Loading }
    , getUsers <| Global.getConfig global
    , Global.none
    )



-- UPDATE


type Msg
    = GetUsersResponse (WebData (List User))


update : Global -> Msg -> Model -> ( Model, Cmd Msg, Global.Msg )
update _ msg model =
    case msg of
        GetUsersResponse response ->
            ( { model | users = response }, Cmd.none, Global.none )



-- SUBSCRIPTIONS


subscriptions : Global -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- VIEW


view : Global -> Model -> Document Msg
view _ model =
    { title = "Home"
    , body =
        [ h1 [] [ text "Users" ]
        , viewUsers model
        ]
    }


viewUsers : Model -> Html Msg
viewUsers model =
    case model.users of
        NotAsked ->
            text "Not Asked."

        Loading ->
            text "Loading..."

        Failure error ->
            text "Error"

        Success [] ->
            text "No users found."

        Success users ->
            ul [ css [ margin (px 0), padding (px 0) ] ] <|
                List.map viewUser users


userStyle : Style
userStyle =
    batch
        [ padding (px 10)
        , backgroundColor <| hex "#eee"
        , listStyle none
        , marginBottom (px 5)
        ]


viewUser : User -> Html Msg
viewUser user =
    li [ css [ userStyle ] ]
        [ a [ Route.href <| Route.Detail { id = user.username } ]
            [ text user.username ]
        ]
