{-|
Module      : 1JC3-Assign2.Assign_2.hs
Copyright   :  (c) William M. Farmer 2024
License     :  GPL (see the LICENSE file)
Maintainer  :  none
Stability   :  experimental
Portability :  portable

Description:
  Assignment 2 - McMaster CS 1JC3 2024
-}
module Assign_2 where

-----------------------------------------------------------------------------------------------------------
-- INSTRUCTIONS              README!!!
-----------------------------------------------------------------------------------------------------------
-- 1) DO NOT DELETE/ALTER ANY CODE ABOVE THESE INSTRUCTIONS
-- 2) DO NOT REMOVE / ALTER TYPE DECLERATIONS (I.E THE LINE WITH THE :: ABOUT THE FUNCTION DECLERATION)
--    IF YOU ARE UNABLE TO COMPLETE A FUNCTION, LEAVE IT'S ORIGINAL IMPLEMENTATION (I.E. THROW AN ERROR)
-- 3) MAKE SURE THE PROJECT COMPILES (I.E. RUN STACK BUILD AND MAKE SURE THERE ARE NO ERRORS) BEFORE
--    SUBMITTING, FAILURE TO DO SO WILL RESULT IN A MARK OF 0
-- 4) REPLACE macid = "TODO" WITH YOUR ACTUAL MACID (EX. IF YOUR MACID IS jim THEN macid = "jim")
-----------------------------------------------------------------------------------------------------------

-- Name: TODO Yusuf Alam
-- Date: TODO October 31
macid :: String
macid = "alamy1"

type GaussianInt = (Integer,Integer)

{- -----------------------------------------------------------------
 - gaussReal
 - -----------------------------------------------------------------
 - Description:
 -   Takes the real part of a Gaussian integer
 -   A gaussian integer is represented in the tuple for (a, b)
 -   "a" is the real number and "b" is the imaginary number
 -   Therefore first component of the tuple is returned in this function
 -}
gaussReal :: GaussianInt -> Integer
gaussReal x = fst x

{- -----------------------------------------------------------------
 - gaussImag
 - -----------------------------------------------------------------
 - Description:
 -   Takes the imaginary part of a Guassian Integer
 -   using the same representation in gaussReal
 -   Therefore second component of the tuple (the imaginary number) 
 -   is returned in this function
 -}
gaussImag :: GaussianInt -> Integer
gaussImag x = snd x

{- -----------------------------------------------------------------
 - gaussConj
 - -----------------------------------------------------------------
 - Description:
 -   Computes the conjugate of a Gaussian Integer
 -   for a gaussian integer (a, b), the conjugate would be (a, -b)
 -   So the "a" remains the same, and the sign is flipped for b
 -}
gaussConj :: GaussianInt -> GaussianInt
gaussConj x = (fst x, -snd x)

{- -----------------------------------------------------------------
 - gaussAdd
 - -----------------------------------------------------------------
 - Description:
 -   Adds two Gaussian Integers
 -   (a, b) and (c, d) represent gaussian integer 1 and 2 respectively
 -   Using the representations their sum is (a + c, b + d)
 -}
gaussAdd :: GaussianInt -> GaussianInt -> GaussianInt
gaussAdd x y = (fst x + fst y, snd x + snd y)


{- -----------------------------------------------------------------
 - gaussMul
 - -----------------------------------------------------------------
 - Description:
 -   Given two Gaussian Integers with the same represenations in GaussAdd
 -   their product would be defined as (a*c - b*d, a*d + b*c)
 -}
gaussMul :: GaussianInt -> GaussianInt -> GaussianInt
gaussMul x y = (fst x * fst y - snd x * snd y, fst x * snd y + snd x * fst y)


{- -----------------------------------------------------------------
 - gaussNorm
 - -----------------------------------------------------------------
 - Description:
 -   Calculates the norm of a gaussian integer
 -   the norm is a non-negative integer, and is used to measure the
 -   relative size of the gaussian integer to other gaussian integers
 -   using the (a,b) representation the norm is a^2 + b^2
 -}
gaussNorm :: GaussianInt -> Integer
gaussNorm x = fst x * fst x + snd x * snd x

{- -----------------------------------------------------------------
 - gaussAddList
 - -----------------------------------------------------------------
 - Description:
 -   Adds a list of gaussian integers using recursion
 -   iterates through list, and adds each gauss int using gaussAdd 
 -   if the input list is empty, (0,0) is returned representing 0 
 -}
gaussAddList :: [GaussianInt] -> GaussianInt
gaussAddList [] = (0,0) 
gaussAddList (x:xs) = gaussAdd x (gaussAddList xs)

