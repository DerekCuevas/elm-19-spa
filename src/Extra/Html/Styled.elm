module Extra.Html.Styled exposing
    ( Document
    , none
    , toUnstyledDocument
    , viewIfLazy
    , viewMaybe
    , viewWebData
    )

import Browser
import Extra.Http
import Html.Styled exposing (..)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..), WebData)


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


toUnstyledDocument : Document msg -> Browser.Document msg
toUnstyledDocument { title, body } =
    { title = title
    , body = List.map toUnstyled body
    }


none : Html msg
none =
    text ""


viewIfLazy : Bool -> (() -> Html msg) -> Html msg
viewIfLazy predicate thunk =
    if predicate then
        thunk ()

    else
        none


viewMaybe : Maybe a -> (a -> Html msg) -> Html msg
viewMaybe maybe view =
    case maybe of
        Nothing ->
            none

        Just a ->
            view a


viewWebData : WebData a -> (a -> Html msg) -> Html msg
viewWebData webData view =
    case webData of
        NotAsked ->
            none

        Loading ->
            text "Loading..."

        Failure error ->
            text <| Extra.Http.errorToString error

        Success a ->
            view a
