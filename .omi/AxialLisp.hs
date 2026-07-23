-- =========================================================================
-- AxialLisp.hs - PURE FINITE AXIAL LISP EXTRACTION MAPPINGS
-- Pure representation from first principles, free of external packages.
-- =========================================================================
module AxialLisp where

import Data.Bits ((.&.), (.|.), shiftL, shiftR)
import Data.Word (Word8, Word16, Word32)

-- Pure 32-bit packed pair representation for un-nested (CAR . CDR) wires.
-- Layout: upper 16 bits = CDR, lower 16 bits = CAR.
newtype AxialPair = AxialPair { getPair :: Word32 }
    deriving (Eq, Show)

carMask :: Word32
carMask = 0x0000FFFF

cdrShift :: Int
cdrShift = 16

car :: AxialPair -> Word16
car (AxialPair p) = fromIntegral (p .&. carMask)

cdr :: AxialPair -> Word16
cdr (AxialPair p) = fromIntegral (p `shiftR` cdrShift)

cons :: Word16 -> Word16 -> AxialPair
cons xCar xCdr =
    let packedCar = fromIntegral xCar :: Word32
        packedCdr = fromIntegral xCdr :: Word32
    in AxialPair ((packedCdr `shiftL` cdrShift) .|. packedCar)

isRemoteCodePoint :: Word8 -> Bool
isRemoteCodePoint cp = (cp .&. 0x80) /= 0

data SubstrateTarget
    = TargetRules
    | TargetFacts
    | TargetClosures
    | TargetCombinators
    | TargetCons
    deriving (Eq, Show, Enum, Bounded)
