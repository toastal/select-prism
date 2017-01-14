module Main exposing (..)

import Html exposing (..)
import Html.SelectPrism exposing (selectp, selectpm)
import Monocle.Prism exposing (Prism)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }


view : Model -> Html Msg
view { selectedColor, selectedColors } =
    let
        okdColors : List Color
        okdColors =
            List.foldr
                (\rc ->
                    case rc of
                        Ok c ->
                            (::) c

                        _ ->
                            identity
                )
                []
                selectedColors
    in
        div []
            [ h1 [] [ text "Select A Heart Color" ]
            , h3 []
                [ text <|
                    case Result.map colorp.reverseGet selectedColor of
                        Ok color ->
                            "Current: " ++ color

                        Err e ->
                            e
                ]
              -- Here's the `selectp` in the view
            , selectp colorp
                ChangeColor
                (Result.withDefault Red selectedColor)
                []
                colorOptions
            , h3 []
                [ text
                    << (++) "Current: "
                    << String.join ", "
                  <|
                    List.map colorp.reverseGet okdColors
                ]
              -- Here's the `selectpm' in the view
            , selectpm colorp ChangeColors okdColors [] colorOptions
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
    { selectedColor : Result String Color
    , selectedColors : List (Result String Color)
    }


initModel : Model
initModel =
    { selectedColor = Ok Red
    , selectedColors = [ Ok Blue, Ok Green ]
    }


type Msg
    = ChangeColor (Result String Color)
    | ChangeColors (List (Result String Color))


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeColor rcolor ->
            { model | selectedColor = rcolor }

        ChangeColors rcolors ->
            Debug.log "ChangeColors" { model | selectedColors = rcolors }


colorOptions : List ( String, Color )
colorOptions =
    [ ( "❤️  Red", Red )
    , ( "💙 Blue", Blue )
    , ( "💚 Green", Green )
    ]
