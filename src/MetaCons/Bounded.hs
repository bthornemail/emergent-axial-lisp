module MetaCons.Bounded
  ( ByteCoord
  , Car32
  , Cdr32
  , OriginId
  , ResolverProfileId
  , mkByteCoord
  , byteCoordToWord8
  , byteCoordToInteger
  , mkCar32
  , car32ToWord32
  , mkCdr32
  , cdr32ToWord32
  , mkOriginId
  , originIdText
  , mkResolverProfileId
  , resolverProfileIdText
  ) where

import Data.Text (Text)
import qualified Data.Text as Text
import Data.Word (Word32, Word8)

newtype ByteCoord = ByteCoord Word8
  deriving stock (Eq, Ord, Show)

newtype Car32 = Car32 Word32
  deriving stock (Eq, Ord, Show)

newtype Cdr32 = Cdr32 Word32
  deriving stock (Eq, Ord, Show)

newtype OriginId = OriginId Text
  deriving stock (Eq, Ord, Show)

newtype ResolverProfileId = ResolverProfileId Text
  deriving stock (Eq, Ord, Show)

mkByteCoord :: Integer -> Maybe ByteCoord
mkByteCoord n
  | n < 0 = Nothing
  | n > 255 = Nothing
  | otherwise = Just (ByteCoord (fromInteger n))

byteCoordToWord8 :: ByteCoord -> Word8
byteCoordToWord8 (ByteCoord value) = value

byteCoordToInteger :: ByteCoord -> Integer
byteCoordToInteger = toInteger . byteCoordToWord8

mkCar32 :: Word32 -> Car32
mkCar32 = Car32

car32ToWord32 :: Car32 -> Word32
car32ToWord32 (Car32 value) = value

mkCdr32 :: Word32 -> Cdr32
mkCdr32 = Cdr32

cdr32ToWord32 :: Cdr32 -> Word32
cdr32ToWord32 (Cdr32 value) = value

mkOriginId :: Text -> Maybe OriginId
mkOriginId text
  | Text.null text = Nothing
  | otherwise = Just (OriginId text)

originIdText :: OriginId -> Text
originIdText (OriginId text) = text

mkResolverProfileId :: Text -> Maybe ResolverProfileId
mkResolverProfileId text
  | Text.null text = Nothing
  | otherwise = Just (ResolverProfileId text)

resolverProfileIdText :: ResolverProfileId -> Text
resolverProfileIdText (ResolverProfileId text) = text
