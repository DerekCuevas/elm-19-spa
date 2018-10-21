port module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode


type alias Config =
    { api : String
    }


type alias Model =
    {}


init : Config -> ( Model, Cmd Msg )
init config =
    ( {}, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [] [ text "Hello" ]


main : Program Config Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , subscriptions = always Sub.none
        }
