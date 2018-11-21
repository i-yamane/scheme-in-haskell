module SimpleParser (
    symbol
    , symbols
    , readExpr
    , spaces
) where

import qualified Text.ParserCombinators.Parsec as Prs
import System.Environment

symbols :: [Char]
symbols = "!#$%&|*+-/:<=>?@^_~"

symbol :: Prs.Parser Char
symbol = Prs.oneOf symbols

readExpr :: String -> String
readExpr input = case Prs.parse symbol "Syntax Error." input of
    Left err -> "No match: " ++ show err
    Right val -> "Found value: " ++ show val

spaces :: Prs.Parser ()
spaces = Prs.skipMany1 Prs.space

