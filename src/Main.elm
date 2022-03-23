module Main exposing (..)

import Browser
import Browser.Dom exposing (Viewport)
import Constants exposing (..)
import Markdown
import Html.Attributes
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Task


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type Page
    = Home
    | PostView Post


type alias Model =
    { windowHeight : Int
    , deviceClass : Element.DeviceClass
    , posts : List Post
    , page : Page
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { windowHeight = 1024
      , deviceClass = Element.Desktop
      , posts =
            [ { title = "Switching to Emacs"
              , date = "10 Oct 2021"
              , tags = [ "Emacs", "Text Editor" ]
              , bodyText = "Emacs has been a really helpful experience to me especially with Magit, Evilmode and Orgmode. So I have decided to switch all of my programming and typing stuff to emacs."
              }
            , { title = "Figma like open source tool penpot looks nice"
              , date = "3 Oct 2021"
              , tags = [ "Penpot", "Figma", "Designing" ]
              , bodyText =
                    """# Introduction
Recently I checked out **Penpot**; a figma open-source alternative made in clojure script.  
Clojure is functional lisp like java, so clojure script should be javascript but functional lisp like. I ran Penpot in a docker instance, and it was just as fast as figma which uses a wasm binary to draw the editor canvas."""
              }
            ]
      , page = Home
      }
    , Task.perform GotNewViewport Browser.Dom.getViewport
    )


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none


type Msg
    = GotNewViewport Viewport
    | ClickContact
    | OpenBlogPost Post


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNewViewport viewport ->
            ( { model | windowHeight = round viewport.viewport.height }
            , Cmd.none
            )

        ClickContact ->
            ( model, Cmd.none )

        OpenBlogPost post ->
            ( { model | page = PostView post }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Element.layout
        [ Font.size 14
        , poppinsFontFamily
        , Font.color fgPrimary
        ]
    <|
        case model.page of
            Home ->
                column
                    [ width fill
                    , Background.color bgPrimary
                    , height fill
                    ]
                    [ hero model.windowHeight model.deviceClass
                    , portfolio
                    , blog model.posts
                    , footer
                    ]

            PostView post ->
                postView post



-- Hero


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
                ]
                (text "Hi, I'm")
            , el
                [ Font.size 48
                , Font.heavy
                , Region.heading 1
                ]
                (text "Jeff Jacob Joy")
            ]
        , column [ spacing 20 ]
            [ column [ spacing 8 ]
                [ infoSubText "I'm a"
                , row []
                    [ el
                        [ Font.size 36
                        , Region.heading 2
                        , firacodeFontFamily
                        ]
                        (text "Programmer")
                    , el [] (text "|")
                    ]
                ]
            , column [ spacing 8 ]
                [ infoSubText "and a"
                , row []
                    [ el
                        [ Font.size 36
                        , Region.heading 2
                        , montserratFontFamily
                        ]
                        (text "Designer")
                    , el [] (text "arrow here")
                    ]
                ]
            ]
        , contactMeButton
        ]


infoSubText : String -> Element Msg
infoSubText value =
    el
        [ Font.size 18
        , Font.color fgSecondary
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



-- Portfolio


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



-- Blog


type alias Post =
    { title : String
    , date : String
    , tags : List String
    , bodyText : String
    }


postView : Post -> Element Msg
postView post =
    column
        [ width fill
        , Background.color bgPrimary
        , paddingXY 200 100
        , spacing 20
        ]
        [ el
            [ Font.size 36
            , Font.heavy
            ]
            (text post.title)
        , el
            [ Font.size 20
            , Font.color fgSecondary
            ]
            (text post.date)
        , row [ spacing 5 ] <| List.map postTag post.tags
        , paragraph [] [html <| Markdown.toHtml [Html.Attributes.attribute "class" "postBody"] post.bodyText]
        ]

postTag : String -> Element msg
postTag value =
    el
        [ paddingEach { top=0, left=0, right=20, bottom=0 }
        , Font.color fgSecondary
        ]
        (text value)


blog : List Post -> Element Msg
blog posts =
    column
        [ paddingEach { top = 90, left = 240, right = 240, bottom = 240 }
        , spacing 50
        ]
        [ el
            [ Font.heavy
            , Font.size 48
            ]
          <|
            text "Blog"
        , column [ spacing 40 ] <| List.map blogPost posts
        ]


blogPost : Post -> Element Msg
blogPost post =
    Input.button []
        { label =
            column
                [ spacing 10 ]
                [ el
                    [ Font.size 24
                    , Font.heavy
                    ]
                  <|
                    text post.title
                , blogMetadata post.date post.tags
                , paragraph
                    [ Font.color fgSecondary ]
                    [ text <| String.append (String.slice 0 200 post.bodyText) "..." ]
                ]
        , onPress = Just (OpenBlogPost post)
        }


blogMetadata : String -> List String -> Element msg
blogMetadata date tags =
    row
        [ Background.color bgSecondary
        , paddingXY 10 3
        , spacing 10
        , Font.color fgSecondary
        , Border.rounded 5
        ]
        [ text date
        , row [ spacing 5 ] <| List.map tag tags
        ]


tag : String -> Element msg
tag value =
    el
        [ Background.color bgPrimary
        , Border.rounded 5
        , paddingXY 7 3
        ]
    <|
        text value



-- Footer


footer : Element Msg
footer =
    row
        [ Font.color bgPrimary
        , Background.color bgTertiary
        , width fill
        , paddingXY 240 40
        ]
        [ el [ Font.size 24, Font.semiBold ] <| text "Jeff Jacob Joy" ]

