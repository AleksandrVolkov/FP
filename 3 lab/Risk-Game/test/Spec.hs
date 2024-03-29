module Main (main) where

import Test.Hspec
import Test.QuickCheck
import Control.Monad.Random
import Control.Monad
import Data.List
import System.IO.Unsafe

import Risk

main :: IO ()
main = hspec $ describe "Testing excercises" $ do
    describe "Excercise 2" $
      it "Army decrease" $
        property $ do
          let a = 10
              d = 10
          checkDecrease (a, d) (returnVal $ battle (Battlefield a d))   -- тест на уменьшение армии, что хотябы одна из них уменьшилась

    describe "Excercise 3" $
      it "Army destroyed" $ 
        property $ checkDestroyed $ returnVal $ invade (Battlefield 10 10) -- тест на то, что одна из армий будет уничтожена

    describe "Excercise 4" $
      it "1 probability with no defenders" $
        returnVal (successProb (Battlefield 10 0)) `shouldBe` (1.0 :: Double) -- если нет защитников, то вероятность победы атакующих 1.0

    describe "Excercise 4" $
      it "0 probability with no attackers" $
         returnVal (successProb (Battlefield 0 10)) `shouldBe` (0.0 :: Double)  -- если нет атакующих, то вероятность победы атакующих 0.0

    describe "Excercise 4" $
      it "from 0 to 1" $
        property $ prop_range (returnVal (successProb (Battlefield 10 10)))   -- тест на то, что вероятность победы находится в диапазоне от 0.0 до 1.0

returnVal = unsafePerformIO . evalRandIO  -- получение значений

prop_range :: Double -> Bool 
prop_range val = val > 0.0 && val < 1.0

checkDecrease :: (Army, Army) -> Battlefield -> Bool
checkDecrease (a, d) bf = attackers bf < a || defenders bf < d

checkDestroyed :: Battlefield -> Bool
checkDestroyed bf = attackers bf == 1 || defenders bf == 0