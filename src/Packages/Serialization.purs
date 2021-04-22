module Packages.Serialization (readPackages, writePackageUse)

where

import Data.Bifunctor (rmap)
import Data.Either (Either)
import Data.Map (toUnfoldable) as Map
import Data.Tuple (Tuple)
import Foreign (MultipleErrors)
import Foreign.Object (fromFoldable, toUnfoldable)
import Packages.Types
import Simple.JSON as SJSON
import Packages.JSON (prettyJSON)

readPackages :: String -> Either MultipleErrors Packages
readPackages s = 
  rmap toUnfoldable (SJSON.readJSON s )

writePackageUse :: PackageUse -> String
writePackageUse packageUse =
  let
    tuples :: Array (Tuple PackageName (Array PackageName))
    tuples = Map.toUnfoldable packageUse
    packageUseObject = fromFoldable tuples
  in
    -- Justin's writeJSON is not very pretty!  We'll just use the JavaScript prettifier.
    -- JSON.writeJSON packageUseObject
    prettyJSON packageUseObject
