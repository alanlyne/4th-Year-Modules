import Data.List
import System.IO
{-# LANGUAGE UnicodeSyntax #-}

data Term = Variable String | Application Term Term | Lambda String Term
  deriving Show
data Term' = Variable' String | Application' Term' [Term'] | Lambda' [String] Term'
  deriving Show
Term :: String -> String
let replace = concatMap (\c -> if c=='O' then "X" else "XX")


--printDash' = getChar >>= (\c -> putChar c >> putChar '-' >> putChar c >> putChar '\n')

    -- a >> b = a >>= (\_ -> b)

lemmacheck x = do
  if x == "/" && head xs == 
    then putStr "Lambda"
    else do
      if x == "."
        then putStr "("
        else do
          if x == " "
            then putStr x
            else do
              putChar '"'
              putStr x
              putChar '"'

    
printDash xs = do
    -- xs <- getLine
    let (ys,zs) = splitAt 1 xs
    --c <- getChar             -- getChar >>= (\c ->
    if length xs == 1
      then lemmacheck xs
      else do
        let (ys,zs) = splitAt 1 xs 
        lemmacheck ys 
        --putChar ' ' 
        printDash zs

      

    --putChar '-'


    --putStrLn zs
        
getlemma = do
  xs <- getLine
  printDash xs