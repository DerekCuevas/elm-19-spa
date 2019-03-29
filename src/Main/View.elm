module Main.View exposing (view)

import Browser exposing (Document)
import Extra.Html.Styled
import Html exposing (..)
import Html.Styled
import Main.Model exposing (Model, Page(..))
import Main.Msg exposing (Msg(..))
import Page.Detail
import Page.Index


view : Model -> Document Msg
view model =
    let
        viewPage toMsg pageModel pageView =
            let
                { title, body } =
                    pageView model.global pageModel
            in
            Extra.Html.Styled.toUnstyledDocument
                { title = title
                , body = List.map (Html.Styled.map toMsg) body
                }
    in
    case model.page of
        Index indexModel ->
            viewPage IndexMsg indexModel Page.Index.view

        Detail detailModel ->
            viewPage DetailMsg detailModel Page.Detail.view

        NotFound ->
            { title = "Not Found"
            , body = [ text ":(" ]
            }
