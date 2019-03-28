module Model exposing (InputFormControl, MatchDialogStep(..), Model, Msg(..), Participant, ParticipantMatch, defaultParticpant, init, participantMatches)

import Table


type alias Model =
    { participant : Participant
    , participantMatches : List ParticipantMatch
    , matchStep : MatchDialogStep
    , tableState : Table.State
    }


type alias Participant =
    { firstName : String
    , lastName : String
    , middleName : String
    , email : String
    }


type alias ParticipantMatch =
    { id : String
    , name : String
    , email : String
    }


type MatchDialogStep
    = None
    | Match
    | Verify


type Msg
    = Changed String String
    | Matched Bool
    | AcknowledgeDialog
    | SetTableState Table.State
    | ConfirmParticipant String


type alias InputFormControl =
    { id : String
    , label : String
    , getter : Participant -> String
    }


init : Participant -> List ParticipantMatch -> ( Model, Cmd Msg )
init particpant matches =
    let
        model =
            { participant = particpant
            , participantMatches = matches
            , matchStep = None
            , tableState = Table.initialSort "Name"
            }
    in
    ( model, Cmd.none )



-- DATA


participantMatches : List ParticipantMatch
participantMatches =
    [ ParticipantMatch (toString 156) "Joe Brinkman" "joe@brinkman.me"
    , ParticipantMatch (toString 201) "Fred Smith" "fred@smith.me"
    ]


defaultParticpant : Participant
defaultParticpant =
    { firstName = "Fred"
    , middleName = "Mateo"
    , lastName = "Brinkman"
    , email = "jbrinkman@engagesoftware.com"
    }
