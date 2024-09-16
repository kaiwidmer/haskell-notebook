module StringUtils (replace) where

replace :: String -> String -> String -> String
replace _ _ "" = ""
replace "" _ src = src
replace search replaceStr src = join $ replaceArr search replaceStr $ cut search src

join :: [String] -> String
join [] = ""
join src = _join src "" where
    _join [] result = result
    _join (c:cs) result = _join cs (result ++ c)

replaceArr :: String -> String -> [String] -> [String]
replaceArr _ "" result = result
replaceArr _ _ [] = []
replaceArr search replaceStr src = _replaceArr src [] where
    _replaceArr :: [String] -> [String] -> [String]
    _replaceArr [] result = reverse result
    _replaceArr (c:cs) result | c == search = _replaceArr cs (replaceStr:result)
        | True = _replaceArr cs (c:result)

cut :: String -> String -> [String]
cut search src = _cut src [] where
    _cut ::  String -> [String] -> [String]
    _cut "" result = reverse result
    _cut (c:cs) [] = _cut cs [[c]]
    _cut (c:cs) (x:xs) | beginsWith (x ++ [c]) search = _cut cs ((x ++ [c]):xs)
        | x == search = _cut cs ([c]:(x:xs))
        | c == head search = _cut cs ([c]:(x:xs))
        | True = _cut cs ((x++[c]):xs)

beginsWith :: String -> String -> Bool
beginsWith "" _ = True
beginsWith _ "" = False
beginsWith (x:xs) (y:ys) = x == y && beginsWith xs ys