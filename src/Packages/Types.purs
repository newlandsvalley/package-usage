module Packages.Types

where

import Foreign.Object (Object)
import Data.Tuple (Tuple)
import Data.Map
  

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

type PackageUse = Map PackageName (Array PackageName)


