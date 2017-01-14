module Html.SelectPrism exposing (selectp)

{-|
`selectp` is cool

@docs selectp
-}

import Html exposing (Attribute, Html, option, select, text)
import Html.Attributes exposing (selected, value)
import Html.Events exposing (on, targetValue)
import Json.Decode as Decode exposing (Decoder)
import Monocle.Prism exposing (Prism)


{-| `selectp` is wrapping up the idea of select box from a generic
comparable. However, Elm does everything through strings -- which is
why we're using the `Prism`. That `Prism` onus is on you. The args are:

1. [Prism](http://package.elm-lang.org/packages/arturopala/elm-monocle/latest/Monocle-Prism)
   from a `String` to our thing
2. A function from our thing to a msg for the onChange
3. The selected value
4. List of `Html.Attributes` for the `<select>` so you can have
   custom classes, etc.
5. List tuples of `( String, a )` where the `String` is the label
   for the option and the a is our thing.
-}
selectp : Prism String a -> (a -> msg) -> a -> List (Attribute msg) -> List ( String, a ) -> Html msg
selectp prism msger selected_ attrs labelValues =
    let
        change : Decoder msg
        change =
            Decode.map
                -- if the get fails then we keep the selected--but it
                -- shouldn't because you're such a great developer
                -- and wrote your prism to to cover all your cases
                (prism.getOption >> Maybe.withDefault selected_ >> msger)
                targetValue

        opt : ( String, a ) -> Html msg
        opt ( labl, val ) =
            option
                [ selected <| selected_ == val
                , value <| prism.reverseGet val
                ]
                [ text labl ]
    in
        select ((on "change" change) :: attrs) <|
            List.map opt labelValues
