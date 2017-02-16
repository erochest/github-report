module Types where


import Data.Text
-- import           GithubReport.Types


data Actions
        = Triage { triageOutput :: !FilePath
                 , triageInput  :: ![Text]
                 }
        deriving (Show, Eq)
