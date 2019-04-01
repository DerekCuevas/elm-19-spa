module Main.Middleware exposing (Middleware, combineMiddleware)

import Url exposing (Url)


type alias Middleware route model =
    route -> model -> route


combineMiddleware : List (Middleware route model) -> Middleware route model
combineMiddleware middlewares route model =
    List.foldl (\middleware nextRoute -> middleware nextRoute model) route middlewares
