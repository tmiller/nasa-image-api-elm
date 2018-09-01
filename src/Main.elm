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
    { searchTerm : Maybe String
    }


initModel : Model
initModel =
    { searchTerm = Nothing
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )



-- UPDATE


type Msg
    = SearchInput String
    | PerformSearch


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInput searchTerm ->
            ( { model | searchTerm = Just searchTerm }, Cmd.none )

        PerformSearch ->
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
                , value (Maybe.withDefault "" model.searchTerm)
                , onInput SearchInput
                , onEnterKey PerformSearch
                ]
                []
            ]
        ]
    }



-- EVENTS


onEnterKey : msg -> Attribute msg
onEnterKey message =
    on "keyup"
        (keyCode
            |> Json.Decode.andThen (enterKeyDecoder message)
        )


enterKeyDecoder : msg -> Int -> Json.Decode.Decoder msg
enterKeyDecoder message keycode =
    case keycode of
        13 ->
            Json.Decode.succeed message

        _ ->
            Json.Decode.fail "Not enter key"
