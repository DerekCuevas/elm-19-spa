module Page.Detail exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Browser exposing (Document)
import Global exposing (Global)
import Html exposing (..)



-- MODEL


type alias Model =
    {}


init : Global -> ( Model, Cmd Msg, Global.Msg )
init global =
    ( {}, Cmd.none, Global.none )



-- UPDATE


type Msg
    = NoOp


update : Global -> Msg -> Model -> ( Model, Cmd Msg, Global.Msg )
update global msg model =
    ( model, Cmd.none, Global.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Detail"
    , body = [ text "detail page" ]
    }
