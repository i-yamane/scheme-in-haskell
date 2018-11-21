{-# LANGUAGE OverloadedStrings #-}

module Parser (
    readExpr
    , readExprFile
) where


import LispVal (LispVal(..))
import qualified Text.Parsec as Prs
import Text.Parsec ((<|>), sepBy)
import qualified Text.Parsec.Text as PrsT
import qualified Text.Parsec.Expr as Expr
import qualified Text.Parsec.Token as Tok
import qualified Text.Parsec.Language as Lang
import qualified Data.Text as T
import qualified Control.Applicative as CA
-- hiding ((<|>))
import Data.Functor.Identity (Identity)


lexer :: Tok.GenTokenParser T.Text () Identity
lexer = Tok.makeTokenParser style

style :: Tok.GenLanguageDef T.Text () Identity
style = Lang.emptyDef {
    Tok.commentStart = "{-"
    , Tok.commentEnd = "-}"
    , Tok.commentLine = "--"
    , Tok.opStart = Tok.opLetter style
    , Tok.opLetter = Prs.oneOf ":!#$%%&*+./<=>?@\\^|-~"
    , Tok.identStart = Prs.letter <|>  Prs.oneOf "-+/*=|&><"
    , Tok.identLetter = Prs.digit <|> Prs.letter <|> Prs.oneOf "?+=|&-/"
    , Tok.reservedOpNames = [ "'", "\""]
    }


-- symbols = "!$%&*/:<=>?^_~"
-- specials = "+-.@"

Tok.TokenParser {
    Tok.parens = m_parens
    , Tok.identifier = m_identifier
    } = Tok.makeTokenParser style


reservedOp :: T.Text -> PrsT.Parser ()
reservedOp op = Tok.reservedOp lexer $ T.unpack op


parseAtom :: PrsT.Parser LispVal
parseAtom = do
    p <- m_identifier
    return $ Atom $ T.pack p


parseText :: PrsT.Parser LispVal
parseText = do
    reservedOp "\""
    p <- Prs.many1 $ Prs.noneOf "\""
    reservedOp "\""
    return $ String . T.pack $  p


parseNumber :: PrsT.Parser LispVal
parseNumber = Number . read <$> Prs.many1 Prs.digit


parseNegNum :: PrsT.Parser LispVal
parseNegNum = do
    Prs.char '-'
    d <- Prs.many1 Prs.digit
    return $ Number . negate . read $ d


parseList :: PrsT.Parser LispVal
parseList = List . concat <$> Prs.many parseExpr
                                  `sepBy` (Prs.char ' ' <|> Prs.char '\n')


parseSExp = List . concat <$> m_parens (Prs.many parseExpr
                                         `sepBy` (Prs.char ' ' <|> Prs.char '\n'))


parseQuote :: PrsT.Parser LispVal
parseQuote = do
    reservedOp "\'"
    x <- parseExpr
    return $ List [Atom "quote", x]


parseReserved :: PrsT.Parser LispVal
parseReserved = do
    reservedOp "Nil" >> return Nil
    <|> (reservedOp "#t" >> return (Bool True))
    <|> (reservedOp "#f" >> return (Bool False))


parseExpr :: PrsT.Parser LispVal
parseExpr = parseReserved <|> parseNumber
    <|> Prs.try parseNegNum
    <|> parseAtom
    <|> parseText
    <|> parseQuote
    <|> parseSExp

contents :: PrsT.Parser a -> PrsT.Parser a
contents p = do
    Tok.whiteSpace lexer
    r <- p
    Prs.eof
    return r

readExpr :: T.Text -> Either Prs.ParseError LispVal
readExpr = Prs.parse (contents parseExpr) "<stdin>"

readExprFile :: T.Text -> Either Prs.ParseError LispVal
readExprFile = Prs.parse (contents parseList) "<file>"
