module Main.Subscriptions exposing (subscriptions)

import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))
import Main.Page exposing (Page(..))
import Page.Detail
import Page.Index


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        Index indexModel ->
            Page.Index.subscriptions model.global indexModel
                |> Sub.map IndexMsg

        Detail detailModel ->
            Page.Detail.subscriptions model.global detailModel
                |> Sub.map DetailMsg

        NotFound ->
            Sub.none
