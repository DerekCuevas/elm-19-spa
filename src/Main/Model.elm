module Main.Model exposing
    ( Model
    , Page(..)
    , init
    , initPage
    , updatePage
    )

import Browser.Navigation exposing (Key)
import Config exposing (Config)
import Global exposing (Global)
import Main.Msg exposing (Msg(..))
import Page.Detail
import Page.Index
import Route
import Url exposing (Url)


type Page
    = Index Page.Index.Model
    | Detail Page.Detail.Model
    | NotFound


type alias Model =
    { page : Page
    , global : Global
    }


init : Config -> Url -> Key -> ( Model, Cmd Msg )
init config url key =
    let
        ( global, globalCmd ) =
            Global.init config key

        ( model, cmd ) =
            initPage url
                { page = NotFound
                , global = global
                }
    in
    ( model
    , Cmd.batch
        [ cmd
        , Cmd.map GlobalMsg globalCmd
        ]
    )



-- GENERIC UPDATE PAGE --


updatePage :
    (pageModel -> Page)
    -> (pageMsg -> Msg)
    -> Model
    -> ( pageModel, Cmd pageMsg, Global.Msg )
    -> ( Model, Cmd Msg )
updatePage toPage toMsg model ( pageModel, pageCmd, globalMsg ) =
    let
        ( global, globalCmd ) =
            Global.update globalMsg model.global
    in
    ( { model | page = toPage pageModel, global = global }
    , Cmd.batch
        [ Cmd.map toMsg pageCmd
        , Cmd.map GlobalMsg globalCmd
        ]
    )



-- INIT PAGE --


initPage : Url -> Model -> ( Model, Cmd Msg )
initPage url model =
    case Route.fromUrl url of
        Just Route.Index ->
            Page.Index.init model.global
                |> updatePage Index IndexMsg model

        Just (Route.Detail { id }) ->
            Page.Detail.init model.global id
                |> updatePage Detail DetailMsg model

        Nothing ->
            ( { model | page = NotFound }
            , Cmd.none
            )
