module Main.Update exposing (update)

import Main.Model exposing (Model)
import Main.Msg exposing (Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
