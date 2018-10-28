module Main.Update exposing (update)

import Browser
import Browser.Navigation as BN
import Global
import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.Page exposing (Page(..))
import Page.Detail
import Page.Index
import Url


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
        , Cmd.map GlobalMsg global
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( UrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , BN.pushUrl (Global.getNavigationKey model.global) (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , BN.load href
                    )

        ( UrlChange urlChange, _ ) ->
            ( model, Cmd.none )

        ( IndexMsg imsg, Index indexModel ) ->
            Page.Index.update model.global imsg indexModel
                |> updatePage Index IndexMsg model

        ( DetailMsg dmsg, Detail detailModel ) ->
            Page.Detail.update model.global dmsg detailModel
                |> updatePage Detail DetailMsg model

        _ ->
            ( model, Cmd.none )
