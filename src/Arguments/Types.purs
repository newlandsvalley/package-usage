module Arguments.Types

where

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Prelude (class Show)
  
data Command = 
    Dependencies
      { packageName  :: String
      , reverse  :: Boolean
      , transitive :: Boolean 
      }  
  | Paths 
      { sourceName  :: String
      , targetName   :: String
      }

derive instance genericCommand:: Generic Command _
instance showCommand :: Show Command where show = genericShow      

type Args = 
  { uri :: String 
  , command :: Command
  }
