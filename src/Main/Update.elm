module Main.Update exposing (update)

import Browser
import Browser.Navigation as BN
import Global
import Main.Model exposing (Model, Page(..), initPage, updatePage)
import Main.Msg exposing (Msg(..))
import Page.Detail
import Page.Index
import Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( UrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , BN.pushUrl (Global.getKey model.global) (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , BN.load href
                    )

        ( UrlChange url, _ ) ->
            initPage url model

        ( IndexMsg imsg, Index indexModel ) ->
            Page.Index.update model.global imsg indexModel
                |> updatePage Index IndexMsg model

        ( DetailMsg dmsg, Detail detailModel ) ->
            Page.Detail.update model.global dmsg detailModel
                |> updatePage Detail DetailMsg model

        _ ->
            ( model, Cmd.none )
