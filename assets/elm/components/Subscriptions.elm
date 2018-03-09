module Subscriptions exposing (subscriptions)

import Phoenix.Socket exposing (listen)
import Model exposing (Model)
import Msgs exposing (Msg(..))
import Ports exposing (..)

subscriptions : Model -> Sub Msg
subscriptions model =
   Sub.batch 
    [ Phoenix.Socket.listen model.phxSocket PhoenixMsg
    , token Token
    ]