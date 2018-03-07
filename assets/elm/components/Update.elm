module Update exposing (..)

import Model exposing (Model)

type Msg = NoOp |
            SubmitText |
            Keypress Char |
            Delete


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        SubmitText ->
            { model | messages = model.input :: model.messages, input = "" }

        Keypress key ->
            {model | input = model.input ++ (String.fromChar key) }

        Delete ->
            { model | input = String.slice 0 -1 model.input }
