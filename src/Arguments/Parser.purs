module Arguments.Parser

where

import Options.Applicative

import Arguments.Types (Args, Command(..))
import Effect (Effect)
import Effect.Console (log, logShow)
import Prelude ((<$>), (<*>), (<>), Unit, bind)

-- | the default URI for package sets packages.json
defaultURI :: String
defaultURI =
  "https://raw.githubusercontent.com/purescript/package-sets/master/packages.json"


dependencyArgs :: Parser Args
dependencyArgs = 
  buildDependencyArgs
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
      <*> strOption 
          ( long "uri"
         <> short 'u'
         <> metavar "URI"
         <> value defaultURI 
         <> showDefault 
         <> help "packages.json URI" )

buildDependencyArgs :: String -> Boolean -> Boolean -> String -> Args 
buildDependencyArgs packageName reverse transitive uri = 
  { uri, command }

  where 
    command = Dependencies { packageName, reverse, transitive }

pathArgs :: Parser Args
pathArgs = 
  buildPathArgs
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
      <*> strOption 
          ( long "uri"
         <> short 'u'
         <> metavar "URI"
         <> value defaultURI 
         <> showDefault 
         <> help "packages.json URI" )

buildPathArgs :: String -> String -> String -> Args 
buildPathArgs sourceName targetName uri = 
  { uri, command }

  where 
    command = Paths { sourceName, targetName }

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
