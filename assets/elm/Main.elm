module Main exposing (..)

import Html exposing (Html)
import Update exposing (update, joinChannel)
import Model exposing (Model, model)
import View exposing (view)
import Msgs exposing (Msg(..))
import Subscriptions exposing (subscriptions)

main : Program Never Model Msg
main = 
    Html.program { init = (model, Cmd.none), update = update, view = view, subscriptions = subscriptions }

