module Lib
    ( evalCode
    ) where

import qualified Data.List
import System.Process
import System.Exit

evalCode :: String -> IO String
evalCode code = do
    writeFile "temp.hs" (appendMain code)
    result <- readProcessWithExitCode "runghc" ["temp.hs"] []
    return $ pretty result where
        pretty (exitCode, stdout, stderr) = case exitCode of
            ExitSuccess -> stdout
            ExitFailure _ -> stdout ++ "\n" ++ stderr

appendMain :: String -> String
appendMain code =  Data.List.unlines $ _appendMain (Data.List.lines code) [] [] where
    _appendMain :: [String] -> [String] -> [String] -> [String]
    _appendMain [] codeLines [] = _appendMain [] codeLines ["print \"ok\""]
    _appendMain [] codeLines mainLines = Data.List.reverse $ ("main = do {" ++ (Data.List.intercalate ";" (Data.List.reverse mainLines)) ++ "}"):codeLines
    _appendMain (line:remaining) codeLines mainLines = if ":" `Data.List.isPrefixOf` line then  _appendMain remaining codeLines (("print $ show (" ++ Data.List.tail line ++ ")"):mainLines) else _appendMain remaining (line:codeLines) mainLines
