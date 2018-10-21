module Main.Msg exposing (Msg(..))

import Browser exposing (UrlRequest)
import Url exposing (Url)


type Msg
    = UrlRequest UrlRequest
    | UrlChange Url
