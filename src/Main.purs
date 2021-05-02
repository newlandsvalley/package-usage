module Main where

import Prelude

import Affjax (defaultRequest, printError, request)
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Data.Either (Either(..))
import Data.Foldable (intercalate)
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, Fiber, launchAff)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Foreign (renderForeignError)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (writeTextFile)
import Packages.Normal (simpleDependencies)
import Packages.Pivoted (pivotedPackagesJsonString, simpleReversedDependencies)
import Packages.Transitivity (transitiveDependencies)
import Packages.Serialization (readPackages)
import Options.Applicative (execParser)
import Arguments.Types (Args(..))
import Arguments.Parser (opts)

outputFileName :: String 
outputFileName = "package-use.json" 

packageSetsURI :: String
packageSetsURI =
  "https://raw.githubusercontent.com/purescript/package-sets/master/packages.json"


main :: Effect Unit
main = do    
  args <- execParser opts
  _ <- processPackageSet args
  pure unit

-- | Fetch packages.json and process it according to the request args:
-- |
-- |   simple forward dependencies
-- |   transitive forward dependencies 
-- |   simple reversed dependencies
-- |   transitive reversed dependencies 
-- |
processPackageSet :: Args -> Effect (Fiber Unit)
processPackageSet (Args args) = launchAff $ do
  mBuffer <- simpleRequest packageSetsURI
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
          case args.reverse, args.transitive of 

            true, true -> 
              liftEffect $ log ("not implemented")
           
            true, false -> do   
              let 
                deps = simpleReversedDependencies packages args.packageName
              liftEffect $ logShow deps

            false, false -> do
              let 
                deps = simpleDependencies packages args.packageName
              liftEffect $ logShow deps

            false, true  -> do
              let 
                deps = transitiveDependencies packages args.packageName
              liftEffect $ logShow deps

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


