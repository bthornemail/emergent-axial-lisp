module TestHarness
  ( TestCase (..)
  , assertBool
  , assertEqual
  , assertLeft
  , assertRight
  , runTests
  ) where

import qualified Control.Exception as Exception
import System.Exit (exitFailure)

data TestCase = TestCase
  { testName :: String
  , testAction :: IO ()
  }

assertBool :: String -> Bool -> IO ()
assertBool _ True = pure ()
assertBool message False = fail message

assertEqual :: (Eq a, Show a) => String -> a -> a -> IO ()
assertEqual message expected actual =
  assertBool
    (message <> "\nexpected: " <> show expected <> "\nactual:   " <> show actual)
    (expected == actual)

assertLeft :: Show right => String -> Either left right -> IO ()
assertLeft _ (Left _) = pure ()
assertLeft message (Right value) =
  fail (message <> "\nexpected Left, got Right " <> show value)

assertRight :: Show left => String -> Either left right -> IO right
assertRight _ (Right value) = pure value
assertRight message (Left value) =
  fail (message <> "\nexpected Right, got Left " <> show value)

runTests :: [TestCase] -> IO ()
runTests tests = do
  failures <- traverse runOne tests
  let failed = length (filter not failures)
      total = length tests
  if failed == 0
    then putStrLn ("All " <> show total <> " tests passed.")
    else do
      putStrLn (show failed <> " of " <> show total <> " tests failed.")
      exitFailure

runOne :: TestCase -> IO Bool
runOne TestCase{testName, testAction} = do
  result <- eitherFromIO testAction
  case result of
    Right () -> do
      putStrLn ("PASS " <> testName)
      pure True
    Left message -> do
      putStrLn ("FAIL " <> testName)
      putStrLn message
      pure False

eitherFromIO :: IO () -> IO (Either String ())
eitherFromIO action =
  (Right <$> action) `catchAny` (pure . Left . show)

catchAny :: IO a -> (IOError -> IO a) -> IO a
catchAny = Exception.catch
