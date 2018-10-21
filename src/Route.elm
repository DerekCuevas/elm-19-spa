module Route exposing (Route(..), parser)

import Browser.Navigation as BN exposing (Key)
import Url
import Url.Parser as UP exposing ((</>), Parser)


type Route
    = Index


parser : Parser (Route -> a) a
parser =
    UP.oneOf
        [ UP.map Index <| UP.top
        ]


toString : Route -> String
toString route =
    case route of
        Index ->
            "/"


newUrl : Key -> Route -> Cmd msg
newUrl key =
    toString >> BN.pushUrl key
