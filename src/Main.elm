module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Html exposing (button, div, programWithFlags, text)
import Html.Events exposing (onClick)


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = Increment
    | Decrement


type alias Flags =
    { name : String }


type alias Model =
    { value : Int
    , flags : Flags
    , show : Bool
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { value = 0
      , flags = flags
      , show = False
      }
    , Cmd.none
    )


view : Model -> Html.Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text model.flags.name ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | value = model.value + 1 }, Cmd.none )

        Decrement ->
            ( { model | value = model.value - 1 }, Cmd.none )
