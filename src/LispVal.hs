{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}


module LispVal (
    LispVal(..)
    , Eval(..)
    , IFunc(..)
    , EnvCtx
    , showVal
) where


import qualified Data.Text as T
import Data.Typeable (Typeable)
import qualified Control.Monad.Except as ME
import qualified Control.Monad.Reader as MR
import qualified Data.Map as Map


type EnvCtx = Map.Map T.Text LispVal


newtype Eval a = Eval { unEval :: MR.ReaderT EnvCtx IO a }
    deriving (Monad
        , Functor
        , Applicative
        , MR.MonadReader EnvCtx
        , MR.MonadIO)


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

