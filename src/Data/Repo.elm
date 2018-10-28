module Data.Repo exposing (Repo, repoDecoder)

import Json.Decode as JD exposing (Decoder)
import Json.Decode.Pipeline as JDP


type alias RepoId =
    Int


type alias Repo =
    { id : RepoId
    , name : String
    , description : Maybe String
    , htmlUrl : String
    , stargazersCount : Int
    }


repoDecoder : Decoder Repo
repoDecoder =
    JD.succeed Repo
        |> JDP.required "id" JD.int
        |> JDP.required "name" JD.string
        |> JDP.optional "description" (JD.maybe JD.string) Nothing
        |> JDP.required "html_url" JD.string
        |> JDP.required "stargazers_count" JD.int
