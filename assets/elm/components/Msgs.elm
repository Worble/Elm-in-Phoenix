module Msgs exposing (..)

import Phoenix.Socket
import Json.Encode as JE

type Msg 
        = NoOp
        | SubmitText 
        | Keypress Char 
        | Delete
        | PhoenixMsg (Phoenix.Socket.Msg Msg)
        | JoinChannel
        | ShowJoinedMessage String
        | ShowLeftMessage String
        | SendMessage
        | ReceiveChatMessage JE.Value
        | GetToken
        | Token String