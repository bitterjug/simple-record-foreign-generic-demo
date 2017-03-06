module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log, CONSOLE)
import Control.Monad.Except (runExcept)
import Data.Either (Either)
import Data.Foreign.Class (class AsForeign, class IsForeign, readJSON, write)
import Data.Foreign.Generic (defaultOptions, readGeneric, toForeignGeneric)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Global.Unsafe (unsafeStringify)

newtype MyRecord = MyRecord {a :: Int}
derive instance genericMyRecord :: Generic MyRecord _
instance showMyRecord :: Show MyRecord where
  show = genericShow
instance isForeignMyRecord :: IsForeign MyRecord where
  read = readGeneric $ defaultOptions {unwrapSingleConstructors = true}
instance asForeignMyRecord :: AsForeign MyRecord where
  write = toForeignGeneric $ defaultOptions {unwrapSingleConstructors = true}

toJSONString = write >>> unsafeStringify
fromJSONString = readJSON >>> runExcept

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  log "Hello world"
  log $ toJSONString (MyRecord {a: 1})
  log $ show eMyRecord
  where
    eMyRecord :: Either _ MyRecord
    eMyRecord = fromJSONString """{"a": 1}"""
