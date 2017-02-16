{-# LANGUAGE DeriveDataTypeable         #-}
-- {-# LANGUAGE DeriveFunctor              #-}
{-# LANGUAGE DeriveGeneric              #-}
-- {-# LANGUAGE DeriveTraversable          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
-- {-# LANGUAGE OverloadedLists            #-}
{-# LANGUAGE OverloadedStrings          #-}
-- {-# LANGUAGE RankNTypes                 #-}
-- {-# LANGUAGE RecordWildCards            #-}
-- {-# LANGUAGE TemplateHaskell            #-}


module GithubReport.Types where


-- import           Control.Lens
-- import           Data.Data
import qualified Data.Text              as T
import           GHC.Generics           hiding (to)
import Data.Csv
import Data.Data
import Control.Monad


data TriageType = Issue | PR
                deriving (Show, Eq, Generic, Data, Typeable)

instance FromField TriageType where
    parseField "issue" = return Issue
    parseField "pr"    = return PR
    parseField _       = mzero

instance ToField TriageType where
    toField Issue = "issue"
    toField PR    = "pr"

data TriageReport
    = TR
    { priority :: T.Text
    , project  :: T.Text
    , title    :: T.Text
    , date     :: String
    , issue    :: TriageType
    , url      :: T.Text
    } deriving (Show, Generic, Data, Typeable)

instance FromNamedRecord TriageReport
instance ToNamedRecord TriageReport
instance DefaultOrdered TriageReport
