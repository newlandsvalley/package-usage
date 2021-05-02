module Arguments.Types

where

import Prelude (class Show)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
  
data Args = Args
  { packageName  :: String
  , reverse  :: Boolean
  , transitive :: Boolean }  

derive instance genericArgs :: Generic Args _
instance showArgs :: Show Args where show = genericShow