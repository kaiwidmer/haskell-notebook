module NotebookRepresentation (Content(Text, CodeLine), ContentText(H1, H2, H3, H4, Paragraph), mergeContent) where

data Content a = Text(ContentText a)
    | CodeLine (a)
    deriving Show

instance Functor Content where
    fmap f content = case content of
        CodeLine a -> CodeLine $ f a
        Text contentText -> Text $ f <$> contentText

data ContentText a = H1(a)
    | H2(a)
    | H3(a)
    | H4(a)
    | Paragraph(a)
    deriving Show

instance Functor ContentText where
    fmap f contentText = case contentText of
        H1 a -> H1 $ f a
        H2 a -> H2 $ f a
        H3 a -> H3 $ f a
        H4 a -> H4 $ f a
        Paragraph a -> Paragraph $ f a

mergeContent :: Content String -> Content String -> [Content String]
mergeContent (CodeLine c1) (CodeLine c2) = [CodeLine $ c1 ++ "\n" ++ c2]
mergeContent (CodeLine c1) (Text (Paragraph "")) = if last c1 == '\n' then [CodeLine c1, Text (Paragraph "")] else [CodeLine (c1 ++ "\n")]
mergeContent (Text contentText1) (Text contentText2) = fmap Text $ mergeContentText contentText1 contentText2
mergeContent c1 c2 = [c1, c2]

mergeContentText :: ContentText String -> ContentText String -> [ContentText String]
mergeContentText (Paragraph "") (Paragraph "") = [Paragraph $ "\n"] 
mergeContentText (Paragraph p1) (Paragraph "") = [Paragraph $ p1, Paragraph ""] 
mergeContentText (Paragraph p1) (Paragraph p2) = [Paragraph $ p1 ++ " " ++ p2]
mergeContentText ct1 ct2 = [ct1, ct2]