module Update exposing (update)

import Model exposing (MatchDialogStep(..), Model, Msg(..))
import Random.Pcg as Random
import Ternary exposing ((?))


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
            ( { model | matchStep = hasMatch ? Match <| None }, Cmd.none )

        ConfirmParticipant id ->
            -- TODO: Send off email (server function) to the user with the confirmation code
            ( { model | matchStep = Verify }
            , Cmd.none
            )

        AcknowledgeDialog ->
            ( { model | matchStep = None }, Cmd.none )

        ConfirmCode ->
            -- TODO: Validate code from user
            ( { model | matchStep = None }, Cmd.none )

        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )
