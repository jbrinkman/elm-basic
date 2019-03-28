module View exposing (config, confirmButton, confirmColumn, onChange, view, viewDialogConfirmBody, viewDialogMatchBody, viewFormControl)

import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import List
import Model exposing (..)
import Table


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
            (case model.matchStep of
                Match ->
                    Just
                        { closeMessage = Just AcknowledgeDialog
                        , containerClass = Nothing
                        , header = Just (text "Possible Match!")
                        , body = Just (viewDialogMatchBody model)
                        , footer = Just (button [ onClick AcknowledgeDialog ] [ text "Cancel" ])
                        }

                Verify ->
                    Just
                        { closeMessage = Just AcknowledgeDialog
                        , containerClass = Nothing
                        , header = Just (text "Confirm Account")
                        , body = Just (viewDialogConfirmBody model)
                        , footer = Just (viewDialogConfirmFooter model)
                        }

                None ->
                    Nothing
            )
        ]


viewDialogMatchBody : Model -> Html Msg
viewDialogMatchBody model =
    div []
        [ text "It looks like you already have a membership with this association."
        , Table.view config model.tableState model.participantMatches
        ]


viewDialogConfirmBody : Model -> Html Msg
viewDialogConfirmBody model =
    let
        controlId =
            "confirmationCode"

        textLabel =
            "Confirmation Code"
    in
    div []
        [ text "We sent a one-time code to the email of the account you selected. Please enter the code below to confirm your account and auto-fill your membership data. \n"
        , div [ class "FormControl" ]
            [ label [ class "Label", for controlId ] [ text textLabel ]
            , input
                [ id controlId
                , class "Input"
                , type_ "Text"
                ]
                []
            ]
        ]


viewDialogConfirmFooter : Model -> Html Msg
viewDialogConfirmFooter model =
    -- TODO: Need to send to server for validating code
    div []
        [ button [ onClick ConfirmCode ] [ text "Verify" ]
        , button [ onClick AcknowledgeDialog ] [ text "Cancel" ]
        ]


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


config : Table.Config ParticipantMatch Msg
config =
    Table.config
        { toId = .id
        , toMsg = SetTableState
        , columns =
            [ confirmColumn
            , Table.stringColumn "Name" .name
            , Table.stringColumn "Email" .email
            ]
        }


confirmColumn : Table.Column ParticipantMatch Msg
confirmColumn =
    Table.veryCustomColumn
        { name = ""
        , viewData = confirmButton
        , sorter = Table.unsortable
        }


confirmButton : ParticipantMatch -> Table.HtmlDetails Msg
confirmButton { id } =
    Table.HtmlDetails []
        [ button
            [ class "btn-confirm"
            , onClick (ConfirmParticipant id)
            ]
            [ text "Confirm" ]
        ]
