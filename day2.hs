toValue :: Char -> Int
toValue 'A' = 0
toValue 'B' = 1
toValue 'C' = 2

resultToValue :: Char -> Int
resultToValue 'X' = 2
resultToValue 'Y' = 0
resultToValue 'Z' = 1

whatToPlayToGetAResult :: Char -> Char -> Char
whatToPlayToGetAResult r a = 
    let x = toValue a
        y = resultToValue r
    in case (x+y) `mod` 3 of
        0 -> 'A'
        1 -> 'B'
        2 -> 'C'

scoreForPlaying :: Char -> Int
scoreForPlaying a = toValue a + 1

scoreForMatchResult :: Char -> Char -> Int
scoreForMatchResult a b = 
    let x = toValue a
        y = toValue b
    in case (y-x) `mod` 3 of
        0 -> 3
        1 -> 6
        2 -> 0

getTotalScore :: [String] -> Int
getTotalScore [] = 0
getTotalScore (x:xs) =
    let a = x!!0
        b = x!!2
        c = whatToPlayToGetAResult b a
    in scoreForMatchResult a c + scoreForPlaying c + getTotalScore xs

main = do
    content <- readFile "input/day2.in"
    putStrLn $ show $ getTotalScore $ lines content
    