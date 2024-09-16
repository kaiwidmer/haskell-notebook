module Parser (parseNotebook) where

import qualified Data.List
import NotebookRepresentation

parseNotebook :: String -> [Content String]
parseNotebook input = flatContent $ fmap parseLine $ Data.List.lines input

flatContent :: [Content String] -> [Content String]
flatContent c = _flatContent c [] where
    _flatContent :: [Content String] -> [Content String] -> [Content String]
    _flatContent [] content = Data.List.reverse content
    _flatContent (content:cs) [] = _flatContent cs [content]
    _flatContent (content1:cs) (content2:processed) = _flatContent cs ((Data.List.reverse $ mergeContent content2 content1) ++ processed)

parseLine :: String -> Content String
parseLine line = _parseLine line "" where
    _parseLine :: String -> String -> Content String
    _parseLine [] _ = Text $ Paragraph ""
    _parseLine (' ':xs) prefix = _parseLine xs $ ' ':prefix
    _parseLine l prefix = if Data.List.isPrefixOf "--" l then Text $ parseContentText $ drop 2 l else CodeLine $ prefix ++ l

parseContentText :: String -> ContentText String
parseContentText [] = Paragraph ""
parseContentText (' ':xs) = parseContentText xs
parseContentText l | (Data.List.isPrefixOf "####" l) = H4 $ drop 4 l
    | (Data.List.isPrefixOf "###") l = H3 $ drop 3 l
    | (Data.List.isPrefixOf "##") l = H2 $ drop 2 l
    | (Data.List.isPrefixOf "#") l = H1 $ drop 1 l
    | True = Paragraph l