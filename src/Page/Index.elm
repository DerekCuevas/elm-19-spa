module Page.Index exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Browser exposing (Document)
import Config exposing (Config)
import Data.User exposing (User)
import Global exposing (Global)
import Html exposing (..)
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
            ul [] <| List.map viewUser users


viewUser : User -> Html Msg
viewUser user =
    li []
        [ a [ Route.href <| Route.Detail { id = user.username } ]
            [ text user.username ]
        ]
