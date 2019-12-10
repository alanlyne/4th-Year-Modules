import Data.List
import System.IO
data Term = Variable String | Application Term Term | Lambda String Term
  deriving Show
data Term' = Variable' String | Application' Term' [Term'] | Lambda' [String] Term'
  deriving Show
Term :: String -> String
let replace = concatMap (\c -> if c=='O' then "X" else "XX")