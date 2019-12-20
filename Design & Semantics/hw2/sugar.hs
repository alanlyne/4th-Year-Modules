import Data.List
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