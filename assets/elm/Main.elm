module Main exposing (..)

import Html exposing (Html)
import Update exposing (update, Msg)
import Model exposing (Model, model)
import View exposing (view)

main : Program Never Model Msg
main = 
    Html.beginnerProgram { model = model, update = update, view = view }



