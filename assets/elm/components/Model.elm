module Model exposing (Model, model)

type alias Model = 
    {
        messages: List String
        , input: String
        , pre: String
    }
model : Model
model = 
    {
        messages = [ "Hello World" ]
        , input = ""
        , pre = "|> "
    }
