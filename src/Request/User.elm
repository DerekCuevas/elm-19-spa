module Request.User exposing (getUser, getUsers)

import Config exposing (Config)
import Data.User as User exposing (User)
import Http exposing (Request)
import HttpBuilder as HB
import Json.Decode as JD
import Url.Builder as UB


getUser : Config -> String -> Request User
getUser config username =
    UB.crossOrigin config.api [ "users", username ] []
        |> HB.get
        |> HB.withExpect (Http.expectJson User.userDecoder)
        |> HB.toRequest


getUsers : Config -> Request (List User)
getUsers config =
    let
        decoder =
            JD.list User.userDecoder
    in
    UB.crossOrigin config.api [ "users" ] []
        |> HB.get
        |> HB.withExpect (Http.expectJson decoder)
        |> HB.toRequest
