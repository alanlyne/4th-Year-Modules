import Data.List

data Term = Variable String 
            | Application Term Term 
            | Lambda String Term 
            deriving Show

data Term' = Variable' String 
            | Application' Term' [Term'] 
            | Lambda' [String] Term' 
            deriving Show

desugar :: Term' -> Term

desugar (Variable' c) = Variable c
desugar (Application' t []) = desugar(t)
desugar (Lambda' [] b) = desugar (b)
desugar (Lambda' (x:xs) b) = Lambda x (desugar(Lambda' xs b))

desugar (Application' a b) = do
    let l = last(b)
    let first = init(b)
    let ter = desugar(Application' a first)
    let term = desugar(l)

    Application ter term