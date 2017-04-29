module Test.StrongCheck.GenericValue
  ( GenericValue
  , genericValue
  , toSignature
  , toSpine
  ) where

import Control.Bind               (bind)
import Control.MonadZero          (class MonadZero, guard)
import Data.Functor               ((<$))
import Data.Generic               (GenericSignature, GenericSpine, isValidSpine)
import Test.StrongCheck.Arbitrary (class Arbitrary)
import Test.StrongCheck.Gen       (sized)
import Test.StrongCheck.Generic   (genGenericSignature, genGenericSpine)

-- | Contains a representation of a value in generic form.
-- | Consists of `GenericSpine` and corresponding `GenericSignature`.
newtype GenericValue =
  GenericValue
    { signature :: GenericSignature
    , spine     :: GenericSpine
    }

-- | Get the signature of generic value.
toSignature :: GenericValue -> GenericSignature
toSignature (GenericValue a) = a.signature

-- | Get the spine of generic value.
toSpine :: GenericValue -> GenericSpine
toSpine (GenericValue a) = a.spine

instance arbitraryGenericValue :: Arbitrary GenericValue where
  arbitrary = do
    signature <- genGenericSignature
    spine     <- genGenericSpine signature
    genericValue signature spine

-- | Constructs generic value. Would return `mzero` if given
-- | `GenericSpine` doesn't conform to given `GenericSignature`.
genericValue
  :: ∀ m. MonadZero m
  => GenericSignature -> GenericSpine
  -> m GenericValue
genericValue signature spine =
  GenericValue { signature, spine }
    <$ guard (isValidSpine signature spine)