module Main.Model exposing (Model, init)

import Browser.Navigation exposing (Key)
import Config exposing (Config)
import Global exposing (Global)
import Main.Msg exposing (Msg(..))
import Main.Page exposing (Page(..))
import Url exposing (Url)


type alias Model =
    { page : Page
    , global : Global
    }


init : Config -> Url -> Key -> ( Model, Cmd Msg )
init config url key =
    let
        ( global, globalCmd ) =
            Global.init config key
    in
    ( { page = NotFound
      , global = global
      }
    , Cmd.map GlobalMsg globalCmd
    )
