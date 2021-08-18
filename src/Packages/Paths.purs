module Packages.Paths (allPaths) where

import Prelude ((==))
import Packages.Types
import Packages.Normal (buildPackageMap)
import Data.List (List(..), (:), concatMap, reverse, singleton)
import Data.Map (lookup)
import Data.Maybe (Maybe(..))
import Data.Set as S

allPaths :: PackageName -> PackageName -> Packages -> Paths
allPaths source target packages =
  findAllPaths source target (buildPackageMap packages) Nil

findAllPaths :: PackageName -> PackageName -> PackageMap -> Path -> Paths
findAllPaths source target packageMap preface =
  concatMap (f preface) dependents

  where
  f :: Path -> PackageName -> Paths
  f currentPath name =
    if (name == target) then
      singleton (reverse (name : currentPath))
    else
      findAllPaths name target packageMap (name : currentPath)
  dependents = nextPathStep packageMap source

nextPathStep :: PackageMap -> PackageName -> List PackageName
nextPathStep packageMap target =
  case lookup target packageMap of
    Just set -> S.toUnfoldable set
    Nothing -> Nil

