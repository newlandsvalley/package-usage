-- | Pivoted package sets where the relationship is reversed

module Packages.Pivoted (pivot, pivotedPackagesJsonString, simpleReversedDependencies)

where

import Packages.Types
import Packages.Serialization (writePackageUseJSON)
import Data.Maybe (Maybe(..))
import Data.Map (empty, insert, lookup)
import Data.Set (Set, empty, insert, singleton) as S
import Data.Tuple (Tuple(..))
import Data.Array (foldr)

-- We use foldr in preference to foldl so we get usage sorted alphabetically for free

addUsage :: PackageName ->  DependencyName -> PackageUse -> PackageUse
addUsage packageName dependencyName packages = 
  case lookup dependencyName packages of 
    Nothing -> 
      insert dependencyName (S.singleton packageName) packages 
    Just usages ->
      insert dependencyName (S.insert packageName usages) packages

addDependenciesUsage :: Tuple PackageName Package -> PackageUse -> PackageUse
addDependenciesUsage (Tuple packageName package) packages = 
  foldr (addUsage packageName) packages package.dependencies

-- | reverse the dependencies
pivot :: Packages -> PackageUse
pivot packages =
  foldr addDependenciesUsage empty packages

pivotedPackagesJsonString :: Packages -> String
pivotedPackagesJsonString packages = 
  writePackageUseJSON (pivot packages)

simpleReversedDependencies :: Packages -> PackageName -> S.Set DependencyName
simpleReversedDependencies packages target =
  case lookup target (pivot packages) of 
    Nothing -> 
      S.empty
    Just deps -> 
      deps  

