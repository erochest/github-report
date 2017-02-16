{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}


module GithubReport.Actions.Triage where


import           Control.Error
import qualified Data.Text as T
import GitHub.Data.Name
import GitHub.Data.Definitions
import GitHub.Data.Repos
import Data.Bifunctor
import Control.Monad.Catch
import qualified Data.ByteString.Lazy as BS
import Data.Csv hiding (Name)
import GitHub.Endpoints.Issues
import GitHub.Endpoints.PullRequests
import Data.Monoid
import Data.Foldable
import Control.Monad
import Data.Proxy
import Data.Time

import           GithubReport.Types hiding (Issue)
import qualified GithubReport.Types as GHT


triageReport :: [T.Text] -> FilePath -> Script ()
triageReport inputs output = do
    triage <- forM inputs $ \input -> do
        let (owner, repo) = parseRepo input
            repo'         = untagName repo
        issues <- request $ issuesForRepo   owner repo mempty
        pulls  <- request $ pullRequestsFor owner repo
        return $ fmap (issueReport repo') issues <> fmap (pullReport repo') pulls

    scriptIO $ BS.writeFile output
             $ encodeDefaultOrderedByName
             $ toList
             $ mconcat triage

request :: IO (Either Error a) -> Script a
request = ExceptT . fmap (first displayException)

parseRepo :: T.Text -> (Name Owner, Name Repo)
parseRepo repoSpec =
    let (owner, repo) = T.break (== '/') repoSpec
    in (mkName (Proxy :: Proxy Owner) owner, mkName (Proxy :: Proxy Repo) repo)

issueReport :: T.Text -> Issue -> TriageReport
issueReport r Issue{..} = TR "" r issueTitle time GHT.Issue url
    where
        url  = getUrl issueUrl
        time = formatTime defaultTimeLocale
                          (iso8601DateFormat (Just "%H:%M:%S"))
                          issueCreatedAt

pullReport :: T.Text -> SimplePullRequest -> TriageReport
pullReport r SimplePullRequest{..} =
    TR "" r simplePullRequestTitle time GHT.PR url
    where
        url  = getUrl simplePullRequestUrl
        time = formatTime defaultTimeLocale
                          (iso8601DateFormat (Just "%H:%M:%S"))
                          simplePullRequestCreatedAt
