module Posts exposing (..)

type alias Post =
    { title : String
    , date : String
    , tags : List String
    , bodyText : String
    }

posts : List Post
posts =
    [ { title = "Joining the Emacs cult"
      , date  = "10 Oct 2021"
      , tags  = [ "Emacs", "Text Editor" ]
      , bodyText = """
I tried out emacs the other day because people who use it seem to love it.  
  
# Starting out
The first task was actually installing it in my linux system. there seemed to be different
ways to do it, I was using ubuntu then, and gnuEmacs was availble as a package in the
ubuntu official package repo. So i decided to install it using apt.  
  
## Old version adventure
Emacs is known for its heavy keyboard combination usage (I guess you could also call them
shortcut keys). And naturally as a beginner, I didn't know the key combos.
"""   }

    , { title = "Penpot Looks kinda dope"
      , date  = "3 Oct 2021"
      , tags  = [ "Penpot", "Figma", "Designing" ]
      , bodyText = """
Recently I checked out **Penpot**; a figma open-source alternative made in clojure script.  
  
# Introduction
Clojure is functional lisp like java, so clojure script should be javascript but functional
lisp like. I ran Penpot in a docker instance, and it was just as fast as figma which uses
a wasm binary to draw the editor canvas.

"""  }

    ]
