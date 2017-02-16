{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}


module Actions where


import           Control.Error

import           GithubReport.Actions.Triage

import           Types


action :: Actions -> Script ()

action Triage{..} = triageReport triageInput triageOutput
