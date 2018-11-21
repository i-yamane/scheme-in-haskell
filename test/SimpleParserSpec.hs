module SimpleParserSpec (spec) where

import Test.Hspec (describe, it, shouldBe, Spec)
import qualified SimpleParser as SP


spec :: Spec
spec = do
    describe "Testing SimpleParser." $ do
        -- let expr = '|'
        -- it ("Reading " ++ show expr) $ do
        --     (SP.readExpr [expr]) `shouldBe` ("Found value: " ++ show expr)

        foldl1 (>>)
            [it ("Reading " ++ show expr) $ do
                (SP.readExpr [expr]) `shouldBe` ("Found value: " ++ show expr)
            | expr <- SP.symbols]

