import LispVal
import qualified Text.Parsec as Prs
import qualified Text.Parsec.Text as T

newtype Parser LispVal = Parser (T.Text -> [(LispVal, T.Text)])

main :: IO ()
main = do
    putStrLn $ show Nil
