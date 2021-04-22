{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "package-usage"
, dependencies = [ "aff"
                 , "affjax"
                 , "arrays"
                 , "bifunctors"
                 , "console"
                 , "effect"
                 , "either"
                 , "foldable-traversable"
                 , "foreign"
                 , "foreign-object"
                 , "http-methods"
                 , "maybe"
                 , "node-buffer"
                 , "node-fs-aff"
                 , "ordered-collections"
                 , "prelude"
                 , "psci-support"
                 , "simple-json"
                 , "tuples" 
                 ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
