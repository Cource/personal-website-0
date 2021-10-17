module Main exposing (..)

import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Task



--Constants


poppinsFontFamily =
    Font.family
        [ Font.external
            { name = "Poppins"
            , url = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap"
            }
        , Font.sansSerif
        ]


firacodeFontFamily =
    Font.family
        [ Font.external
            { name = "FiraCode"
            , url = "https://fonts.googleapis.com/css2?family=Fira+Code:wght@700&display=swap"
            }
        , Font.monospace
        ]


montserratFontFamily =
    Font.family
        [ Font.external
            { name = "Montserrat"
            , url = "https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap"
            }
        , Font.sansSerif
        ]


bgPrimary =
    rgb255 255 255 255


bgSecondary =
    rgb255 30 30 30


bgTertiary =
    rgb 0 0 0


fgPrimary =
    rgb 0 0 0


fgSecondary =
    rgb255 70 70 70


fgTertiary =
    rgb255 255 255 255


type alias FontSizes =
    { bigFont : Int
    , normalFont : Int
    }


fontSizes : FontSizes
fontSizes =
    { bigFont = 36
    , normalFont = 20
    }



--Main


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
subscriptions model =
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
    Element.layout [] <|
        column
            [ width fill
            , height fill
            ]
            [ hero model.deviceClass
            , portfolio
            ]


portfolio : Element msg
portfolio =
    column
        [ Border.roundEach
            { topLeft = 36
            , topRight = 36
            , bottomRight = 0
            , bottomLeft = 0
            }
        , Background.color bgSecondary
        , padding 50
        , width fill
        , alignBottom
        ]
        [ el
            [ Font.color fgTertiary
            , Font.size 40
            , Font.heavy
            ]
            (text "My Portfolio")
        ]


hero : Element.DeviceClass -> Element Msg
hero deviceClass =
    row [] [ logo, info ]


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
        [ spacing 60
        , centerX
        ]
        [ column [ spacing 28 ]
            [ infoSubText "Hi, I'm"
            , el
                [ Region.heading 1, poppinsFontFamily ]
                (text "Jeff Jacob Joy")
            ]
        , column [ spacing 35 ]
            [ column [ spacing 8 ]
                [ infoSubText "I'm a"
                , el
                    [ Region.heading 2, firacodeFontFamily ]
                    (text "Programmer")
                ]
            , column [ spacing 8 ]
                [ infoSubText "and a"
                , el
                    [ Region.heading 2, montserratFontFamily ]
                    (text "Designer")
                ]
            ]
        , contactMeButton
        ]


infoSubText : String -> Element Msg
infoSubText value =
    el [ Font.size fontSizes.bigFont, Font.color fgSecondary, poppinsFontFamily ] <| text value


contactMeButton : Element Msg
contactMeButton =
    el [ width fill ] <|
        Input.button
            [ Background.color bgSecondary
            , paddingXY 50 30
            , centerX
            , Border.roundEach
                { topLeft = 30
                , topRight = 30
                , bottomRight = 72
                , bottomLeft = 30
                }
            ]
            { label =
                el [ Font.size fontSizes.bigFont, Font.color fgTertiary, Font.heavy, poppinsFontFamily ]
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
