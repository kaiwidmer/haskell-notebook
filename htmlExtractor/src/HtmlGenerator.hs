module HtmlGenerator (generateHtml) where

import qualified Data.List
import StringUtils
import NotebookRepresentation

generateHtml :: [Content String] -> String
generateHtml [] = ""
generateHtml content = foldl (\acc line -> acc ++ line ++ "\n") "" $ generateHtmlLines $ escapeContent content 

generateHtmlLines :: [Content String] -> [String]
generateHtmlLines c = _generateHtmlLines c [] where
    _generateHtmlLines :: [Content String] -> [String] -> [String]
    _generateHtmlLines [] ls = Data.List.reverse ls
    _generateHtmlLines (content:cs) ls = _generateHtmlLines cs $ generateHtmlLine content : ls

generateHtmlLine :: Content String -> String
generateHtmlLine c = case c of 
    CodeLine codeLine -> "<div class='code-block'><textarea class='code-editor'>" ++ codeLine ++ "</textarea></div>"
    Text text -> case text of 
        H1 h1 -> "<h1>" ++ h1 ++ "</h1>"
        H2 h2 -> "<h2>" ++ h2 ++ "</h2>"
        H3 h3 -> "<h3>" ++ h3 ++ "</h3>"
        H4 h4 -> "<h4>" ++ h4 ++ "</h4>"
        Paragraph p -> "<p>" ++ p ++ "</p>"

escapeContent :: [Content String] -> [Content String]
escapeContent content = (\c -> escapeHtmlCharacters <$> c) <$> content


escapeHtmlCharacters :: String -> String
escapeHtmlCharacters = replace "<" "&lt;" . replace "&gt;" ">" . replace "\"" "&quot;" . replace "'" "&#39;" . replace "&" "&amp;"