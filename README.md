# select-prism

A `<select>` is basically the <abbr title="user interface">UI</abbr> representation of a [union type](http://elm-lang.org/docs/syntax#union-types) or <abbr title="algebraic data type">ADT</abbr>.Using a `Prism` and it’s data structure for a data transformation that’s not quite isomorphic, we can use go from an <abbr title="algebraic data type">ADT</abbr> to a `String` and back like we’d prefer to do.


```elm
import Html exposing (..)
import Html.SelectPrism exposing (selectp)


view : Model -> Html Msg
view { selectedColor } =
    -- Right Here ↓
    selectp colorp ChangeColor selectedColor [] colorOptions


colorOptions : List ( String, Color )
colorOptions =
    [ ( "❤️  Red", Red )
    , ( "💙 Blue", Blue )
    , ( "💚 Green", Green )
    ]


type alias Model =
    { selectedColor : Color }


type Msg
    = ChangeColor (Result String Color)


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

                "green" ->
                    Just Green

                "blue" ->
                    Just Blue

                _ ->
                    Nothing

        colorToString : Color -> String
        colorToString c =
            case c of
                Red ->
                    "red"

                Green ->
                    "green"

                Blue ->
                    "blue"
    in
        -- Using `Prism` as a constructor
        Prism colorFromString colorToString
```

Do check out [the example](https://github.com/toastal/select-prism/blob/master/examples/HeartColors.elm) and/or read [my blog entry](https://toast.al/posts/2017-01-13-playing-with-prisms-for-the-not-so-isomorphic.html) which goes into more depth.

---

## Project & Community Notes

This project is regrettably available on [GitHub](https://github.com/toastal/select-prism). The Elm community has tied itself to the closed-source, Microsoft-owned code forge of GitHub for package registry and identity. This does not protect the privacy or freedom of its community members.

---

## License

This project is licensed under Apache License 2.0 - [LICENSE](./LICENSE) file for details.

## Funding

If you want to make a small contribution to the maintanence of this & other projects

- [Liberapay](https://liberapay.com/toastal/)
- [Bitcoin: `39nLVxrXPnD772dEqWFwfZZbfTv5BvV89y`](bitcoin://39nLVxrXPnD772dEqWFwfZZbfTv5BvV89y?message=Funding%20toastal%E2%80%99s%20Elm%20select-prism%20development
) (verified on [Keybase](https://keybase.io/toastal/sigchain#690220ca450a3e73ff800c3e059de111d9c1cd2fcdaf3d17578ad312093fff2c0f))
- [Zcash: `t1a9pD1D2SDTTd7dbc15KnKsyYXtGcjHuZZ`](zcash://t1a9pD1D2SDTTd7dbc15KnKsyYXtGcjHuZZ?message=Funding%20toastal%E2%80%99s%20Elm%20select-prism%20development) (verified on [Keybase](https://keybase.io/toastal/sigchain#65c0114a3c8ffb46e39e4d8b5ee0c06c9eb97a02c4f6c42a2b157ca83b8c47c70f))
