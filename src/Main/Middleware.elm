module Main.Middleware exposing (Middleware, combineMiddleware)

import Url exposing (Url)


type alias Middleware route model msg =
    route -> model -> ( route, Cmd msg )


combineMiddleware : List (Middleware route model msg) -> Middleware route model msg
combineMiddleware middlewares route model =
    let
        apply middleware ( nextRoute, cmds ) =
            middleware nextRoute model
                |> Tuple.mapSecond (\cmd -> Cmd.batch [ cmds, cmd ])
    in
    List.foldl apply ( route, Cmd.none ) middlewares
