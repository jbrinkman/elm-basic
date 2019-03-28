module Main exposing (main)

import Html exposing (program)
import Model exposing (Model, Msg)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    program
        { init = Model.init Model.defaultParticpant Model.participantMatches
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
