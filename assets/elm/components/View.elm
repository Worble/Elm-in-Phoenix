module View exposing (view)

import Html exposing (Html, div, text, Attribute, input, span, button)
import Html.Attributes exposing (id, type_, value, class, tabindex, disabled, autofocus)
import Html.Events exposing (onWithOptions, onSubmit, onInput, keyCode, Options, onClick)
import Model exposing (Model, model)
import Update exposing (update)
import Msgs exposing (Msg(..))
import Json.Decode as Json
import Char
import Svg exposing (svg, line, animate)
import Svg.Attributes exposing (width, height, viewBox, x1, y1, x2, y2, stroke, strokeWidth, attributeName, attributeType, from, to, dur, repeatCount)

options : Options
options =
    { stopPropagation = True
    , preventDefault = True
    }

onKeypress : (Int -> msg) -> Attribute msg
onKeypress tagger =
  onWithOptions "keypress" options (Json.map tagger which)

which : Json.Decoder Int
which =
  Json.field "which" Json.int

onKeyup : (Int -> msg) -> Attribute msg
onKeyup tagger =
  onWithOptions "keyup" options (Json.map tagger keycode)

keycode : Json.Decoder Int
keycode =
  Json.field "key" Json.int

handleKeys : Int -> Msg
handleKeys number =
  case number of
    13 ->
        Msgs.SendMessage

    8 ->
        Msgs.Delete

    _ -> 
        Msgs.Keypress (Char.fromCode number)

view : Model -> Html Msg
view model =
    div [ id "application", class "application", tabindex 1, onKeypress handleKeys ]
    [
        button [ onClick GetToken ] [ text "Get Token"]
        , button [ onClick JoinChannel ] [ text "Join Channel"]
        , div []
            (List.map displayMessages (List.reverse model.messages))
        , div [ class "flex" ]
        [   
            span[] 
                [ text (model.pre ++ model.input)
            ]
            , span[] 
                [ svg [ width "16", height "16", viewBox "0 0 16 16" ]
                [ line [ x1 "0", y1 "15", x2 "0", y2 "1", stroke "white", strokeWidth "2" ] 
                [ animate [ attributeName "opacity", attributeType "XML", from "1", to "0.2", dur "0.9", repeatCount "indefinite" ] []
                ] ]
            ]
        ]
    ]
    
displayMessages : String -> Html Msg
displayMessages string = 
    div []
        [
            text string
        ]