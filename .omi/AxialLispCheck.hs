-- =========================================================================
-- AxialLispCheck.hs - STANDALONE LOCAL AXIAL LISP LAW VERIFIER
-- =========================================================================
module Main where

import AxialLisp
import Data.Word (Word16)
import System.Exit (exitFailure, exitSuccess)

checkConsIdentity :: Bool
checkConsIdentity =
    let testCar = 0x1337 :: Word16
        testCdr = 0xDEAD :: Word16
        pair = cons testCar testCdr
    in car pair == testCar && cdr pair == testCdr

checkZeroNestingBounds :: Bool
checkZeroNestingBounds =
    let lowOnly = cons 0xFFFF 0x0000
        highOnly = cons 0x0000 0xFFFF
        fullPair = cons 0xFFFF 0xFFFF
    in getPair lowOnly == 0x0000FFFF
        && getPair highOnly == 0xFFFF0000
        && getPair fullPair == 0xFFFFFFFF

checkRemoteHinge :: Bool
checkRemoteHinge =
    not (isRemoteCodePoint 0x7F) && isRemoteCodePoint 0x80

checkSubstrateNames :: Bool
checkSubstrateNames =
    length [TargetRules .. TargetCons] == 5

main :: IO ()
main = do
    putStrLn "Executing Layer 1 Axial Lisp Wire Invariant Scan..."
    let assertions =
          [ (checkConsIdentity, "CAR/CDR Extraction and CONS Recomposition Identity")
          , (checkZeroNestingBounds, "Bounded 32-bit Un-Nested Pair Surface")
          , (checkRemoteHinge, "Bit-7 OMINO Local/Remote Balance Hinge")
          , (checkSubstrateNames, "Five Core Binary Substrate Targets Verification")
          ]
    mapM_
        ( \(passed, label) ->
            if passed
                then putStrLn $ "  [PASS] " ++ label
                else putStrLn $ "  [FAIL] " ++ label
        )
        assertions
    if all fst assertions
        then exitSuccess
        else exitFailure
