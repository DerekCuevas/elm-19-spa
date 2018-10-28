module Global exposing
    ( Global
    , Msg
    , getConfig
    , getKey
    , getTime
    , init
    , none
    , update
    )

import Browser.Navigation exposing (Key)
import Config exposing (Config)
import Task
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
    , Task.perform SetTime Time.now
    )


toModel : Global -> Model
toModel (Global model) =
    model


toGlobal : Model -> Global
toGlobal model =
    Global model



-- UPDATE


type Msg
    = SetTime Posix
    | NoOp


none : Msg
none =
    NoOp


update : Msg -> Global -> ( Global, Cmd Msg )
update msg (Global model) =
    let
        set nextModel =
            ( toGlobal nextModel, Cmd.none )
    in
    case msg of
        SetTime time ->
            set { model | time = time }

        NoOp ->
            set model



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


getKey : Global -> Key
getKey =
    toModel >> .key
