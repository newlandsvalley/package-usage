module Packages.Transitivity (transitiveDependencies)

where 

import Control.Comonad
import Control.Comonad.Store (Store, peek, store)
import Control.Extend (extend)
import Data.List (foldMap)

import Data.Map (lookup)
import Data.Monoid (mempty, (<>))
import Data.Maybe (Maybe(..))
import Data.Set as S
import Packages.Types (Packages, PackageMap)
import Packages.Normal (buildPackageMap)

immediateConstituentsOf :: PackageMap -> String -> S.Set String 
immediateConstituentsOf packageMap target  = 
  case lookup target packageMap of 
    Just set -> set 
    Nothing -> S.empty

storedDependencies :: PackageMap -> String -> Store (S.Set String) (S.Set String)
storedDependencies packageMap seed = 
  store (foldMap (immediateConstituentsOf packageMap)) (S.singleton seed)

allPackageDeps :: PackageMap -> String -> Store (S.Set String) (S.Set String)
allPackageDeps packageMap seed
  = extend wfix (go <$> (storedDependencies packageMap seed))
    where
      go :: S.Set String -> Store (S.Set String) (S.Set String) -> (S.Set String)
      go deps _ | S.isEmpty deps = mempty
      go deps rec = deps <> peek deps rec

transitiveDependencies :: Packages -> String -> S.Set String
transitiveDependencies packages seed =
  let 
    packageMap = buildPackageMap packages
  in
    extract (allPackageDeps packageMap seed)

-- | Comonadic fixed point à la Menendez
wfix :: forall w a. Comonad w => w (w a -> a) -> a
wfix w = extract w (extend wfix w)