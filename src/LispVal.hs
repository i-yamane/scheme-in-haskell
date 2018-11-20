{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module LispVal (
    LispVal(..)
    , Eval(..)
    , IFunc(..)
    , EnvCtx
    , LispException(..)
    , showVal
) where

import qualified Data.Text as T
import Data.Typeable (Typeable)

import Control.Monad.Except
import Control.Monad.Reader

import qualified Data.Map as Map

type EnvCtx = Map.Map T.Text LispVal

newtype Eval a = Eval { unEval :: ReaderT EnvCtx IO a }
    deriving (Monad
        , Functor
        , Applicative
        , MonadReader EnvCtx
        , MonadIO)

data LispVal
    = Atom T.Text
    | List [LispVal]
    | Number Integer
    | String T.Text
    | Fun IFunc
    | Lambda IFunc EnvCtx
    | Nil
    | Bool Bool deriving (Typeable)

instance Show LispVal where
    show = T.unpack . showVal

data IFunc = IFunc {fn :: [LispVal] -> Eval LispVal}
    deriving (Typeable)

instance Eq IFunc where
    (==) _ _ = False

showVal :: LispVal -> T.Text
showVal val =
    case val of
        (Atom atom)     -> atom
        (String str)    -> T.concat [ "\"" ,str,"\""]
        (Number num)    -> T.pack $ show num
        (Bool True)     -> "#t"
        (Bool False)    -> "#f"
        Nil             -> "Nil"
        (List contents) -> T.concat ["(", T.unwords $  showVal <$>  contents, ")"]
        (Fun _ )        -> "(internal function)"
        (Lambda _ _)    -> "(lambda function)"

main :: IO ()
main = do
    putStrLn $ show $ Bool True
    putStrLn $ show Nil
    putStrLn $ show $ String "hello" 
    putStrLn $ show $ List [Bool True, String "world", Nil]

