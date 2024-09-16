module Main (main) where

import System.IO
import System.Environment
import Parser
import StringUtils
import HtmlGenerator

main :: IO ()
main = do
    args <- getArgs
    fileContent <- readFileContent $ notebookPathArgument args
    writeHtmlBody (generateHtml $ parseNotebook fileContent) (templateFileArgument args) (outputFileArgument args)
    putStrLn "Html generated"

writeHtmlBody :: String -> String -> String -> IO ()
writeHtmlBody html templateFile outputFile = do
    fileContent <- readFileContent $ templateFile
    writeFile outputFile (replace "[BODY]" html fileContent)

readFileContent :: String -> IO String 
readFileContent path = (openFile path ReadMode) >>= hGetContents

notebookPathArgument :: [String] -> String
notebookPathArgument args = case getParam args 's' of 
    Just value -> value
    Nothing -> "testData/codebook.hs"

templateFileArgument :: [String] -> String
templateFileArgument args = case getParam args 't' of 
    Just value -> value
    Nothing -> "../webNotebook/template.html"

outputFileArgument :: [String] -> String
outputFileArgument args = case getParam args 'o' of 
    Just value -> value
    Nothing -> "../webNotebook/src/index.html"

getParam :: [String] -> Char -> Maybe String
getParam [] _ = Nothing
getParam [_] _ = Nothing
getParam (param:value:params) argument = if param == argumentPrefix argument then
    Just value
    else getParam params argument

argumentPrefix :: Char -> String
argumentPrefix argument = ['-', argument]