module Global exposing
    ( Global
    , Msg
    , getConfig
    , getNavigationKey
    , getTime
    , init
    , none
    )

import Browser.Navigation exposing (Key)
import Config exposing (Config)
import Time exposing (Posix)



-- MODEL


type alias Model =
    { config : Config
    , time : Posix
    , key : Key
    }


type Global
    = Global Model


init : Config -> Key -> ( Global, Cmd Msg )
init config key =
    ( Global
        { config = config
        , time = Time.millisToPosix 0
        , key = key
        }
    , Cmd.none
    )


toModel : Global -> Model
toModel (Global model) =
    model


toGlobal : Model -> Global
toGlobal model =
    Global model



-- UPDATE


type Msg
    = NoOp


none : Msg
none =
    NoOp


update : Global -> Msg -> ( Global, Cmd Msg )
update global msg =
    ( global, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Global -> Sub Msg
subscriptions global =
    Sub.none



-- PUBLIC GETTERS


getConfig : Global -> Config
getConfig =
    toModel >> .config


getTime : Global -> Posix
getTime =
    toModel >> .time


getNavigationKey : Global -> Key
getNavigationKey =
    toModel >> .key
