-- #Functors and Applicatives

-- ##Functor

predec :: Int -> Maybe Int
predec x
    | x < 1    = Nothing
    | otherwise = Just $ x - 1

divS :: Int -> Int -> Maybe Int
divS x y | y == 0    = Nothing
         | otherwise = Just $ x `div` y

f :: Int -> Int
f x = 2 * x

g :: Int -> Maybe Int
g x = f <$> predec x


-- ##Applicative

-- ###Simple examples

-- ####Exercise:
-- Define h x y = (x-1) * (y-1) with the help of <$> and <*>
h :: Int -> Int -> Maybe Int
h x y = error "fixme"

addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

-- ####Exercise:
-- Define d x y z = (x-1) + (y-1) + (z-1) with the help of <$> and <*>
d :: Int -> Int -> Int -> Maybe Int
d x y z = addThree <$> predec x <*> predec y <*> predec z