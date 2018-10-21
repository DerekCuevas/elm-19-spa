module Main.View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Main.Model exposing (Model)
import Main.Msg exposing (Msg)


view : Model -> Document Msg
view model =
    { title = ""
    , body = [ text "Hello World!!" ]
    }
