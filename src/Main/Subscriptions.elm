module Main.Subscriptions exposing (subscriptions)

import Global
import Main.Model exposing (Model, Page(..))
import Main.Msg exposing (Msg(..))
import Page.Detail
import Page.Index


globalSubscriptions : Model -> Sub Msg
globalSubscriptions model =
    Global.subscriptions model.global
        |> Sub.map GlobalMsg


pageSubscriptions : Model -> Sub Msg
pageSubscriptions model =
    case model.page of
        Index indexModel ->
            Page.Index.subscriptions model.global indexModel
                |> Sub.map IndexMsg

        Detail detailModel ->
            Page.Detail.subscriptions model.global detailModel
                |> Sub.map DetailMsg

        NotFound ->
            Sub.none


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions model
        , globalSubscriptions model
        ]
