module Main.Msg exposing (Msg(..))

import Browser exposing (UrlRequest)
import Global
import Page.Detail
import Page.Index
import Url exposing (Url)


type Msg
    = UrlRequest UrlRequest
    | UrlChange Url
    | GlobalMsg Global.Msg
    | IndexMsg Page.Index.Msg
    | DetailMsg Page.Detail.Msg
