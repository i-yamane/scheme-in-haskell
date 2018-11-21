{-# LANGUAGE OverloadedStrings #-}
module ParserSpec (spec) where

import Test.Hspec (describe, it, shouldBe, Spec)
import LispVal
import Parser
import qualified Data.Text as T


spec :: Spec
spec = do
    describe "src/Parser.hs" $ do
        it "Bool True" $ readExpr "#t" `shouldBe` (Right $ Bool True)

