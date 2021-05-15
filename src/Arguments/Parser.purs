module Arguments.Parser

where

import Effect (Effect)
import Effect.Console (log, logShow)
import Prelude (($), (<$>), (<*>), (<>), Unit, bind, map)
import Options.Applicative
import Arguments.Types (Args(..))

dependencyArgs :: Parser Args
dependencyArgs = 
  map Dependencies $ ({ packageName:_, reverse:_, transitive:_})
      <$> strOption
          ( long "package"
         <> short 'p'
         <> metavar "PACKAGE-NAME"
         <> help "Target package name" )
      <*> switch
          ( long "reverse"
         <> short 'r'
         <> help "Whether to reverse the dependencies to track package use" )
      <*> switch
          ( long "transitive"
         <> short 't'
         <> help "Whether to include transitive dependencies")


pathArgs :: Parser Args
pathArgs = 
  map Paths $ ({ sourceName:_, targetName:_})
      <$> strOption
          ( long "from"
         <> short 'f'
         <> metavar "PACKAGE-NAME"
         <> help "from package name" )
      <*> strOption
          ( long "to"
         <> short 't'         
         <> metavar "PACKAGE-NAME"
         <> help "To package name" )     

commandLine :: Parser Args
commandLine = 
  hsubparser
       ( command "deps"
         (info dependencyArgs ( progDesc "Get package dependencies" ))
      <> command "paths"
         (info pathArgs( progDesc "Get all paths between two packages" ) )
       ) 

opts :: ParserInfo Args
opts = info (commandLine <**> helper)
  ( fullDesc
  <> progDesc "List dependencies for packages in purescript-package-sets"
  <> header "Dependencies may be forward or reversed, direct or transitive" )


getArgs :: Args -> Effect Unit
getArgs as = do
  _ <- log "Got args: " 
  logShow as
