module Arguments.Parser

where

import Effect (Effect)
import Effect.Console (log, logShow)
import Prelude (($), (<$>), (<*>), (<>), Unit, bind, map)
import Options.Applicative
import Arguments.Types (Args(..))

args :: Parser Args
args = 
  map Args $ ({ packageName:_, reverse:_, transitive:_})
      <$> strOption
          ( long "package"
         <> short 'p'
         <> metavar "PACKAGE NAME"
         <> help "Target package name" )
      <*> switch
          ( long "reverse"
         <> short 'r'
         <> help "Whether to reverse the dependencies to track package use" )
      <*> switch
          ( long "transitive"
         <> short 't'
         <> help "Whether to include transitive dependencies")


opts :: ParserInfo Args
opts = info (args <**> helper)
  ( fullDesc
  <> progDesc "List dependencies for packages in purescript-package-sets"
  <> header "Dependencies may be forward or reversed, direct or transitive" )


getArgs :: Args -> Effect Unit
getArgs as = do
  _ <- log "Got args: " 
  logShow as
