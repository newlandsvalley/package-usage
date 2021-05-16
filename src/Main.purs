module Main where

import Prelude

import Affjax (defaultRequest, printError, request)
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Arguments.Parser (opts)
import Arguments.Types (Args, Command(..))
import Data.Either (Either(..))
import Data.Foldable (intercalate)
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, Fiber, launchAff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Foreign (renderForeignError)
import Options.Applicative (customExecParser, prefs, showHelpOnEmpty)
import Packages.Normal (simpleDependencies)
import Packages.Paths (allPaths)
import Packages.Pivoted (simpleReversedDependencies)
import Packages.Serialization (readPackages, writeDependenciesJSON, writePathsJSON)
import Packages.Transitivity (transitiveDependencies)

main :: Effect Unit
main = do    
  let 
    preferences = prefs showHelpOnEmpty
  args <- customExecParser preferences opts
  _ <- processPackageSet args
  pure unit

-- | Fetch packages.json and process it according to the request args:
-- |
-- |   simple forward dependencies
-- |   transitive forward dependencies 
-- |   simple reversed dependencies
-- |   transitive reversed dependencies 
-- |
-- | or 
-- |
-- |   all paths between two packages
-- |
-- | the packages.json uri which we query is also extracted from the args 
processPackageSet :: Args -> Effect (Fiber Unit)
processPackageSet allArgs = launchAff $ do
  mBuffer <- simpleRequest allArgs.uri
  case mBuffer of
    Just buffer -> 
      case readPackages buffer of
        Left errs -> 
          let
            errText :: String
            errText = intercalate "," $ map renderForeignError errs
          in 
            liftEffect $ log $ errText

        Right packages ->
          case allArgs.command of 
            
            Dependencies args -> 

              case args.reverse, args.transitive of 

                true, true -> do
                  let 
                    deps = writeDependenciesJSON $ transitiveDependencies packages args.packageName true
                  liftEffect $ log deps
           
                true, false -> do   
                  let 
                    deps = writeDependenciesJSON $ simpleReversedDependencies packages args.packageName
                  liftEffect $ log deps

                false, false -> do
                  let 
                    deps = writeDependenciesJSON $ simpleDependencies packages args.packageName
                  liftEffect $ log deps

                false, true  -> do
                  let 
                    deps = writeDependenciesJSON $ transitiveDependencies packages args.packageName false
                  liftEffect $ log deps

            Paths {sourceName, targetName} -> do
              let 
                paths = writePathsJSON $ allPaths sourceName targetName packages
              liftEffect $ log paths

            {- all pivoted packages  -- we don't have a command line arg for this yet   
              let 
                json = pivotedPackagesJsonString packages
              _ <- writeTextFile UTF8 outputFileName json
              liftEffect $ log ("package usage written to : " <> outputFileName)           
            
            -}

    Nothing -> 
      pure unit

-- request packages.json from purescript package-sets on github
simpleRequest :: String -> Aff (Maybe String)
simpleRequest url = do

  eRes <- request $ defaultRequest
    { url = url, method = Left GET, responseFormat = ResponseFormat.string }

  case eRes of  
    Left err -> do
      _ <- liftEffect $ log (printError err)
      _ <- liftEffect $ log (" failed to load package.json from : " <> url)
      pure Nothing

    Right response -> 
      case response.status of 
        StatusCode 200 -> 
          pure (Just response.body)
        _ -> do
          _ <- liftEffect $ log (response.statusText <> " " <> url)
          pure Nothing


{-}
outputFileName :: String 
outputFileName = "package-use.json" 
-}


