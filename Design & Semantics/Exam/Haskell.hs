-- Define scatterGather (SCATTER-GATHER which takes two
-- arguments, a list INDICES of indices and a list VALS of values,
-- and returns a list of the same length as INDICES but with each
-- value K replaced by the K-th element of VALS, or if that is out of
-- range, by #f.) 
-- in Haskell, except that it takes an
-- additional first argument which is the value to use when an index
-- it out of range. Be sure to give a type signature.

scatterGather :: b -> [Int] -> [b] -> [b]
scatterGather f indices values
        | null indices = []
        | (length values) > head indices = values !! head indices : scatterGather f (drop 1 indices) values
        | otherwise = f : scatterGather f (drop 1 indices) values

-- scatterGather '_' [0,1,4,1,1,7,2] "abcde"
-- => "abebb_c"
-- scatterGather 0 [0,1,4,1,1,7,2] [100,101,102]
-- => [100,101,0,101,101,0,102]

-----------------------------------------------------------------------------------------------------------------------


--Jan 2018
--Define a Haskell function tear, including its type, which takes a
--predicate and a list and returns a list of two lists, the first
--those elements of the input list which pass the predicate, the
--second those that don't, in order.

--tear :: (a -> Bool) -> [a] -> [[a]]
--tear func lst = [[ b | b <- lst, func b ], [c | c <- lst, not(func c)]]

tear :: (a -> Bool) -> [a] -> [[a]]
tear p x = (filter p x):(filter (not.p) x):[]

--  b | b, bool  make b if bool is true
-- [ b | b, bool ] b var to list if bool is true

-- tear (>5) [1,10,2,12,3,13]
-- => [[10,12,13],[1,2,3]]

-----------------------------------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------------------------------

--Jan 2017
--Define a Haskell function weaveHunks which takes an int and
--two lists and weaves them together in hunks of the given size.
--Be sure to declare its type signature.

weaveHunks :: Int -> [b] -> [b] -> [b]
weaveHunks num list1 list2
        |null list1 = list2
        |null list2 = list1
        |otherwise = take num list1 ++ take num list2 ++ weaveHunks num (drop num list1) (drop num list2)

-- weaveHunks 3 "abcdefghijklmno" "ABCDEFGHIJKLMNO"
-- => "abcABCdefDEFghiGHIjklJKLmnoMNO"
-- weaveHunks 2 [1..10] [11..20]
-- => [1,2,11,12,3,4,13,14,5,6,15,16,7,8,17,18,9,10,19,20]

-----------------------------------------------------------------------------------------------------------------------
