module Page.Detail exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Data.User exposing (User, UserId)
import Extra.Html.Styled exposing (Document)
import Global exposing (Global)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import RemoteData as RD exposing (WebData)
import Route



-- MODEL


type alias Model =
    { userId : UserId
    }


init : Global -> UserId -> ( Model, Cmd Msg, Global.Msg )
init global userId =
    ( { userId = userId }
    , Cmd.none
    , Global.none
    )



-- UPDATE


type Msg
    = NoOp


update : Global -> Msg -> Model -> ( Model, Cmd Msg, Global.Msg )
update global msg model =
    ( model, Cmd.none, Global.none )



-- SUBSCRIPTIONS


subscriptions : Global -> Model -> Sub Msg
subscriptions global model =
    Sub.none



-- RESOURCES --


type alias Resources =
    { user : User
    }


getResources : Global -> Model -> WebData Resources
getResources global model =
    Resources
        |> RD.succeed
        |> RD.andMap (Global.getUserForId global model.userId)



-- VIEW


view : Global -> Model -> Document Msg
view global model =
    let
        resourcesWebData =
            getResources global model

        title =
            resourcesWebData
                |> RD.map (.user >> .username)
                |> RD.withDefault "Loading user..."
    in
    { title = title
    , body = [ viewPage resourcesWebData ]
    }


viewPage : WebData Resources -> Html Msg
viewPage resourcesWebData =
    Extra.Html.Styled.viewWebData resourcesWebData <|
        \resources ->
            div []
                [ h1 [] [ text <| "Detail: " ++ resources.user.username ]
                , a [ Route.href Route.Index ] [ text "Home" ]
                ]
