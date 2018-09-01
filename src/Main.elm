module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {
    }


initModel : Model
initModel = 
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )



-- UPDATE


type Msg
    = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
          



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Nasa Image Search"
    , body = [
        h1 [] [text "Hello World"]
    ]
    }
