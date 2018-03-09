module Update exposing (..)

import Msgs exposing (Msg(..))
import Model exposing (Model)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as JE
import Json.Decode as JD exposing (field)
import Ports exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SubmitText ->
            ({ model | messages = model.input :: model.messages, input = "" }, Cmd.none)

        Keypress key ->
            ({model | input = model.input ++ (String.fromChar key) }, Cmd.none)

        Delete ->
            ({ model | input = String.slice 0 -1 model.input }, Cmd.none)

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) = Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )
        
        JoinChannel ->
            joinChannel(model)
        
        ShowJoinedMessage channelName ->
            ( { model | messages = ("Joined channel " ++ channelName) :: model.messages }
            , Cmd.none
            )

        ShowLeftMessage channelName ->
            ( { model | messages = ("Left channel " ++ channelName) :: model.messages }
            , Cmd.none
            )
        
        SendMessage ->
            let
                payload =
                    (JE.object [ ( "id", JE.string model.token ), ( "body", JE.string model.input ) ])

                push_ =
                    Phoenix.Push.init "new:msg" ("room:" ++ model.token)
                        |> Phoenix.Push.withPayload payload

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.push push_ model.phxSocket
            in
                ( { model
                    | input = ""
                    , phxSocket = phxSocket
                  }
                , Cmd.map PhoenixMsg phxCmd
                )

        ReceiveChatMessage raw ->
            case JD.decodeValue chatMessageDecoder raw of
                Ok chatMessage ->
                    ( { model | messages = (chatMessage.id ++ ": " ++ chatMessage.body) :: model.messages }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        GetToken ->
            ( model, getToken() )

        Token token ->
            ({ model | token = token, messages = ("Token: " ++ token) :: model.messages }, Cmd.none )


userParams : Model -> JE.Value
userParams model =
    JE.object [ ( "id", JE.string model.token ) ]

joinChannel : Model -> (Model, Cmd Msg)
joinChannel model =
    let
        channel =
            Phoenix.Channel.init ("room:" ++ model.token)
                |> Phoenix.Channel.withPayload (userParams model)
                |> Phoenix.Channel.onJoin (always (ShowJoinedMessage ("room:" ++ model.token)))
                |> Phoenix.Channel.onClose (always (ShowLeftMessage ("room:" ++ model.token)))

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel model.phxSocket
    in
        ( { model | phxSocket = phxSocket |> Phoenix.Socket.on "new:msg" ("room:" ++ model.token) ReceiveChatMessage }
        , Cmd.map PhoenixMsg phxCmd
        )
chatMessageDecoder : JD.Decoder ChatMessage
chatMessageDecoder =
    JD.map2 ChatMessage
        (field "id" JD.string)
        (field "body" JD.string)

type alias ChatMessage =
    { id : String
    , body : String
    }