{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "package-deps"
, dependencies = [ "aff"
                 , "affjax"
                 , "arrays"
                 , "bifunctors"
                 , "console"
                 , "control"
                 , "effect"
                 , "either"
                 , "foldable-traversable"
                 , "foreign"
                 , "foreign-object"
                 , "http-methods"
                 , "lists"
                 , "maybe"
                 {-}
                 , "node-buffer"
                 , "node-fs-aff"
                 -}
                 , "optparse"
                 , "ordered-collections"
                 , "prelude"
                 , "psci-support"
                 , "simple-json"
                 , "tuples" 
                 , "transformers"
                 ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
