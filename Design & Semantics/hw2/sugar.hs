import Data.List
<<<<<<< HEAD

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
=======
-- unsugared
data Term = Variable String | Application Term Term | Lambda String Term deriving Show

-- sugared version
data Term' = Variable' String | Application' Term' [Term'] | Lambda' [String] Term' deriving Show

desugar :: Term' -> Term

desugar (Variable' x) = Variable x

desugar(Application' t []) = desugar(t)

desugar (Lambda' [] x2) = desugar (x2)

desugar (Lambda' (x:xs) x2) = Lambda x (desugar(Lambda' xs x2))

desugar (Application' x1 x2) = do
    let las = last(x2)
    let fir = init(x2)
    let term = desugar(Application' x1 fir)
    let ter = desugar(las)

    Application term ter
>>>>>>> 8b7ca92589a6fcf5439b05029f7edec35cda6f49
