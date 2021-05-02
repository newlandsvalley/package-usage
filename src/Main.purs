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
import Effect.Console (log)
import Foreign (renderForeignError)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (writeTextFile)
import Packages.Pivot (pivotedPackagesJsonString)
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

-- fetch packages.json and process it according to tje reuest args:
-- pivot it in the output file (package-use.json)
-- so that we see a list of packages that use each package insofar 
-- as the authors have bothered to add their library to package sets.
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
           
            true, false -> do              
              let 
                json = pivotedPackagesJsonString packages
              _ <- writeTextFile UTF8 outputFileName json
              liftEffect $ log ("package usage written to : " <> outputFileName)
            _, _ ->
              liftEffect $ log ("not implemented")

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


