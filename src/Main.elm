module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onInput)
import Http
import Json.Decode
import RemoteData
import Url.Builder



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
    , images : RemoteData.WebData (List (List String))
    }


initModel : Model
initModel =
    { searchTerm = Nothing
    , images = RemoteData.NotAsked
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )



-- UPDATE


type Msg
    = SearchInput String
    | PerformSearch
    | SearchResponse (RemoteData.WebData (List (List String)))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInput searchTerm ->
            ( { model | searchTerm = Just searchTerm }, Cmd.none )

        PerformSearch ->
            ( model, getSearchResults model.searchTerm )

        SearchResponse results ->
            ( { model | images = results }, Cmd.none )



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



-- JSON


collectionDecoder : Json.Decode.Decoder (List (List String))
collectionDecoder =
    Json.Decode.at [ "collection", "items" ] (Json.Decode.list linksDecoder)


linksDecoder : Json.Decode.Decoder (List String)
linksDecoder =
    Json.Decode.field "links" (Json.Decode.list hrefDecoder)


hrefDecoder : Json.Decode.Decoder String
hrefDecoder =
    Json.Decode.field "href" Json.Decode.string



-- HTTP


nasaImageApiUrl : Maybe String -> String
nasaImageApiUrl searchTerm =
    Url.Builder.crossOrigin "https://images-api.nasa.gov"
        [ "search" ]
        [ Url.Builder.string "q" (Maybe.withDefault "" searchTerm)
        , Url.Builder.string "media_type" "image"
        ]


getSearchResults : Maybe String -> Cmd Msg
getSearchResults searchTerm =
    Http.get (nasaImageApiUrl searchTerm) collectionDecoder
        |> RemoteData.sendRequest
        |> Cmd.map SearchResponse
