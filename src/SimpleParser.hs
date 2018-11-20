module SimpleParser (
    symbol
    , readExpr
    , spaces
) where

import qualified Text.ParserCombinators.Parsec as Prs
import System.Environment

symbol :: Prs.Parser Char
symbol = Prs.oneOf "!#$%&|*+-/:<=>?@^_~"

readExpr :: String -> String
readExpr input = case Prs.parse symbol "Syntax Error." input of
    Left err -> "No match: " ++ show err
    Right val -> "Found value"

spaces :: Prs.Parser ()
spaces = Prs.skipMany1 Prs.space

