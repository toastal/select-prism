module Html.SelectPrism exposing (selectp, selectpm)

{-|
`selectp` is cool

@docs selectp, selectpm
-}

import Html exposing (Attribute, Html, option, select, text)
import Html.Attributes exposing (multiple, selected, value)
import Html.Events exposing (on, targetValue)
import Json.Decode as Decode exposing (Decoder)
import Monocle.Prism exposing (Prism)


{-| `selectp` is wrapping up the idea of select box from a generic
comparable. However, Elm does everything through strings -- which is
why we're using the `Prism`. That `Prism` onus is on you. The args are:

1. [Prism](http://package.elm-lang.org/packages/arturopala/elm-monocle/latest/Monocle-Prism)
   from a `String` to our thing
2. A function from the attempt to get--`Result String a`, where `a` is
   our thing--to a msg for the onChange
3. The selected value
4. List of `Html.Attributes` for the `<select>` so you can have
   custom classes, etc.
5. List tuples of `( String, a )` where the `String` is the label
   for the option and the a is our thing.
-}
selectp : Prism String a -> (Result String a -> msg) -> a -> List (Attribute msg) -> List ( String, a ) -> Html msg
selectp prism msger selected_ attrs labelValues =
    let
        resultFromString : String -> Result String a
        resultFromString x =
            case prism.getOption x of
                Just y ->
                    Ok y

                _ ->
                    Err <| "Failed to get a valid option from " ++ toString x

        change : Decoder msg
        change =
            Decode.map (resultFromString >> msger) targetValue

        opt : ( String, a ) -> Html msg
        opt ( labl, val ) =
            option
                [ selected <| selected_ == val
                , value <| prism.reverseGet val
                ]
                [ text labl ]
    in
        select (on "change" change :: attrs) <|
            List.map opt labelValues


{-| Like `selectp`, but a `<select multiple>` which takes a list of
selected values and the Msg needs to be a list of results. Note:
[`selectOptions`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLSelectElement#Browser_compatibility)
isn't support in Internet Explorer and I don't care enough to support
it (and maybe you shouldn't either).
-}
selectpm : Prism String a -> (List (Result String a) -> msg) -> List a -> List (Attribute msg) -> List ( String, a ) -> Html msg
selectpm prism msger selecteds attrs labelValues =
    let
        resultFromString : String -> Result String a
        resultFromString x =
            case prism.getOption x of
                Just y ->
                    Ok y

                _ ->
                    Err <| "Failed to get a valid option from " ++ toString x

        -- Don't ask
        change : Decoder msg
        change =
            let
                loop idx xs =
                    Decode.maybe
                        (Decode.field (toString idx)
                            (Decode.field "value" Decode.string
                                |> Decode.map resultFromString
                            )
                        )
                        |> Decode.andThen
                            (Maybe.map (\x -> loop (idx + 1) (x :: xs))
                                >> Maybe.withDefault (Decode.succeed xs)
                            )
            in
                loop 0 []
                    |> Decode.at [ "target", "selectedOptions" ]
                    |> Decode.map (List.reverse >> msger)

        opt : ( String, a ) -> Html msg
        opt ( labl, val ) =
            option
                [ selected <| List.any ((==) val) selecteds
                , value <| prism.reverseGet val
                ]
                [ text labl ]
    in
        select (on "change" change :: multiple True :: attrs) <|
            List.map opt labelValues
