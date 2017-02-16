{-# LANGUAGE LambdaCase #-}


module Opts
    ( Actions(..)
    , opts
    , execParser
    , parseOpts
    ) where


-- import           Control.Monad       (mzero)
-- import qualified Data.List           as L
import           Data.Monoid
import qualified Data.Text           as T
import           Options.Applicative

-- import           GithubReport.Types

import           Types


outputOpt :: Parser FilePath
outputOpt = strOption (  short 'o' <> long "output" <> metavar "OUTPUT_FILE"
                      <> help "The file to write back to.")

-- inputOpt :: Parser FilePath
-- inputOpt = strOption (  short 'i' <> long "input" <> metavar "INPUT_FILE"
--                      <> help "The input file to process.")

-- inputsOpt :: Parser [FilePath]
-- inputsOpt = many (strArgument (  metavar "INPUT_FILES ..."
                              -- <> help "Input data files."))

triageOpts :: Parser Actions
triageOpts =   Triage
           <$> outputOpt
           <*> many (argument (T.pack <$> str)
                        (  metavar "OWNER/NAME"
                        <> help "A repository to include in the report"
                        ))

opts' :: Parser Actions
opts' = subparser
      (  command "triage" (info (helper <*> triageOpts)
                          (progDesc "Report on open issues and pull requests."))
      )

opts :: ParserInfo Actions
opts = info (helper <*> opts')
            (  fullDesc
            <> progDesc "Download data reports from GH."
            <> header "github-report - Download data reports from GH.")

parseOpts :: IO Actions
parseOpts = execParser opts
