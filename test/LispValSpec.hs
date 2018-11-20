{-# LANGUAGE OverloadedStrings #-}


module LispValSpec (spec, main) where

import Test.Hspec (describe, it, shouldBe, Spec)
import qualified LispVal as LV


spec :: Spec
spec = do
    describe "Test Example Lisp Valus" $ do
        it "Bool" $ do
            show (LV.Bool True) `shouldBe` "#t"
            show (LV.Bool False) `shouldBe` "#f"
        it "Nil" $ do
            show LV.Nil `shouldBe` "Nil"
        it "String" $ do
            show (LV.String "hello") `shouldBe` "\"hello\""
        it "List" $ do
            show (LV.List [LV.Bool False, LV.String "world", LV.Nil]) `shouldBe` "(#f \"world\" Nil)"


main :: IO ()
main = do
    putStrLn $ show $ LV.Bool True
    putStrLn $ show LV.Nil
    putStrLn $ show $ LV.String "hello" 
    putStrLn $ show $ LV.List [LV.Bool True, LV.String "world", LV.Nil]

