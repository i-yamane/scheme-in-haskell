import 01_introduction.LispVal
import Text.Parsec
import Text.Parsec.Text

newtype Parser LispVal = Parser (Text -> [(LispVal, Text)])

main :: IO ()
main = do
    putStrLn $ show Nil
