module Main exposing (..)

import Browser
import Browser.Dom exposing (Viewport)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Task



--Constants


poppinsFontFamily : Attribute msg
poppinsFontFamily =
    Font.family
        [ Font.external
            { name = "Poppins"
            , url = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap"
            }
        , Font.sansSerif
        ]


firacodeFontFamily : Attribute msg
firacodeFontFamily =
    Font.family
        [ Font.external
            { name = "FiraCode"
            , url = "https://fonts.googleapis.com/css2?family=Fira+Code:wght@700&display=swap"
            }
        , Font.monospace
        ]


montserratFontFamily : Attribute msg
montserratFontFamily =
    Font.family
        [ Font.external
            { name = "Montserrat"
            , url = "https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap"
            }
        , Font.sansSerif
        ]


bgPrimary : Color
bgPrimary =
    rgb255 240 253 252


bgSecondary : Color
bgSecondary =
    rgb255 198 224 225


bgTertiary : Color
bgTertiary =
    rgb255 97 131 128


fgPrimary : Color
fgPrimary =
    rgb255 25 34 31


fgSecondary : Color
fgSecondary =
    rgb255 89 109 108



--Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    { windowHeight : Int
    , deviceClass : Element.DeviceClass
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { windowHeight = 1024
      , deviceClass = Element.Desktop
      }
    , Task.perform GotNewViewport Browser.Dom.getViewport
    )


subscriptions : model -> Sub msg
subscriptions _ =
    Sub.none


type Msg
    = GotNewViewport Viewport
    | ClickContact


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNewViewport viewport ->
            ( { windowHeight = round viewport.viewport.height
              , deviceClass = model.deviceClass
              }
            , Cmd.none
            )

        ClickContact ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Element.layout
        [ Font.size 14
        , poppinsFontFamily
        , Font.color fgPrimary
        ]
    <|
        column
            [ width fill
            , Background.color bgPrimary
            , height fill
            ]
            [ hero model.windowHeight model.deviceClass
            , portfolio
            ]


hero : Int -> Element.DeviceClass -> Element Msg
hero windowHeight _ =
    row [ height (px (windowHeight - 20)) ] [ logo, info ]


logo : Element msg
logo =
    el
        [ Background.color bgTertiary
        , width <| px 120
        , height <| px 120
        , alignTop
        ]
        (el [ centerY, centerX ]
            (image []
                { src = "/assets/J.svg"
                , description = ""
                }
            )
        )


info : Element Msg
info =
    column
        [ spacing 54
        , paddingXY 120 50
        ]
        [ column [ spacing 28 ]
            [ el
                [ Font.size 36
                , Font.color fgSecondary
                , poppinsFontFamily
                ]
                (text "Hi, I'm")
            , el
                [ Font.size 48
                , Font.heavy
                , poppinsFontFamily
                , Region.heading 1
                ]
                (text "Jeff Jacob Joy")
            ]
        , column [ spacing 20 ]
            [ column [ spacing 8 ]
                [ infoSubText "I'm a"
                , el
                    [ Font.size 36
                    , Region.heading 2
                    , firacodeFontFamily
                    ]
                    (text "Programmer")
                ]
            , column [ spacing 8 ]
                [ infoSubText "and a"
                , el
                    [ Font.size 36
                    , Region.heading 2
                    , montserratFontFamily
                    ]
                    (text "Designer")
                ]
            ]
        , contactMeButton
        ]


infoSubText : String -> Element Msg
infoSubText value =
    el
        [ Font.size 18
        , Font.color fgSecondary
        , poppinsFontFamily
        ]
    <|
        text value


contactMeButton : Element Msg
contactMeButton =
    Input.button
        [ Background.gradient
            { angle = 3 * pi / 4
            , steps = [ rgb255 33 53 54, fgPrimary ]
            }
        , paddingXY 40 23
        , Border.rounded 20
        ]
        { label =
            el
                [ Font.size 24
                , Font.color bgPrimary
                , Font.heavy
                , poppinsFontFamily
                ]
                (row [ spacing 20 ]
                    [ text "Contact Me"
                    , image []
                        { src = "/assets/phone.svg"
                        , description = ""
                        }
                    ]
                )
        , onPress = Just ClickContact
        }


portfolio : Element msg
portfolio =
    el
        [ paddingEach
            { top = 0
            , right = 0
            , bottom = 0
            , left = 180
            }
        , width fill
        ]
    <|
        column
            [ Border.roundEach
                { topLeft = 36
                , bottomLeft = 36
                , topRight = 0
                , bottomRight = 0
                }
            , Background.color bgSecondary
            , paddingXY 60 42
            , width fill
            , alignBottom
            ]
            [ el
                [ Font.color fgPrimary
                , Font.size 36
                , Font.heavy
                ]
                (text "My Portfolio")
            ]

