module Packages.Serialization 
  ( readPackages
  , writeDependenciesJSON
  , writePackageUseJSON
  , writePathsJSON)

where

import Prelude (map)
import Data.Array (fromFoldable) as A
import Data.Bifunctor (rmap)
import Data.Either (Either)
import Data.List (intercalate)
import Data.Map (toUnfoldable) as Map
import Data.Set as S
import Data.Tuple (Tuple)
import Foreign (MultipleErrors)
import Foreign.Object (fromFoldable, toUnfoldable)
import Packages.Types
import Simple.JSON as SJSON
import Packages.JSON (prettyJSON)

readPackages :: String -> Either MultipleErrors Packages
readPackages s = 
  rmap toUnfoldable (SJSON.readJSON s )


-- Justin's writeJSON is not very pretty!  We'll just use the JavaScript prettifier.
-- SJSON.writeJSON packageUseObject  

writePackageUseJSON :: PackageUse -> String
writePackageUseJSON packageUse =
  prettyJSON packageUseObject

  where
    tuples :: Array (Tuple PackageName (Array PackageName))
    tuples = Map.toUnfoldable (map (S.toUnfoldable) packageUse)
    packageUseObject = fromFoldable tuples
  

writeDependenciesJSON :: S.Set String -> String 
writeDependenciesJSON deps = 
  prettyJSON depsArray

  where 
    depsArray :: Array String
    depsArray = S.toUnfoldable deps

writePathsJSON :: Paths -> String
writePathsJSON paths =
  prettyJSON (map pathString (A.fromFoldable paths))

  where
    pathString :: Path -> String 
    pathString path = 
      intercalate "->" path  

