{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T
import Data.Typeable (typeOf)

main :: IO ()
main = do
    putStrLn $ "Type of \"hello\"::Text is " ++ str_type
    putStrLn $ "Type of \"hello\"::String is " ++ str_type
        where
            text_type = show $ typeOf ("string literal"::T.Text)
            str_type = show $ typeOf ("string literal"::T.Text)

