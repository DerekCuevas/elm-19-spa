module Main.Page exposing (Page(..))

import Page.Detail
import Page.Index


type Page
    = Index Page.Index.Model
    | Detail Page.Detail.Model
    | NotFound
