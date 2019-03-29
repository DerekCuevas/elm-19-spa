module Extra.Http exposing (errorToString)

import Http exposing (Error(..))


errorToString : Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Bad Url (" ++ url ++ ")."

        Timeout ->
            "Connection Timeout."

        NetworkError ->
            "Network Error."

        BadStatus { status } ->
            "Bad Status (" ++ String.fromInt status.code ++ ")."

        BadPayload string { status } ->
            "Bad Payload (" ++ String.fromInt status.code ++ ")."
