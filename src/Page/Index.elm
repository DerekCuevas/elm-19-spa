module Page.Index exposing
    ( Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Config exposing (Config)
import Css exposing (..)
import Data.User exposing (User)
import Extra.Html.Styled exposing (Document)
import Global exposing (Global)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import RemoteData as RD exposing (RemoteData(..), WebData)
import Request.User
import Route



-- MODEL


type alias Model =
    {}


init : Global -> ( Model, Cmd Msg, Global.Msg )
init global =
    ( {}
    , Cmd.none
    , Global.none
    )



-- UPDATE


type Msg
    = NoOp


update : Global -> Msg -> Model -> ( Model, Cmd Msg, Global.Msg )
update _ msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, Global.none )



-- SUBSCRIPTIONS


subscriptions : Global -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- RESOURCES --


type alias Resources =
    { users : List User
    }


getResources : Global -> Model -> WebData Resources
getResources global model =
    RD.succeed Resources
        |> RD.andMap (Global.getUsers global)



-- VIEW


view : Global -> Model -> Document Msg
view global model =
    { title = "Home"
    , body = [ viewPage global model ]
    }


viewPage : Global -> Model -> Html Msg
viewPage global model =
    Extra.Html.Styled.viewWebData (getResources global model) <|
        \resources ->
            div []
                [ h1 [] [ text "Users" ]
                , viewUsers resources.users
                ]


viewUsers : List User -> Html Msg
viewUsers users =
    ul [ css [ margin (px 0), padding (px 0) ] ] <|
        List.map viewUser users


userStyle : Style
userStyle =
    batch
        [ padding (px 10)
        , backgroundColor <| hex "#eee"
        , listStyle none
        , marginBottom (px 5)
        ]


viewUser : User -> Html Msg
viewUser user =
    li [ css [ userStyle ] ]
        [ a [ Route.href <| Route.Detail { id = user.username } ]
            [ text user.username ]
        ]
