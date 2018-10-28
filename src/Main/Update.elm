module Main.Update exposing (update)

import Main.Model exposing (Model)
import Main.Msg exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( UrlRequest urlRequest, _ ) ->
            ( model, Cmd.none )

        ( UrlChange urlChange, _ ) ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
