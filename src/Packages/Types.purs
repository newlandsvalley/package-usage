module Packages.Types

where

import Foreign.Object (Object)
import Data.Tuple (Tuple)
import Data.Map
import Data.Set as S
  

type DependencyName = String
type PackageName = String

type Dependencies = Array DependencyName

type Package = 
  { dependencies :: Dependencies
  , repo :: String 
  , version :: String 
  }

type PackagesObject = Object Package

type Packages = Array (Tuple PackageName Package)

type PackageUse = Map DependencyName (S.Set PackageName)

type PackageMap = Map PackageName (S.Set DependencyName)


