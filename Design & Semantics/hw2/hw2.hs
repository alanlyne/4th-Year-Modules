import Data.List
import System.IO
{-# LANGUAGE UnicodeSyntax #-}

-- :l hw2.hs
main = do
    -- Prints the string with a new line
    putStrLn "What's your name: "
    -- Gets user input and stores it in name
    -- <- Pulls the name entered from an IO action
    name <- getLine
    putStrLn ("Hello " ++ name)


pain = do 
    putStrLn "What is 2 + 2?"
   
    x <- readLn
    if x == 4
        then putStrLn "You're right!"
        else putStrLn "You're wrong!"


--printDash' = getChar >>= (\c -> putChar c >> putChar '-' >> putChar c >> putChar '\n')

    -- a >> b = a >>= (\_ -> b)

lemmacheck x = do
  if x == "/"
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
  putStrLn "What's your sum: "

  xs <- getLine
  printDash xs