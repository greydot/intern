{-# LANGUAGE TypeFamilies, FlexibleInstances #-}
module Data.Interned.Internal.Text
  ( InternedText(..)
  ) where

import Data.String
import Data.Interned
import Data.Text
import Data.Hashable

data InternedText = InternedText
  { internedTextId :: {-# UNPACK #-} !Id
  , uninternedText :: {-# UNPACK #-} !Text
  }

instance IsString InternedText where
  fromString = intern . pack

instance Eq InternedText where
  (==) = eqId

instance Ord InternedText where
  compare = compareId

instance Show InternedText where
  showsPrec d (InternedText _ b) = showsPrec d b

instance Interned InternedText where
  type Uninterned InternedText = Text
  newtype Description InternedText = DT Text deriving (Eq)
  describe = DT
  identify = InternedText
  identity = internedTextId
  cache = itCache

instance Uninternable InternedText where
  unintern (InternedText _ b) = b

instance Hashable (Description InternedText) where
  hashWithSalt s (DT h) = hashWithSalt s h

itCache :: Cache InternedText
itCache = mkCache
{-# NOINLINE itCache #-}
