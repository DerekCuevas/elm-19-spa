module Main.Subscriptions exposing (subscriptions)

import Main.Model exposing (Model)
import Main.Msg exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
