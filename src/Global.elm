module Global exposing
    ( Global
    , getConfig
    , getTime
    , init
    )

import Config exposing (Config)
import Time exposing (Posix)


type alias Model =
    { config : Config
    , time : Posix
    }


type Global
    = Global Model


init : Config -> ( Global, Cmd Msg )
init config =
    ( Global
        { config = config
        , time = Time.millisToPosix 0
        }
    , Cmd.none
    )


type Msg
    = NoOp


toModel : Global -> Model
toModel (Global model) =
    model


toGlobal : Model -> Global
toGlobal model =
    Global model


getConfig : Global -> Config
getConfig =
    toModel >> .config


getTime : Global -> Posix
getTime =
    toModel >> .time
