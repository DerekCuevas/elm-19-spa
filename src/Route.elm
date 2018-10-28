module Route exposing
    ( Route(..)
    , fromUrl
    , newUrl
    , parser
    , toString
    )

import Browser.Navigation as BN exposing (Key)
import Url exposing (Url)
import Url.Builder as UB
import Url.Parser as UP exposing ((</>), Parser)


type Route
    = Index
    | Detail { id : String }


parser : Parser (Route -> a) a
parser =
    UP.oneOf
        [ UP.map Index <| UP.top
        , UP.map (\id -> Detail { id = id }) <| UP.s "detail" </> UP.string
        ]


toString : Route -> String
toString route =
    case route of
        Index ->
            UB.absolute [] []

        Detail { id } ->
            UB.absolute [ "detail", id ] []


newUrl : Key -> Route -> Cmd msg
newUrl key =
    toString >> BN.pushUrl key


fromUrl : Url -> Maybe Route
fromUrl url =
    UP.parse parser url
