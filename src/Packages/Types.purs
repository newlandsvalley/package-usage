module Packages.Types

where

import Foreign.Object (Object)
import Data.Tuple (Tuple)
import Data.Map
import Data.Set as S
  

type Dependency = String
type PackageName = String

type Dependencies = Array Dependency

type Package = 
  { dependencies :: Dependencies
  , repo :: String 
  , version :: String 
  }

type PackagesObject = Object Package

type Packages = Array (Tuple PackageName Package)

type PackageUse = Map Dependency (Array PackageName)

type PackageMap = Map PackageName (S.Set Dependency)


