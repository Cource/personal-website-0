--Constants


module Constants exposing (..)

import Element exposing (Attribute, Color, rgb255)
import Element.Font as Font


poppinsFontFamily : Attribute msg
poppinsFontFamily =
    Font.family
        [ Font.external
            { name = "Poppins"
            , url = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap"
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


--

padding0 =
    { top    = 0
    , right  = 0
    , bottom = 0
    , left   = 0
    }

round0 =
    { topLeft     = 0
    , topRight    = 0
    , bottomLeft  = 0
    , bottomRight = 0
    }
