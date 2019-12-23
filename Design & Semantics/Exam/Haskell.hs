--Jan 2018
--Define a Haskell function tear, including its type, which takes a
--predicate and a list and returns a list of two lists, the first
--those elements of the input list which pass the predicate, the
--second those that don't, in order.

tear :: (a -> Bool) -> [a] -> [[a]]
tear func lst = [[ a | a <- lst, func a ], [a | a <- lst, not(func a)]]

-- tear (>5) [1,10,2,12,3,13]
-- => [[10,12,13],[1,2,3]]

--Aug 2018
--Define a Haskell function mapSkip which takes a function and a
--list and returns the result of applying the given function to
--every other element of the given list, starting with the first
--element. Be sure to include a type signature.

mapSkip :: (Int -> Int) -> [Int] -> [Int]
mapSkip func lst
        | null lst = []
        | (length lst) > 1 = func (head lst) : lst !! 1 : mapSkip func (drop 2 lst)
        | otherwise = func (head lst) : []

-- mapSkip (+1000) [1..6]
-- => [1001,2,1003,4,1005,6]