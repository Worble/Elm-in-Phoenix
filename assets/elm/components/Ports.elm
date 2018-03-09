port module Ports exposing (..)

port getToken : () -> Cmd msg
port token : (String -> msg) -> Sub msg
