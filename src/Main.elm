module Main exposing (main)

import Browser
import Config exposing (Config)
import Main.Model exposing (Model, init)
import Main.Msg exposing (Msg(..))
import Main.Subscriptions exposing (subscriptions)
import Main.Update exposing (update)
import Main.View exposing (view)


main : Program Config Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequest
        , onUrlChange = UrlChange
        }