{- -----------------------------------------------------------------
 - gaussMulList
 - -----------------------------------------------------------------
 - Description:
 -   Multiplies a list of gaussian integers using recursion
 -   iterates through list, and multiplies each gauss int using gaussMul 
 -   if the input list is empty,, (1,0) os returned representing 1
 -}
gaussMulList :: [GaussianInt] -> GaussianInt
gaussMulList [] = (1,0)
gaussMulList (x:xs) = gaussMul x (gaussMulList xs)

{- ------------------------------------------------------------------------
 - gaussCircle
 - ------------------------------------------------------------------------
 - Description:
 -   Goes through a list of Gaussian Integers
 -   Only returns gaussian int where the norm is less than a given threshold
 -   As stated previoulsy the norm is calculated as a^2 + b^2
 -}
gaussCircle :: [GaussianInt] -> Integer -> [GaussianInt]
gaussCircle [] _ = []
gaussCircle (x : xs) n
  | gaussNorm x < n = x : gaussCircle xs n
  | otherwise = gaussCircle xs n

{-
Test Plan
------------------------------------------------------------------------
Function: gaussConj
Test Case Number: 1
Input: gaussConj (3, 4)
Expected Output: (3, -4)
Actual Output: (3, -4)

Test Case Number: 2
Input: gaussConj (-5, 2)
Expected Output: (-5, -2)
Actual Output: (-5, -2)

Test Case Number: 3
Input: gaussConj (0, -3)
Expected Output: (0, 3)
Actual Output: (0, 3)

------------------------------------------------------------------------

Function: gaussAdd
Test Case Number: 1
Input: gaussAdd (3, 4) (1, 2)
Expected Output: (4, 6)
Actual Output: (4,6)

Test Case Number: 2
Input: gaussAdd (-3, 5) (3, -5)
Expected Output: (0, 0)
Actual Output: (0,0)

Test Case Number: 3
Input: gaussAdd (7, -3) (2, 3)
Expected Output: (9, 0)
Actual Output: (9,0))

------------------------------------------------------------------------

Function: gaussMul
Test Case Number: 1
Input: gaussNorm (2, 3) (4, -1)
Expected Output: (11, 10)
Actual Output: (11,10)

Test Case Number: 2
Input: gaussNorm (0, 1) (0, 1)
Expected Output: (-1, 0)
Actual Output: (-1, 0)

Test Case Number: 3
Input: gaussMul (1, 1) (1, 1)
Expected Output: (0, 2)
Actual Output: (0,2)

------------------------------------------------------------------------

Function: gaussNorm
Test Case Number: 1
Input: gaussNorm (3, 4)
Expected Output: 25
Actual Output: 25

Test Case Number: 2
Input: gaussNorm (-5, 12)
Expected Output: 169
Actual Output: 169

Test Case Number: 3
Input: gaussNorm (0, 0)
Expected Output: 0
Actual Output: 0

------------------------------------------------------------------------

Function: gaussAddList
Test Case Number: 1
Input: gaussAddList [(1, 1), (2, 2), (3, 3)]
Expected Output: (6, 6)
Actual Output: (6,6)

Test Case Number: 2
Input: gaussAddList [(0, 0), (0, 0)]
Expected Output: (0, 0)
Actual Output: (0, 0)

Test Case Number: 3
Input: gaussAddList []
Expected Output: (0, 0)
Actual Output: (0,0)

------------------------------------------------------------------------

Function: gaussMulList
Test Case Number: 1
Input: gaussMulList [(1, 1), (2, 0), (0, 1)]
Expected Output: (-2, 2)
Actual Output: (-2, 2)

Test Case Number: 2
Input: gaussMulList [(1, 0), (3, 4)]
Expected Output: (3, 4)
Actual Output: (3, 4)

Test Case Number: 3
Input: gaussMulList []
Expected Output: (1, 0)
Actual Output: (1, 0)

------------------------------------------------------------------------

Function: gaussCircle
Test Case Number: 1
Input: gaussCircle [(1, 1), (3, 4), (2, 2)] 10
Expected Output: [(1, 1), (2, 2)]
Actual Output: [(1, 1), (2, 2)]

Test Case Number: 2
Input: gaussCircle [(5, 5), (3, 4)] 100
Expected Output: [(5, 5), (3,4)]
Actual Output: [(5, 5), (3, 4)]

Test Case Number: 3
Input: gaussCircle [(3, 3), (5, 5)] 2
Expected Output: []
Actual Output: []

-}
