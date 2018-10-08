module Main where

import Prelude hiding (zipWith)
import Data.Array.Accelerate
import Data.Array.Accelerate.LLVM.PTX as GPU

main :: IO ()
main = do
  let xs = fromList (Z:.10) [0..]   :: Vector Float
      ys = fromList (Z:.10) [1,3..] :: Vector Float
  let result = GPU.run $ dotp (use xs) (use ys)
  print result

dotp :: Acc (Vector Float)
     -> Acc (Vector Float)
     -> Acc (Scalar Float)
dotp xs ys = fold (+) 0 $ zipWith (*) xs ys
