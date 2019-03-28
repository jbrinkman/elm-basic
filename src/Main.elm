module Main exposing (Model, Msg(..), init, main, update, view)

import Date
import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import List
import Random.Pcg as Random
import Table exposing (defaultCustomizations)


main : Program Never Model Msg
main =
    program
        { init = init defaultParticpant participantMatches
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { participant : Participant
    , participantMatches : List ParticipantMatch
    , showParticipantMatch : Bool
    , tableState : Table.State
    }


type alias Participant =
    { firstName : String
    , lastName : String
    , middleName : String
    , email : String
    }


type alias ParticipantMatch =
    { id : Int
    , name : String
    , email : String
    }


init : Participant -> List ParticipantMatch -> ( Model, Cmd Msg )
init particpant matches =
    let
        model =
            { participant = particpant
            , participantMatches = matches
            , showParticipantMatch = False
            , tableState = Table.initialSort "Name"
            }
    in
    ( model, Cmd.none )



-- UPDATE


type Msg
    = Changed String String
    | Matched Bool
    | AcknowledgeDialog


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Changed id value ->
            let
                participant =
                    model.participant

                updatedParticipant =
                    case id of
                        "FirstName" ->
                            { participant | firstName = value }

                        "MiddleName" ->
                            { participant | middleName = value }

                        "LastName" ->
                            { participant | lastName = value }

                        "Email" ->
                            { participant | email = value }

                        _ ->
                            participant
            in
            ( { model | participant = updatedParticipant }, Random.generate Matched (Random.oneIn 2) )

        Matched hasMatch ->
            ( { model | showParticipantMatch = hasMatch }, Cmd.none )

        AcknowledgeDialog ->
            ( { model | showParticipantMatch = False }, Cmd.none )



-- VIEW


type alias InputFormControl =
    { id : String
    , label : String
    , getter : Participant -> String
    }


onChange : (String -> msg) -> Attribute msg
onChange message =
    on "change" (Json.map message targetValue)


view : Model -> Html.Html Msg
view model =
    let
        fields : List InputFormControl
        fields =
            [ { id = "FirstName", label = "First Name", getter = .firstName }
            , { id = "MiddleName", label = "Middle Name", getter = .middleName }
            , { id = "LastName", label = "Last Name", getter = .lastName }
            , { id = "Email", label = "Email", getter = .email }
            ]
    in
    div [ class "root" ]
        [ div [ class "ParticipantForm" ]
            [ div [ class "FieldGroup" ] (List.map (viewFormControl model.participant) fields)
            , button [ class "Btn" ] [ text "Submit" ]
            ]
        , Dialog.view
            (if model.showParticipantMatch then
                Just
                    { closeMessage = Just AcknowledgeDialog
                    , containerClass = Nothing
                    , header = Just (text "Possible Match!")
                    , body = Just (viewDialogMatchBody model)
                    , footer = Nothing
                    }

             else
                Nothing
            )
        ]


viewDialogMatchBody : Model -> Html Msg
viewDialogMatchBody model =
    p [] [ text ("Let me tell you something important..." ++ model.participant.firstName) ]


viewFormControl : Participant -> InputFormControl -> Html Msg
viewFormControl participant formControl =
    div [ class "FormControl" ]
        [ label [ class "Label", for formControl.id ] [ text formControl.label ]
        , input
            [ id formControl.id
            , class "Input"
            , type_ "Text"
            , value (formControl.getter participant)
            , onChange (Changed formControl.id)
            ]
            []
        ]



-- TABLE CONFIGURATION
-- DATA


participantMatches : List ParticipantMatch
participantMatches =
    [ ParticipantMatch 156 "Joe Brinkman" "joe@brinkman.me"
    , ParticipantMatch 201 "Fred Smith" "fred@smith.me"
    ]


defaultParticpant : Participant
defaultParticpant =
    { firstName = "Fred"
    , middleName = "Mateo"
    , lastName = "Brinkman"
    , email = "jbrinkman@engagesoftware.com"
    }
