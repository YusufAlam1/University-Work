{-|
Module      : 1JC3-Assign1.Assign_1.hs
Copyright   :  (c) Curtis D'Alves 2022
License     :  GPL (see the LICENSE file)
Maintainer  :  none
Stability   :  experimental
Portability :  portable

Description:
  Assignment 1 - McMaster CS 1JC3 2024.

  Modified by W. M. Farmer 19-SEP-2024.
-}
module Assign_1 where

-----------------------------------------------------------------------------------------------------------
-- INSTRUCTIONS              README!!!
-----------------------------------------------------------------------------------------------------------
-- 1) DO NOT DELETE/ALTER ANY CODE ABOVE THESE INSTRUCTIONS AND DO NOT ADD ANY IMPORTS
-- 2) DO NOT REMOVE / ALTER TYPE DECLERATIONS (I.E THE LINE WITH THE :: ABOUT THE FUNCTION DECLERATION)
--    IF YOU ARE UNABLE TO COMPLETE A FUNCTION, LEAVE IT'S ORIGINAL IMPLEMENTATION (I.E. THROW AN ERROR)
-- 3) MAKE SURE THE PROJECT COMPILES (I.E. RUN STACK BUILD AND MAKE SURE THERE ARE NO ERRORS) BEFORE
--    SUBMITTING, FAILURE TO DO SO WILL RESULT IN A MARK OF 0
-- 4) REPLACE macid = "TODO" WITH YOUR ACTUAL MACID (EX. IF YOUR MACID IS jim THEN macid = "jim")
-----------------------------------------------------------------------------------------------------------

-- Name: Yusuf Alam
-- Date: September 23, 2024
macid :: String
macid = "alamy1"

(***) :: Double -> Double -> Double
x *** y = if x >= 0 then x ** y else -( (-x) ** y)

{- -----------------------------------------------------------------
 - cubicQ
 - -----------------------------------------------------------------
 - Description:
 -    Computes Q from a, b, and c using Cardano's Formula
 -}
cubicQ :: Double -> Double -> Double -> Double
cubicQ a b c = (3 * a * c - b^2) / (9 * a^2)

{- -----------------------------------------------------------------
 - cubicR
 - -----------------------------------------------------------------
 - Description:
 -   Computes R from a, b, c, and d using Cardano's Formula
 -}
cubicR :: Double -> Double -> Double -> Double -> Double
cubicR a b c d = (9 * a * b * c - 27 * a^2 * d - 2 * b^3) / (54 * a^3)

{- -----------------------------------------------------------------
 - cubicDiscSign
 - -----------------------------------------------------------------
 - Description:
 -   Computes the sign of the discriminant from the previously 
     calculated values of Q and R
 -   -1 is returned if the discriminant is negative
 -   0 is returned if the discriminant is 0
 -   1 is returned if the discriminant is positive
 -}
cubicDiscSign :: Double -> Double -> Int
cubicDiscSign q r
  | disc < 0  = -1
  | disc == 0 = 0
  | otherwise = 1
  where
    disc = q**3 + r**2

{- -----------------------------------------------------------------
 - cubicS
 - -----------------------------------------------------------------
 - Description:
 -   Computes S from Q and R using Cardano's Formula
 -}
cubicS :: Double -> Double -> Double
cubicS q r = if value >= 0 
             then value ** (1/3)
             else -((-value) ** (1/3))
  where
    value = r + sqrt (q^3 + r^2)
     
{- -----------------------------------------------------------------
 - cubicT
 - -----------------------------------------------------------------
 - Description:
 -   Computes T from Q and R using Cardano's Formula
 -}
cubicT :: Double -> Double -> Double
cubicT q r = if value >= 0 
             then value ** (1/3)
             else -((-value) ** (1/3))
  where
    value = r - sqrt (q^3 + r^2)

{- -----------------------------------------------------------------
 - cubicRealSolutions
 - -----------------------------------------------------------------
 - Description:
 -   Computes a list of real solutions (non-complex)
 -   returns an empy list if the function is quadratic (a = 0) 
 -   or discriminant is negative
 -   returns 3 solutions if the discriminant is 0 (2 of the roots are equal)
 -   returns 1 solution if the discriminant is positive
 -}
cubicRealSolutions :: Double -> Double -> Double -> Double -> [Double]
cubicRealSolutions a b c d
  | a == 0      = []
  | sign == -1  = []
  | sign ==  0  = [s + t -(b / (3 * a)), 
                   -((s + t) / 2) -(b / (3 * a)),
                   -((s + t) / 2) -(b / (3 * a))]
  | sign ==  1  = [s + t -(b / (3 * a))]
  | otherwise   = []
  where
    sign = cubicDiscSign q r
    q    = cubicQ a b c
    r    = cubicR a b c d
    s    = cubicS q r
    t    = cubicT q r


(===) :: Double -> Double -> Bool
x === y = let
  tol = 1e-3
  in abs (x-y) <= tol

{- -----------------------------------------------------------------
 - Test Cases
 - -----------------------------------------------------------------
 -}