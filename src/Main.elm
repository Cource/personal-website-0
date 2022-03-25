module Main exposing (..)

import Constants exposing (..)
import Posts exposing (..)

import Browser
import Browser.Dom exposing (Viewport)
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
      , deviceClass  = Element.Desktop
      , posts        = posts
      , page         = Home
      }
    , Task.perform GotNewViewport Browser.Dom.getViewport
    )


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none


type Msg
    = GotNewViewport Viewport
    | ClickContact
    | GoHome
    | OpenBlogPost Post


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNewViewport viewport ->
            ( { model | windowHeight = round viewport.viewport.height
              , deviceClass = (Element.classifyDevice
                    { height = round viewport.viewport.height
                    , width  = round viewport.viewport.width
                    }).class
              }
            , Cmd.none
            )

        ClickContact ->
            ( model, Cmd.none )

        GoHome ->
            ( { model | page = Home }, Cmd.none )

        OpenBlogPost post ->
            ( { model | page = PostView post }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Element.layout
        [ fontSize <|
            case model.deviceClass of
                Phone -> 2
                _ -> 2
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
                    [ hero model
                    , portfolio model.deviceClass
                    , blog model.deviceClass model.posts
                    , footer model.deviceClass
                    ]

            PostView post ->
                postView post model.deviceClass model.page


scale : Int -> Int
scale x = 12 + round (toFloat x * 1.6 ^ toFloat x)

fontSize : Int -> Attr decorative msg
fontSize = Font.size << scale

-- Hero


hero : Model -> Element Msg
hero model =
    (case model.deviceClass of
        Phone -> column
        _     -> row) [ height (px (model.windowHeight - 20)) ]
        [ logo model.deviceClass model.page
        , info model.deviceClass
        ]


logo : Element.DeviceClass -> Page -> Element Msg
logo deviceClass page =
    let
        size = case deviceClass of
            Phone -> 100
            _     -> 120
    in
    Input.button
        [ Background.color bgTertiary
        , width <| px size
        , height <| px size
        , Border.roundEach { round0 | bottomRight = 20 }
        , alignTop
        ]
        { label = el [ width fill]
            (el [ centerY, centerX ]
                (image []
                    { src =
                        case page of
                            Home -> "/assets/J.svg"
                            _    -> "/assets/back.svg"
                    , description = ""
                    }
                )
            )
        , onPress = Just GoHome
        }

info : Element.DeviceClass -> Element Msg
info deviceClass =
    column
        [ spacing 54
        , paddingXY (
            case deviceClass of
                Phone -> 50
                _     -> 120
            )
            0
        , case deviceClass of
            Phone -> alignTop
            _     -> centerY
        ]
        [ column [ spacing 28 ]
            [ el
                [ fontSize 4
                , Font.color fgSecondary
                ]
                (text "Hi, I'm")
            , el
                [ fontSize (
                    case deviceClass of
                        Phone -> 4
                        _     -> 5
                  )
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
                        [ fontSize 4
                        , Region.heading 2
                        , firacodeFontFamily
                        ]
                        (text "Programmer")
                    ]
                ]
            , column [ spacing 8 ]
                [ infoSubText "and a"
                , row []
                    [ el
                        [ fontSize 4
                        , Region.heading 2
                        , montserratFontFamily
                        ]
                        (text "Designer")
                    ]
                ]
            ]
        , contactMeButton
        ]


infoSubText : String -> Element Msg
infoSubText value =
    el
        [ fontSize 3
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
                [ fontSize 3
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


portfolio : Element.DeviceClass -> Element Msg
portfolio deviceClass =
    let
        projects =
            [ { name = "Vote Camp", description = "A political data surveying utility" }
            , { name = "Lorem Gang", description = "A gang of lorem people who do lorem things for fun" }
            ]
    in
    el
        [ paddingEach { padding0 | left = (
            case deviceClass of
                Phone -> 40
                _     -> 180
            ) }
        , width fill
        ]
    <|
        column
            [ Border.roundEach { round0 | topLeft = 36 , bottomLeft = 36 }
            , Background.color bgSecondary
            , paddingEach { padding0 | top = 60, left = if deviceClass == Phone then 60 else 90 , bottom = 60 }
            , width fill
            , spacing 40
            , alignBottom
            ]
            [ el
                [ Font.color fgPrimary
                , fontSize 4
                , Font.heavy
                ]
                (text "My Portfolio")
            , row
                [ spacing 20
                , width fill
                , height <| px 420
                , scrollbarX
                ]
                <| List.map projectCard projects
            ]

type alias Project =
    { name : String
    , description : String
    }

projectCard : Project -> Element Msg
projectCard project =
    column
        [ Background.color bgPrimary
        , Border.rounded 20
        , height (px 400)
        , width  (px 300)
        , spacing 10
        , padding 20
        ]
        [ paragraph [ alignBottom ] [text project.description]
        , el
            [ fontSize 3
            , Font.heavy
            , alignBottom
            ]
            (text project.name)
        ]



-- Blog



postView : Post -> Element.DeviceClass -> Page -> Element Msg
postView post deviceClass page =
    column
    [ Background.color bgPrimary
    , height fill
    , width fill
    ]
    [ logo deviceClass page
    , column
        [ width (fill |> maximum 1500)
        , height fill
        , centerX
        , paddingXY
            (case deviceClass of
                Phone -> 50
                _      -> 200
            )
            50
        , spacing 20
        ]
        [ paragraph
            [ fontSize (if deviceClass == Phone then 4 else 5)
            , Font.heavy
            ] [text post.title]
        , el
            [ fontSize 3
            , Font.color fgSecondary
            ]
            (text post.date)
        , row [ spacing 5 ] <| List.map tag post.tags
        , paragraph
            [ paddingEach { padding0 | top = 20, bottom = 100 }
            , spacing 10
            ]
            -- Markdown viewer
            [ html <| Markdown.toHtml [Html.Attributes.attribute "class" "postBody"] post.bodyText ]
        ]
    , footer deviceClass
    ]


blog : Element.DeviceClass -> List Post -> Element Msg
blog deviceClass posts =
    column
        [ paddingEach { top = 120, left = (
            case deviceClass of
                Phone -> 60
                _     -> 240
            ), right = 240, bottom = 240 }
        , spacing 80
        , width fill
        ]
        [ el
            [ Font.heavy
            , fontSize 5
            ]
          <|
            text "Blog"
        , column [ spacing 60 ] <| List.map blogPost posts
        ]


blogPost : Post -> Element Msg
blogPost post =
    Input.button []
        { label =
            column
                [ spacing 20 ]
                [ el
                    [ fontSize 3
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
        [ spacing 10
        , Font.color fgSecondary
        ]
        [ text date
        , row [ spacing 10 ] <| List.map tag tags
        ]


tag : String -> Element msg
tag value =
    el
        [ Background.color bgSecondary
        , Border.rounded 20
        , paddingXY 10 5
        ]
    <|
        text value



-- Footer


footer : Element.DeviceClass -> Element Msg
footer deviceClass =
    row
        [ Font.color bgPrimary
        , Background.color bgTertiary
        , width fill
        , paddingXY (if deviceClass /= Phone then 240 else 60) 80 
        ]
        [ el [ fontSize 3, Font.semiBold ] <| text "Jeff Jacob Joy" ]

