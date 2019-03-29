module Request.Repo exposing (getRepos)

import Config exposing (Config)
import Data.Repo exposing (Repo)
import Data.User exposing (UserId)
import Http exposing (Request)
import HttpBuilder as HB
import Json.Decode as JD
import Url.Builder as UB


getRepos : Config -> UserId -> Request (List Repo)
getRepos config userId =
    let
        decoder =
            JD.list Data.Repo.repoDecoder
    in
    UB.crossOrigin config.api [ "users", userId, "repos" ] []
        |> HB.get
        |> HB.withExpect (Http.expectJson decoder)
        |> HB.toRequest
