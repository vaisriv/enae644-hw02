module Main where

import qualified Data.Map.Strict as Map
import qualified Graphs
  ( Graph (..),
    Node (..),
    emptyGraph,
    printGraph,
  )
import qualified RRT
  ( Goal (..),
    Motion (..),
    Obstacle (..),
    Problem (..),
    Workspace (..),
    rrt,
  )
import qualified System.Directory (createDirectoryIfMissing, doesFileExist)
import qualified System.Environment
import qualified System.Exit
import qualified System.FilePath (FilePath, (</>))

-------------------------------------------------------------------------------
-- Args
-------------------------------------------------------------------------------

data Args = Args
  { inputPath :: System.FilePath.FilePath,
    outputPath :: System.FilePath.FilePath,
    problemNum :: String
  }

defaultArgs :: Args
defaultArgs =
  Args
    { inputPath = "./data",
      outputPath = "./outputs",
      problemNum = "01"
    }

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

main :: IO ()
main = do
  args <- System.Environment.getArgs >>= parse
  let probFile = inputPath args System.FilePath.</> ("p" ++ problemNum args ++ ".json")
      obsFile = inputPath args System.FilePath.</> "obstacles.txt"
      outDir = outputPath args System.FilePath.</> problemNum args
  -- verify inputs exist
  probExists <- System.Directory.doesFileExist probFile
  obsExists <- System.Directory.doesFileExist obsFile
  if not probExists
    then putStrLn ("Error: problem file not found: " ++ probFile) >> die
    else return ()
  if not obsExists
    then putStrLn ("Error: obstacles file not found: " ++ obsFile) >> die
    else return ()
  -- ensure output directory exists
  System.Directory.createDirectoryIfMissing True outDir
  -- TODO:
  -- (step 4): parse inputs
  -- (step 5): run RRT
  -- (step 6): write outputs
  putStrLn $ "rrtSearch: problem " ++ problemNum args
  putStrLn $ "  input:  " ++ inputPath args
  putStrLn $ "  output: " ++ outDir

-------------------------------------------------------------------------------
-- CLI parsing
-------------------------------------------------------------------------------

-- Usage: ./rrtSearch [INPUTDIR] [OUTPUTDIR] [PROBLEMNUM]
parse :: [String] -> IO Args
parse argv = case argv of
  ["-h"] -> usage >> exit >> return defaultArgs
  ["--help"] -> usage >> exit >> return defaultArgs
  ["-v"] -> version >> exit >> return defaultArgs
  ["--version"] -> version >> exit >> return defaultArgs
  _ -> parsePositional argv defaultArgs

-- | parse up to three positional arguments,
--   fills in defaults for any omitted
parsePositional :: [String] -> Args -> IO Args
parsePositional [] args = return args
parsePositional [i] args = return args {inputPath = i}
parsePositional [i, o] args = return args {inputPath = i, outputPath = o}
parsePositional (i : o : p : _) args =
  let args' = args {inputPath = i, outputPath = o, problemNum = p}
   in validate args'
parsePositional _ args = return args

-- | validate that problem number "looks like" a two-digit numeric string
validate :: Args -> IO Args
validate args =
  if all (`elem` ("0123456789" :: String)) (problemNum args)
    && length (problemNum args) == 2
    then return args
    else do
      putStrLn $ "Error: PROBLEMNUM must be a 2-digit number (e.g. 01, 05). Got: " ++ problemNum args
      die
      return defaultArgs

-------------------------------------------------------------------------------
-- Info flags
-------------------------------------------------------------------------------

usage :: IO ()
usage = do
  putStrLn "Usage: rrtSearch [INPUTDIR] [OUTPUTDIR] [PROBLEMNUM]"
  putStrLn ""
  putStrLn "Arguments:"
  putStrLn "  INPUTDIR"
  putStrLn "          Directory with obstacles file (`obstacles.txt`) and problem file (`p<##>.json`)"
  putStrLn "          Default: `./data/`"
  putStrLn ""
  putStrLn "  OUTDIR"
  putStrLn "          Directory to save solution files (`<##>/path.csv`, `<##>/search_tree.csv`)"
  putStrLn "          Solution files will be placed in a subdirectory corresponding to the problem number"
  putStrLn "          Default: `./outputs/`"
  putStrLn ""
  putStrLn "  PROBLEMNUM"
  putStrLn "          Number of problem for which to calculate RRT path"
  putStrLn "          This should correspond to a valid problem file (`p<##>.json`) in the provided [INPUTDIR]"
  putStrLn "          Problem numbers and associated files should be numerically padded to 2 digits"
  putStrLn "          Default: `01`"
  putStrLn ""
  putStrLn "Options:"
  putStrLn "  -h, --help"
  putStrLn "          Print this help menu"
  putStrLn ""
  putStrLn "  -v, --version"
  putStrLn "          Print version"

version :: IO ()
version = putStrLn "rrtSearch 0.1 (GHC 9.10)"

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

exit :: IO ()
exit = System.Exit.exitWith System.Exit.ExitSuccess

die :: IO ()
die = System.Exit.exitWith (System.Exit.ExitFailure 1)
