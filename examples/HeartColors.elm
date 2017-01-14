module Main exposing (..)

import Html exposing (..)
import Html.SelectPrism exposing (selectp)
import Monocle.Prism exposing (Prism)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }


view : Model -> Html Msg
view { selectedColor } =
    div []
        [ h1 [] [ text "Select A Heart Color" ]
        , h3 [] [ text <| "Current : " ++ colorp.reverseGet selectedColor ]
          -- Here's the `selectp` in the view
        , selectp colorp ChangeColor selectedColor [] colorOptions
        ]



--- Building the Prism -----------------------------------------------


type Color
    = Red
    | Blue
    | Green


{-| You the developer are responsible for this `Prism`s correctness
-}
colorp : Prism String Color
colorp =
    let
        colorFromString : String -> Maybe Color
        colorFromString s =
            case s of
                "red" ->
                    Just Red

                "blue" ->
                    Just Blue

                "green" ->
                    Just Green

                _ ->
                    Nothing

        colorToString : Color -> String
        colorToString c =
            case c of
                Red ->
                    "red"

                Blue ->
                    "blue"

                Green ->
                    "green"
    in
        Prism colorFromString colorToString



--- Other TEA stuff --------------------------------------------------


type alias Model =
    { selectedColor : Color }


initModel : Model
initModel =
    { selectedColor = Red }


type Msg
    = ChangeColor Color


update : Msg -> Model -> Model
update (ChangeColor color) model =
    { model | selectedColor = color }


colorOptions : List ( String, Color )
colorOptions =
    [ ( "❤️  Red", Red )
    , ( "💙 Blue", Blue )
    , ( "💚 Green", Green )
    ]
