module Model exposing (Model, model)
import Phoenix.Socket
import Msgs exposing (Msg(..))

type alias Model = 
    {
        messages: List String
        , input: String
        , pre: String
        , phxSocket : Phoenix.Socket.Socket Msg
        , token: String
    }
model : Model
model = 
    {
        messages = [ "Hello World" ]
        , input = ""
        , pre = "|> "
        , phxSocket = socket
        , token = ""
    }

socket : Phoenix.Socket.Socket Msg
socket =
    Phoenix.Socket.init "ws://localhost:4000/socket/websocket" 
        |> Phoenix.Socket.withDebug
        -- |> Phoenix.Socket.on "new:msg" "room:lobby" ReceiveChatMessage
