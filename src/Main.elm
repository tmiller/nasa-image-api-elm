module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode



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
    { searchTerm : String
    }


initModel : Model
initModel =
    { searchTerm = ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )



-- UPDATE


type Msg
    = SearchInput String
    | PerformSearch Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInput searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        PerformSearch key ->
            case key of
                13 ->
                    ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Nasa Image Search"
    , body =
        [ h1 [] [ text "Nasa Image Search" ]
        , section []
            [ input
                [ placeholder "Search"
                , value model.searchTerm
                , onInput SearchInput
                , onKeyUp PerformSearch
                ]
                []
            ]
        ]
    }



-- EVENTS


onKeyUp : (Int -> msg) -> Attribute msg
onKeyUp tagger =
    on "keyup" (Json.Decode.map tagger keyCode)
