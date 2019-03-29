module Route exposing
    ( Route(..)
    , fromUrl
    , href
    , newUrl
    , parser
    , toString
    )

import Browser.Navigation as BN exposing (Key)
import Data.User exposing (UserId)
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes
import Url exposing (Url)
import Url.Builder as UB
import Url.Parser as UP exposing ((</>), Parser)


type Route
    = Index
    | Detail { userId : UserId }


parser : Parser (Route -> a) a
parser =
    UP.oneOf
        [ UP.map Index <| UP.top
        , UP.map (\userId -> Detail { userId = userId }) <| UP.s "detail" </> UP.string
        ]


toString : Route -> String
toString route =
    case route of
        Index ->
            UB.absolute [] []

        Detail { userId } ->
            UB.absolute [ "detail", userId ] []


newUrl : Key -> Route -> Cmd msg
newUrl key =
    toString >> BN.pushUrl key


fromUrl : Url -> Maybe Route
fromUrl url =
    UP.parse parser url


href : Route -> Attribute msg
href route =
    Html.Styled.Attributes.href <| toString route
