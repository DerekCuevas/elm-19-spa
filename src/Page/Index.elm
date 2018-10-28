module Page.Index exposing
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
import Route



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


subscriptions : Global -> Model -> Sub Msg
subscriptions global model =
    Sub.none



-- VIEW


view : Global -> Model -> Document Msg
view global model =
    { title = "Home"
    , body =
        [ h1 [] [ text "Index page" ]
        , ul []
            [ li [] [ a [ Route.href <| Route.Detail { id = "foo" } ] [ text "Foo" ] ]
            , li [] [ a [ Route.href <| Route.Detail { id = "bar" } ] [ text "Bar" ] ]
            ]
        ]
    }
