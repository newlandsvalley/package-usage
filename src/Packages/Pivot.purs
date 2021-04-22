module Packages.Pivot (pivot)

where

import Packages.Types
import Data.Maybe (Maybe(..))
import Data.Map (empty, insert, lookup)
import Data.Tuple (Tuple(..))
import Data.Array (cons, foldr, singleton)

-- We use foldr in preference to foldl so we get usage sorted alphabetically for free

addUsage :: PackageName ->  Dependency -> PackageUse -> PackageUse
addUsage packageName dependency packages = 
  case lookup dependency packages of 
    Nothing -> 
      insert dependency (singleton packageName) packages 
    Just usages ->
      insert dependency (cons packageName usages) packages

addDependenciesUsage :: Tuple PackageName Package -> PackageUse -> PackageUse
addDependenciesUsage (Tuple packageName package) packages = 
  foldr (addUsage packageName) packages package.dependencies

-- | reverse the dependencies
pivot :: Packages -> PackageUse
pivot packages =
  foldr addDependenciesUsage empty packages

