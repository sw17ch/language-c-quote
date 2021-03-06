-- |
-- Module      :  Language.C.Properties
-- Copyright   :  (c) Harvard University 2006-2008
-- License     :  BSD-style
-- Maintainer  :  mainland@eecs.harvard.edu

module Language.C.Properties where

import qualified Data.ByteString.Char8 as B
import Data.Loc
import Data.Symbol
import Text.PrettyPrint.Mainland

import Language.C.Syntax as C
import qualified Language.C.Parser as P

prop_ParsePrintUnitId :: B.ByteString -> Bool
prop_ParsePrintUnitId s =
    case comp s of
      Left _ ->  False
      Right x -> x
  where
    comp :: B.ByteString -> Either String Bool
    comp s = do
        defs   <- parse s
        defs'  <- parse ((B.pack . pretty 80 . ppr) defs)
        return $ defs' == defs

    parse :: B.ByteString -> Either String [C.Definition]
    parse s =
        case P.parse [Gcc] [] P.parseUnit s pos of
          Left err   -> fail $ show err
          Right defs -> return defs
      where
        pos = startPos "<internal>"
