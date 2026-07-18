{-# LANGUAGE LambdaCase #-}

module MetaCons.Serialize
  ( CanonicalValue (..)
  , SerializeError (..)
  , SerializeErrorKind (..)
  , magicBytes
  , formatVersion
  , maxAtomBytes
  , maxIdentityBytes
  , maxSerializedNesting
  , encodeCanonicalValue
  , decodeCanonicalValue
  , encodeSExpr
  , decodeSExpr
  , encodeScopeAxis
  , decodeScopeAxis
  , encodeStructuralAxis
  , decodeStructuralAxis
  , encodeBindingAxis
  , decodeBindingAxis
  , encodeEvalAxis
  , decodeEvalAxis
  , encodeStageAxis
  , decodeStageAxis
  , encodeTimeAxis
  , decodeTimeAxis
  , encodeIntegrityAxis
  , decodeIntegrityAxis
  , encodeCarrierAxis
  , decodeCarrierAxis
  , encodeProjectionAxis
  , decodeProjectionAxis
  , encodeCapability
  , decodeCapability
  , encodeByteCoord
  , decodeByteCoord
  , encodeCar32
  , decodeCar32
  , encodeCdr32
  , decodeCdr32
  , encodeOriginId
  , decodeOriginId
  , encodeResolverProfileId
  , decodeResolverProfileId
  , bytesToHex
  ) where

import Data.Bits (shiftL, shiftR, (.&.))
import Data.ByteString (ByteString)
import qualified Data.ByteString as ByteString
import Data.Char (intToDigit)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (decodeUtf8', encodeUtf8)
import Data.Word (Word32, Word8)
import Emergent.Syntax (SExpr (..), atomText, mkAtom)
import MetaCons.Axis
import MetaCons.Bounded
import MetaCons.Serialize.Error

data CanonicalValue
  = CanonicalSExpr SExpr
  | CanonicalScope ScopeAxis
  | CanonicalStructural StructuralAxis
  | CanonicalBinding BindingAxis
  | CanonicalEval EvalAxis
  | CanonicalStage StageAxis
  | CanonicalTime TimeAxis
  | CanonicalIntegrity IntegrityAxis
  | CanonicalCarrier CarrierAxis
  | CanonicalProjection ProjectionAxis
  | CanonicalCapability Capability
  | CanonicalByteCoord ByteCoord
  | CanonicalCar32 Car32
  | CanonicalCdr32 Cdr32
  | CanonicalOriginId OriginId
  | CanonicalResolverProfileId ResolverProfileId
  deriving stock (Eq, Show)

magicBytes :: ByteString
magicBytes = ByteString.pack [0x45, 0x41, 0x4c, 0x53]

formatVersion :: Word8
formatVersion = 0x01

maxAtomBytes :: Int
maxAtomBytes = 256

maxIdentityBytes :: Int
maxIdentityBytes = 256

maxSerializedNesting :: Int
maxSerializedNesting = 1024

encodeCanonicalValue :: CanonicalValue -> Either SerializeError ByteString
encodeCanonicalValue value = do
  (tag, payload) <-
    case value of
      CanonicalSExpr expr -> do
        payload <- encodeSExprPayload 0 expr
        pure (tagCanonicalSExpr, payload)
      CanonicalScope axis -> pure (tagCanonicalScope, ByteString.singleton (encodeScopeAxis axis))
      CanonicalStructural axis -> pure (tagCanonicalStructural, ByteString.singleton (encodeStructuralAxis axis))
      CanonicalBinding axis -> pure (tagCanonicalBinding, ByteString.singleton (encodeBindingAxis axis))
      CanonicalEval axis -> pure (tagCanonicalEval, ByteString.singleton (encodeEvalAxis axis))
      CanonicalStage axis -> pure (tagCanonicalStage, ByteString.singleton (encodeStageAxis axis))
      CanonicalTime axis -> pure (tagCanonicalTime, ByteString.singleton (encodeTimeAxis axis))
      CanonicalIntegrity axis -> pure (tagCanonicalIntegrity, ByteString.singleton (encodeIntegrityAxis axis))
      CanonicalCarrier axis -> pure (tagCanonicalCarrier, ByteString.singleton (encodeCarrierAxis axis))
      CanonicalProjection axis -> pure (tagCanonicalProjection, ByteString.singleton (encodeProjectionAxis axis))
      CanonicalCapability capability -> pure (tagCanonicalCapability, ByteString.singleton (encodeCapability capability))
      CanonicalByteCoord coord -> pure (tagCanonicalByteCoord, encodeByteCoord coord)
      CanonicalCar32 coord -> pure (tagCanonicalCar32, encodeCar32 coord)
      CanonicalCdr32 coord -> pure (tagCanonicalCdr32, encodeCdr32 coord)
      CanonicalOriginId origin -> do
        payload <- encodeOriginPayload origin
        pure (tagCanonicalOriginId, payload)
      CanonicalResolverProfileId profile -> do
        payload <- encodeResolverProfilePayload profile
        pure (tagCanonicalResolverProfileId, payload)
  pure (magicBytes <> ByteString.pack [formatVersion, tag] <> payload)

decodeCanonicalValue :: ByteString -> Either SerializeError CanonicalValue
decodeCanonicalValue input = do
  cursor0 <- consumeMagic (Cursor 0 input)
  (version, cursor1) <- readByte cursor0
  if version == formatVersion
    then pure ()
    else throwAt (cursorOffset cursor0) (UnsupportedVersion (fromIntegral version))
  (tag, cursor2) <- readByte cursor1
  (value, cursor3) <-
    case tag of
      0x10 -> firstValue CanonicalSExpr (decodeSExprPayload 0 cursor2)
      0x20 -> firstValue CanonicalScope (readExactAxis decodeScopeAxis cursor2)
      0x21 -> firstValue CanonicalStructural (readExactAxis decodeStructuralAxis cursor2)
      0x22 -> firstValue CanonicalBinding (readExactAxis decodeBindingAxis cursor2)
      0x23 -> firstValue CanonicalEval (readExactAxis decodeEvalAxis cursor2)
      0x24 -> firstValue CanonicalStage (readExactAxis decodeStageAxis cursor2)
      0x25 -> firstValue CanonicalTime (readExactAxis decodeTimeAxis cursor2)
      0x26 -> firstValue CanonicalIntegrity (readExactAxis decodeIntegrityAxis cursor2)
      0x27 -> firstValue CanonicalCarrier (readExactAxis decodeCarrierAxis cursor2)
      0x28 -> firstValue CanonicalProjection (readExactAxis decodeProjectionAxis cursor2)
      0x29 -> firstValue CanonicalCapability (readExactAxis decodeCapability cursor2)
      0x30 -> firstValue CanonicalByteCoord (decodeByteCoordPayload cursor2)
      0x31 -> firstValue CanonicalCar32 (decodeCar32Payload cursor2)
      0x32 -> firstValue CanonicalCdr32 (decodeCdr32Payload cursor2)
      0x33 -> firstValue CanonicalOriginId (decodeOriginPayload cursor2)
      0x34 -> firstValue CanonicalResolverProfileId (decodeResolverProfilePayload cursor2)
      _ -> throwAt (cursorOffset cursor1) (UnknownTag (fromIntegral tag))
  requireEnd cursor3
  pure value

encodeSExpr :: SExpr -> Either SerializeError ByteString
encodeSExpr = encodeCanonicalValue . CanonicalSExpr

decodeSExpr :: ByteString -> Either SerializeError SExpr
decodeSExpr input =
  decodeCanonicalValue input >>= \case
    CanonicalSExpr expr -> Right expr
    _ -> Left (SerializeError 5 (NonCanonicalEncoding "expected S-expression envelope"))

encodeScopeAxis :: ScopeAxis -> Word8
encodeScopeAxis FS = 0x00
encodeScopeAxis GS = 0x01
encodeScopeAxis RS = 0x02
encodeScopeAxis US = 0x03

decodeScopeAxis :: Word8 -> Either SerializeError ScopeAxis
decodeScopeAxis = decodeTag [(0x00, FS), (0x01, GS), (0x02, RS), (0x03, US)]

encodeStructuralAxis :: StructuralAxis -> Word8
encodeStructuralAxis Car = 0x00
encodeStructuralAxis Cdr = 0x01
encodeStructuralAxis Cons = 0x02

decodeStructuralAxis :: Word8 -> Either SerializeError StructuralAxis
decodeStructuralAxis = decodeTag [(0x00, Car), (0x01, Cdr), (0x02, Cons)]

encodeBindingAxis :: BindingAxis -> Word8
encodeBindingAxis BCar = 0x00
encodeBindingAxis BCdr = 0x01
encodeBindingAxis APVal = 0x02
encodeBindingAxis APVal1 = 0x03
encodeBindingAxis Subr = 0x04
encodeBindingAxis FSubr = 0x05
encodeBindingAxis Expr = 0x06
encodeBindingAxis FExpr = 0x07

decodeBindingAxis :: Word8 -> Either SerializeError BindingAxis
decodeBindingAxis =
  decodeTag
    [ (0x00, BCar)
    , (0x01, BCdr)
    , (0x02, APVal)
    , (0x03, APVal1)
    , (0x04, Subr)
    , (0x05, FSubr)
    , (0x06, Expr)
    , (0x07, FExpr)
    ]

encodeEvalAxis :: EvalAxis -> Word8
encodeEvalAxis Eager = 0x00
encodeEvalAxis Lazy = 0x01
encodeEvalAxis Special = 0x02
encodeEvalAxis Macro = 0x03
encodeEvalAxis Reflective = 0x04
encodeEvalAxis Quoted = 0x05

decodeEvalAxis :: Word8 -> Either SerializeError EvalAxis
decodeEvalAxis =
  decodeTag
    [(0x00, Eager), (0x01, Lazy), (0x02, Special), (0x03, Macro), (0x04, Reflective), (0x05, Quoted)]

encodeStageAxis :: StageAxis -> Word8
encodeStageAxis Surface = 0x00
encodeStageAxis Parsed = 0x01
encodeStageAxis Expanded = 0x02
encodeStageAxis Typed = 0x03
encodeStageAxis Normalized = 0x04
encodeStageAxis Resolved = 0x05
encodeStageAxis Lowered = 0x06

decodeStageAxis :: Word8 -> Either SerializeError StageAxis
decodeStageAxis =
  decodeTag
    [ (0x00, Surface)
    , (0x01, Parsed)
    , (0x02, Expanded)
    , (0x03, Typed)
    , (0x04, Normalized)
    , (0x05, Resolved)
    , (0x06, Lowered)
    ]

encodeTimeAxis :: TimeAxis -> Word8
encodeTimeAxis LL = 0x00
encodeTimeAxis MM = 0x01
encodeTimeAxis NN = 0x02

decodeTimeAxis :: Word8 -> Either SerializeError TimeAxis
decodeTimeAxis = decodeTag [(0x00, LL), (0x01, MM), (0x02, NN)]

encodeIntegrityAxis :: IntegrityAxis -> Word8
encodeIntegrityAxis Logos = 0x00
encodeIntegrityAxis Nomos = 0x01
encodeIntegrityAxis Pathos = 0x02

decodeIntegrityAxis :: Word8 -> Either SerializeError IntegrityAxis
decodeIntegrityAxis = decodeTag [(0x00, Logos), (0x01, Nomos), (0x02, Pathos)]

encodeCarrierAxis :: CarrierAxis -> Word8
encodeCarrierAxis LowControl = 0x00
encodeCarrierAxis LowAffine = 0x01
encodeCarrierAxis HighControl = 0x02
encodeCarrierAxis HighProjective = 0x03

decodeCarrierAxis :: Word8 -> Either SerializeError CarrierAxis
decodeCarrierAxis = decodeTag [(0x00, LowControl), (0x01, LowAffine), (0x02, HighControl), (0x03, HighProjective)]

encodeProjectionAxis :: ProjectionAxis -> Word8
encodeProjectionAxis NoProjection = 0x00
encodeProjectionAxis CharacterProjection = 0x01
encodeProjectionAxis BitboardProjection = 0x02
encodeProjectionAxis CanvasProjection = 0x03
encodeProjectionAxis PortProjection = 0x04
encodeProjectionAxis AzimuthProjection = 0x05

decodeProjectionAxis :: Word8 -> Either SerializeError ProjectionAxis
decodeProjectionAxis =
  decodeTag
    [ (0x00, NoProjection)
    , (0x01, CharacterProjection)
    , (0x02, BitboardProjection)
    , (0x03, CanvasProjection)
    , (0x04, PortProjection)
    , (0x05, AzimuthProjection)
    ]

encodeCapability :: Capability -> Word8
encodeCapability PureCapability = 0x00
encodeCapability MemoryCapability = 0x01
encodeCapability StorageCapability = 0x02
encodeCapability NetworkCapability = 0x03
encodeCapability ClockCapability = 0x04
encodeCapability ForeignCapability = 0x05
encodeCapability ProjectionCapability = 0x06

decodeCapability :: Word8 -> Either SerializeError Capability
decodeCapability =
  decodeTag
    [ (0x00, PureCapability)
    , (0x01, MemoryCapability)
    , (0x02, StorageCapability)
    , (0x03, NetworkCapability)
    , (0x04, ClockCapability)
    , (0x05, ForeignCapability)
    , (0x06, ProjectionCapability)
    ]

encodeByteCoord :: ByteCoord -> ByteString
encodeByteCoord = ByteString.singleton . byteCoordToWord8

decodeByteCoord :: ByteString -> Either SerializeError ByteCoord
decodeByteCoord input = do
  (coord, cursor) <- decodeByteCoordPayload (Cursor 0 input)
  requireEnd cursor
  pure coord

encodeCar32 :: Car32 -> ByteString
encodeCar32 = encodeWord32BE . car32ToWord32

decodeCar32 :: ByteString -> Either SerializeError Car32
decodeCar32 input = do
  (coord, cursor) <- decodeCar32Payload (Cursor 0 input)
  requireEnd cursor
  pure coord

encodeCdr32 :: Cdr32 -> ByteString
encodeCdr32 = encodeWord32BE . cdr32ToWord32

decodeCdr32 :: ByteString -> Either SerializeError Cdr32
decodeCdr32 input = do
  (coord, cursor) <- decodeCdr32Payload (Cursor 0 input)
  requireEnd cursor
  pure coord

encodeOriginId :: OriginId -> Either SerializeError ByteString
encodeOriginId = encodeOriginPayload

decodeOriginId :: ByteString -> Either SerializeError OriginId
decodeOriginId input = do
  (origin, cursor) <- decodeOriginPayload (Cursor 0 input)
  requireEnd cursor
  pure origin

encodeResolverProfileId :: ResolverProfileId -> Either SerializeError ByteString
encodeResolverProfileId = encodeResolverProfilePayload

decodeResolverProfileId :: ByteString -> Either SerializeError ResolverProfileId
decodeResolverProfileId input = do
  (profile, cursor) <- decodeResolverProfilePayload (Cursor 0 input)
  requireEnd cursor
  pure profile

bytesToHex :: ByteString -> Text
bytesToHex bytes =
  Text.pack (concatMap byteHex (ByteString.unpack bytes))

encodeSExprPayload :: Int -> SExpr -> Either SerializeError ByteString
encodeSExprPayload depth expr
  | depth > maxSerializedNesting = throwAt 0 (NestingLimitExceeded maxSerializedNesting)
  | otherwise =
      case expr of
        Nil -> pure (ByteString.singleton tagSExprNil)
        AtomExpr atom ->
          encodeBoundedText maxAtomBytes (atomText atom)
            >>= \payload -> pure (ByteString.singleton tagSExprAtom <> payload)
        Pair carExpr cdrExpr -> do
          encodedCar <- encodeSExprPayload (depth + 1) carExpr
          encodedCdr <- encodeSExprPayload (depth + 1) cdrExpr
          pure (ByteString.singleton tagSExprPair <> encodedCar <> encodedCdr)

decodeSExprPayload :: Int -> Cursor -> Either SerializeError (SExpr, Cursor)
decodeSExprPayload depth cursor
  | depth > maxSerializedNesting =
      throwAt (cursorOffset cursor) (NestingLimitExceeded maxSerializedNesting)
  | otherwise = do
      (tag, cursor1) <- readByte cursor
      case tag of
        0x00 -> pure (Nil, cursor1)
        0x01 -> do
          (text, cursor2) <- decodeBoundedText maxAtomBytes cursor1
          atom <- mapLeftAt (cursorOffset cursor1) InvalidAtom (mkAtom text)
          pure (AtomExpr atom, cursor2)
        0x02 -> do
          (carExpr, cursor2) <- decodeSExprPayload (depth + 1) cursor1
          (cdrExpr, cursor3) <- decodeSExprPayload (depth + 1) cursor2
          pure (Pair carExpr cdrExpr, cursor3)
        _ -> throwAt (cursorOffset cursor) (UnknownTag (fromIntegral tag))

encodeOriginPayload :: OriginId -> Either SerializeError ByteString
encodeOriginPayload = encodeBoundedText maxIdentityBytes . originIdText

decodeOriginPayload :: Cursor -> Either SerializeError (OriginId, Cursor)
decodeOriginPayload cursor = do
  (text, cursor1) <- decodeBoundedText maxIdentityBytes cursor
  origin <- maybeAt (cursorOffset cursor) (InvalidLength (Text.length text)) (mkOriginId text)
  pure (origin, cursor1)

encodeResolverProfilePayload :: ResolverProfileId -> Either SerializeError ByteString
encodeResolverProfilePayload = encodeBoundedText maxIdentityBytes . resolverProfileIdText

decodeResolverProfilePayload :: Cursor -> Either SerializeError (ResolverProfileId, Cursor)
decodeResolverProfilePayload cursor = do
  (text, cursor1) <- decodeBoundedText maxIdentityBytes cursor
  profile <-
    maybeAt (cursorOffset cursor) (InvalidLength (Text.length text)) (mkResolverProfileId text)
  pure (profile, cursor1)

encodeBoundedText :: Int -> Text -> Either SerializeError ByteString
encodeBoundedText bound text =
  let bytes = encodeUtf8 text
      len = ByteString.length bytes
   in if len > bound
        then throwAt 0 (LengthExceedsBound len bound)
        else pure (encodeWord16BE len <> bytes)

decodeBoundedText :: Int -> Cursor -> Either SerializeError (Text, Cursor)
decodeBoundedText bound cursor = do
  (len, cursor1) <- readWord16BE cursor
  if len > bound
    then throwAt (cursorOffset cursor) (LengthExceedsBound len bound)
    else do
      (bytes, cursor2) <- readBytes len cursor1
      case decodeUtf8' bytes of
        Left _ -> throwAt (cursorOffset cursor1) InvalidUtf8
        Right text -> pure (text, cursor2)

decodeByteCoordPayload :: Cursor -> Either SerializeError (ByteCoord, Cursor)
decodeByteCoordPayload cursor = do
  (byte, cursor1) <- readByte cursor
  coord <- maybeAt (cursorOffset cursor) (InvalidLength 1) (mkByteCoord (fromIntegral byte))
  pure (coord, cursor1)

decodeCar32Payload :: Cursor -> Either SerializeError (Car32, Cursor)
decodeCar32Payload cursor = do
  (word32, cursor1) <- readWord32BE cursor
  pure (mkCar32 word32, cursor1)

decodeCdr32Payload :: Cursor -> Either SerializeError (Cdr32, Cursor)
decodeCdr32Payload cursor = do
  (word32, cursor1) <- readWord32BE cursor
  pure (mkCdr32 word32, cursor1)

readExactAxis
  :: (Word8 -> Either SerializeError axis) -> Cursor -> Either SerializeError (axis, Cursor)
readExactAxis decoder cursor = do
  (byte, cursor1) <- readByte cursor
  axis <- mapLeftOffset (cursorOffset cursor) (decoder byte)
  pure (axis, cursor1)

decodeTag :: [(Word8, value)] -> Word8 -> Either SerializeError value
decodeTag entries tag =
  case lookup tag entries of
    Just value -> Right value
    Nothing -> Left (SerializeError 0 (UnknownTag (fromIntegral tag)))

firstValue
  :: (a -> CanonicalValue)
  -> Either SerializeError (a, Cursor)
  -> Either SerializeError (CanonicalValue, Cursor)
firstValue wrap decoded = do
  (value, cursor) <- decoded
  pure (wrap value, cursor)

consumeMagic :: Cursor -> Either SerializeError Cursor
consumeMagic cursor =
  if ByteString.take (ByteString.length magicBytes) (cursorInput cursor) == magicBytes
    then Right (advance (ByteString.length magicBytes) cursor)
    else throwAt 0 InvalidMagic

requireEnd :: Cursor -> Either SerializeError ()
requireEnd cursor =
  if ByteString.null (cursorInput cursor)
    then Right ()
    else throwAt (cursorOffset cursor) (TrailingBytes (ByteString.length (cursorInput cursor)))

readByte :: Cursor -> Either SerializeError (Word8, Cursor)
readByte cursor =
  case ByteString.uncons (cursorInput cursor) of
    Nothing -> throwAt (cursorOffset cursor) UnexpectedEndOfInput
    Just (byte, rest) -> Right (byte, Cursor (cursorOffset cursor + 1) rest)

readBytes :: Int -> Cursor -> Either SerializeError (ByteString, Cursor)
readBytes count cursor
  | count < 0 = throwAt (cursorOffset cursor) (InvalidLength count)
  | ByteString.length (cursorInput cursor) < count =
      throwAt (cursorOffset cursor) UnexpectedEndOfInput
  | otherwise =
      let (payload, rest) = ByteString.splitAt count (cursorInput cursor)
       in Right (payload, Cursor (cursorOffset cursor + count) rest)

readWord16BE :: Cursor -> Either SerializeError (Int, Cursor)
readWord16BE cursor = do
  (hi, cursor1) <- readByte cursor
  (lo, cursor2) <- readByte cursor1
  pure ((fromIntegral hi `shiftL` 8) + fromIntegral lo, cursor2)

readWord32BE :: Cursor -> Either SerializeError (Word32, Cursor)
readWord32BE cursor = do
  (b0, cursor1) <- readByte cursor
  (b1, cursor2) <- readByte cursor1
  (b2, cursor3) <- readByte cursor2
  (b3, cursor4) <- readByte cursor3
  pure
    ( (fromIntegral b0 `shiftL` 24)
        + (fromIntegral b1 `shiftL` 16)
        + (fromIntegral b2 `shiftL` 8)
        + fromIntegral b3
    , cursor4
    )

encodeWord16BE :: Int -> ByteString
encodeWord16BE value =
  ByteString.pack [fromIntegral (value `shiftR` 8), fromIntegral value]

encodeWord32BE :: Word32 -> ByteString
encodeWord32BE value =
  ByteString.pack
    [ fromIntegral ((value `shiftR` 24) .&. 0xff)
    , fromIntegral ((value `shiftR` 16) .&. 0xff)
    , fromIntegral ((value `shiftR` 8) .&. 0xff)
    , fromIntegral (value .&. 0xff)
    ]

mapLeftAt :: Int -> (err -> SerializeErrorKind) -> Either err value -> Either SerializeError value
mapLeftAt _ _ (Right value) = Right value
mapLeftAt offset wrap (Left err) = Left (SerializeError offset (wrap err))

mapLeftOffset :: Int -> Either SerializeError value -> Either SerializeError value
mapLeftOffset _ (Right value) = Right value
mapLeftOffset offset (Left (SerializeError _ kind)) = Left (SerializeError offset kind)

maybeAt :: Int -> SerializeErrorKind -> Maybe value -> Either SerializeError value
maybeAt _ _ (Just value) = Right value
maybeAt offset kind Nothing = Left (SerializeError offset kind)

throwAt :: Int -> SerializeErrorKind -> Either SerializeError a
throwAt offset kind = Left (SerializeError offset kind)

advance :: Int -> Cursor -> Cursor
advance count cursor = Cursor (cursorOffset cursor + count) (ByteString.drop count (cursorInput cursor))

byteHex :: Word8 -> String
byteHex byte =
  [ intToDigit (fromIntegral ((byte `shiftR` 4) .&. 0x0f))
  , intToDigit (fromIntegral (byte .&. 0x0f))
  ]

tagCanonicalSExpr :: Word8
tagCanonicalSExpr = 0x10

tagCanonicalScope :: Word8
tagCanonicalScope = 0x20

tagCanonicalStructural :: Word8
tagCanonicalStructural = 0x21

tagCanonicalBinding :: Word8
tagCanonicalBinding = 0x22

tagCanonicalEval :: Word8
tagCanonicalEval = 0x23

tagCanonicalStage :: Word8
tagCanonicalStage = 0x24

tagCanonicalTime :: Word8
tagCanonicalTime = 0x25

tagCanonicalIntegrity :: Word8
tagCanonicalIntegrity = 0x26

tagCanonicalCarrier :: Word8
tagCanonicalCarrier = 0x27

tagCanonicalProjection :: Word8
tagCanonicalProjection = 0x28

tagCanonicalCapability :: Word8
tagCanonicalCapability = 0x29

tagCanonicalByteCoord :: Word8
tagCanonicalByteCoord = 0x30

tagCanonicalCar32 :: Word8
tagCanonicalCar32 = 0x31

tagCanonicalCdr32 :: Word8
tagCanonicalCdr32 = 0x32

tagCanonicalOriginId :: Word8
tagCanonicalOriginId = 0x33

tagCanonicalResolverProfileId :: Word8
tagCanonicalResolverProfileId = 0x34

tagSExprNil :: Word8
tagSExprNil = 0x00

tagSExprAtom :: Word8
tagSExprAtom = 0x01

tagSExprPair :: Word8
tagSExprPair = 0x02

data Cursor = Cursor
  { cursorOffset :: Int
  , cursorInput :: ByteString
  }
