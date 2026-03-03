module Main where

import qualified AStar (AStarResult (..), Graph, Node (..), astar, printGraph, readGraph)
import System.Directory (createDirectoryIfMissing)
import qualified System.Environment
import qualified System.Exit
import System.FilePath ((</>))

-- args
data Args = Args
  { inputPath :: FilePath,
    outputPath :: FilePath,
    weighted :: Bool,
    startID :: Int,
    goalID :: Int
  }

-- main
main :: IO ()
main = do
  args <- System.Environment.getArgs >>= parse
  graph <- AStar.readGraph (inputPath args) (weighted args)
  AStar.printGraph graph
  putStrLn ""
  putStrLn $
    "Searching from node "
      ++ show (startID args)
      ++ " to node "
      ++ show (goalID args)
  let (result, treeEdges) = AStar.astar graph (startID args) (goalID args)
  createDirectoryIfMissing True (outputPath args)
  writeSearchTree (outputPath args </> "search_tree.csv") treeEdges
  case result of
    Nothing -> do
      putStrLn "No path found."
      putStrLn $ "Search tree written to " ++ outputPath args
    Just r -> do
      let cost = pathCost r
      putStrLn $ "Path found (cost: " ++ show cost ++ "):"
      putStrLn $ "  " ++ unwords (map (show . AStar.nodeID) (AStar.pathNodes r))
      writePathCSV (outputPath args </> "output_path.csv") (AStar.pathNodes r)
      putStrLn $ "Results written to " ++ outputPath args

-- sum edge weights along the path
pathCost :: AStar.AStarResult -> Float
pathCost result =
  let ns = reverse (AStar.pathNodes result) -- start -> goal order
      pairs = zip ns (tail ns)
   in sum [dist a b | (a, b) <- pairs]
  where
    dist a b =
      let dx = AStar.xCoord a - AStar.xCoord b
          dy = AStar.yCoord a - AStar.yCoord b
       in sqrt (dx * dx + dy * dy)

-- CSV output
nodeRow :: AStar.Node -> String
nodeRow n =
  show (AStar.nodeID n)
    ++ ", "
    ++ show (AStar.xCoord n)
    ++ ", "
    ++ show (AStar.yCoord n)

-- output_path.csv: goal at top, start at bottom
writePathCSV :: FilePath -> [AStar.Node] -> IO ()
writePathCSV fp ns = do
  let header = "nodeID, x_location, y_location"
      rows = map nodeRow ns
  writeFile fp (unlines (header : rows))

-- search_tree.csv: one row per relaxed edge
writeSearchTree :: FilePath -> [(AStar.Node, AStar.Node)] -> IO ()
writeSearchTree fp edges = do
  let header = "nodeID, x_location, y_location, parentID, parent_x_location, parent_y_location"
      rows = map edgeRow edges
  writeFile fp (unlines (header : rows))
  where
    edgeRow (child, parent) =
      nodeRow child ++ ", " ++ nodeRow parent

-- CLI parsing
-- flags may appear in any order
-- ./enae644-hw02 -i <inputPath> -o <outputPath> -s <start> -g <goal> [-w]
parse :: [String] -> IO Args
parse argv = case argv of
  ["-h"] -> usage >> exit >> return dummy
  ["-v"] -> version >> exit >> return dummy
  _ -> parseFlags argv (Args "" "" False 0 0)
  where
    dummy = Args "" "" False 0 0

-- flag parsing
parseFlags :: [String] -> Args -> IO Args
parseFlags [] args = validate args
parseFlags ("-i" : path : rest) args = parseFlags rest args {inputPath = path}
parseFlags ("-o" : path : rest) args = parseFlags rest args {outputPath = path}
parseFlags ("-s" : n : rest) args = parseFlags rest args {startID = read n}
parseFlags ("-g" : n : rest) args = parseFlags rest args {goalID = read n}
parseFlags ("-w" : rest) args = parseFlags rest args {weighted = True}
parseFlags (flag : _) _ = do
  putStrLn $ "Unknown flag: " ++ flag
  usage
  die
  return (Args "" "" False 0 0)

-- flag validation
validate :: Args -> IO Args
validate args
  | null (inputPath args) = putStrLn "Missing -i <inputPath>" >> die >> return args
  | null (outputPath args) = putStrLn "Missing -o <outputPath>" >> die >> return args
  | startID args == 0 && goalID args == 0 =
      putStrLn "Missing -s and -g" >> die >> return args
  | otherwise = return args

-- flag outputs
usage :: IO ()
usage = putStrLn "Usage: enae644-hw02 -i <inputPath> -o <outputPath> -s <startID> -g <goalID> [-w]"

version :: IO ()
version = putStrLn "Haskell enae644-hw02 0.1"

exit :: IO ()
exit = System.Exit.exitWith System.Exit.ExitSuccess

die :: IO ()
die = System.Exit.exitWith (System.Exit.ExitFailure 1)
