module Request.Repo exposing (getRepos)

import Config exposing (Config)
import Data.Repo as Repo exposing (Repo)
import Http exposing (Request)
import HttpBuilder as HB
import Json.Decode as JD
import Url.Builder as UB


getRepos : Config -> String -> Request (List Repo)
getRepos config username =
    let
        decoder =
            JD.list Repo.repoDecoder
    in
    UB.crossOrigin config.api [ "users", username, "repos" ] []
        |> HB.get
        |> HB.withExpect (Http.expectJson decoder)
        |> HB.toRequest
