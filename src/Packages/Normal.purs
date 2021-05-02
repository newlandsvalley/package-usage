-- | Normal, unpivoted packages

module Packages.Normal (simpleDependencies)

where

import Packages.Types

import Data.Map (fromFoldable, lookup)
import Data.Maybe (Maybe(..))
import Data.Set (Set, empty, fromFoldable) as S
import Data.Tuple (Tuple)
import Prelude ((>>>), map)


buildPackageMap :: Packages -> PackageMap 
buildPackageMap packages = 
  let
    directDeps :: Array (Tuple PackageName (S.Set PackageName))
    directDeps = map (map (_.dependencies >>> S.fromFoldable)) packages
  in
    fromFoldable directDeps  

simpleDependencies :: Packages -> PackageName -> S.Set Dependency
simpleDependencies packages target =
  case lookup target (buildPackageMap packages) of 
    Nothing -> 
      S.empty
    Just deps -> 
      deps