{-|
Module      : 1JC3-Assign3.Assign_3.hs
Copyright   :  (c) William M. Farmer 2024
License     :  GPL (see the LICENSE file)
Maintainer  :  none
Stability   :  experimental
Portability :  portable

Description:
  Assignment 3 - McMaster CS 1JC3 2024
-}
module Assign_3 where

-----------------------------------------------------------------------------------------------------------
-- INSTRUCTIONS              README!!!
-----------------------------------------------------------------------------------------------------------
-- 1) DO NOT DELETE/ALTER ANY CODE ABOVE THESE INSTRUCTIONS
-- 2) DO NOT REMOVE / ALTER TYPE DECLERATIONS (I.E., THE LINE WITH THE :: ABOUT THE FUNCTION DECLERATION)
--    IF YOU ARE UNABLE TO COMPLETE A FUNCTION, LEAVE IT'S ORIGINAL IMPLEMENTATION (I.E. THROW AN ERROR)
-- 3) MAKE SURE THE PROJECT COMPILES (I.E., RUN STACK BUILD AND MAKE SURE THERE ARE NO ERRORS) BEFORE
--    SUBMITTING, FAILURE TO DO SO WILL RESULT IN A MARK OF 0
-- 4) REPLACE macid = "TODO" WITH YOUR ACTUAL MACID (E.G., IF YOUR MACID IS jim THEN macid = "jim")
-----------------------------------------------------------------------------------------------------------

-- Name: Yusuf Alam
-- Date: November 11 2024
macid :: String
macid = "alamy1"

{- -----------------------------------------------------------------
 - Datatypes
 - -----------------------------------------------------------------
 -}

data Poly a = 
    X
  | Coef a
  | Sum (Poly a) (Poly a)
  | Prod (Poly a) (Poly a)
  deriving Show

newtype PolyList a = PolyList [a]
  deriving Show

{- -----------------------------------------------------------------
 - polyFun
 - -----------------------------------------------------------------
 - Description:
 -    Uses type Poly a
 -    The polynomial is represented using X, Coef, Sum & Prod
 -    Calculates the value of the polynomial at a given value
 -    In simpler terms f(a), with a given a
 -}
polyFun :: Num a => Poly a -> a -> a  
polyFun X c = c
polyFun (Coef a) _ = a
polyFun (Sum p q) c = polyFun p c + polyFun q c
polyFun (Prod p q) c = polyFun p c * polyFun q c

{- -----------------------------------------------------------------
 - polyDegree
 - -----------------------------------------------------------------
 - Description:
 -    Uses type Poly a
 -    Returns the degree of the polynomial
 -    The degree of a polynomial is the highest degree term
 -    EX: 3x^3 + x: The degree is 3
 -    Error is thrown for the zero polynomial
 -}
polyDegree :: (Num a, Eq a) => Poly a -> Int
polyDegree X = 1
polyDegree (Coef a)
  | a == 0    = error "The degree of a zero polynomial is undefined"
  | otherwise = 0
polyDegree (Sum p q) = max (polyDegree p) (polyDegree q)
polyDegree (Prod p q) = polyDegree p + polyDegree q

{- -----------------------------------------------------------------
 - polyListFun
 - -----------------------------------------------------------------
 - Description:
 -    Uses PolyList
 -    The polynomial is represented with a list
 -    Starts with the constant coefficient (x^0), moves up until coefficient of x^n
 -    Calculates the value of the polynomial at a given value
 -    As hinted, Horner's method is used
 -    This method multiplies the Coef by X, and then adds the next Coef
 -    Process continues until list is finished
 -}
polyListFun :: Num a => PolyList a -> a -> a
polyListFun (PolyList []) _ = 0
polyListFun (PolyList (c:cs)) x = c + x * polyListFun (PolyList cs) x

{- -----------------------------------------------------------------
 - polyListDegree
 - -----------------------------------------------------------------
 - Description:
 -    Uses PolyList
 -    Returns the degree of the polynomial
 -    Error still thrpwn if all coefficients are 0
 -    
 -}
polyListDegree :: (Num a, Eq a) => PolyList a -> Int
polyListDegree (PolyList coeffs)
  | all (== 0) coeffs = error "The degree of a zero polynomial is undefined"
  | otherwise = length coeffs - 1 - length (takeWhile (== 0) (reverse coeffs))

{- -----------------------------------------------------------------
 - polyListSum
 - -----------------------------------------------------------------
 - Description:
 -    Adds two polynomials represented as PolyLists
 -    If lists arent equal in length, 0s are added / "padded" to match length
 -    Matching Index elements are added returning a new PolyList
 -}
polyListSum :: Num a => PolyList a -> PolyList a -> PolyList a
polyListSum (PolyList p) (PolyList q) = PolyList (zipWith (+) (pad p) (pad q))
  where
    pad xs = xs ++ replicate (max (length p) (length q) - length xs) 0

{- -----------------------------------------------------------------
 - polyListProd
 - -----------------------------------------------------------------
 - Description:
 -    Multiplies two polynomials represented as PolyLists
 -    EX: For 2 binomials it yields the result one would get from "FOILing"
 -}
polyListProd :: Num a => PolyList a -> PolyList a -> PolyList a
polyListProd (PolyList p) (PolyList q) = PolyList (multiply p q)
  where 

    multiply [] _ = []
    multiply (x:xs) q = addPolyLists (map (x *) q ++ replicate (length xs) 0) (0 : multiply xs q)

    addPolyLists :: Num a => [a] -> [a] -> [a]
    addPolyLists p q = zipWith (+) (padToLength maxLength p) (padToLength maxLength q)
      where
        maxLength = max (length p) (length q)

    padToLength :: Num a => Int -> [a] -> [a]
    padToLength n xs = xs ++ replicate (n - length xs) 0


{- -----------------------------------------------------------------
 - polyListToPoly
 - -----------------------------------------------------------------
 - Description:
 -    Converts a polynomial from the PolyList format (a list of coefficients) 
 -    to the Poly format (using Sum and Prod expressions). 
 -}
polyListToPoly :: Num a => PolyList a -> Poly a
polyListToPoly (PolyList []) = Coef 0
polyListToPoly (PolyList (c:cs)) = Sum (Coef c) (Prod X (polyListToPoly (PolyList cs)))

{- -----------------------------------------------------------------
 - polyToPolyList
 - -----------------------------------------------------------------
 - Description:
 -    Converts a polynomial from the Poly format (using Sum and Prod expressions) 
 -    to the PolyList format (a list of coefficients).
 - 
 -    Each element in the resulting list corresponds to the coefficient of 
 -    increasing powers of x, starting with the constant term (x^0)->(1) up to 
 -    the term with the highest degree or x^n
 -
 -    The helper function of trimZeroes removes trailing zeros
 -    Useful for the zero polynomial case so it returns an empty list
 -}
polyToPolyList :: (Num a, Eq a) => Poly a -> PolyList a 
polyToPolyList poly = PolyList (trimZeros (convertPoly poly))
  where
    convertPoly :: (Num a, Eq a) => Poly a -> [a]
    convertPoly X = [0, 1]
    convertPoly (Coef a) = [a]
    convertPoly (Sum p q) = addPolyLists (convertPoly p) (convertPoly q)
    convertPoly (Prod (Coef a) q) = map (a *) (convertPoly q)
    convertPoly (Prod X q) = 0 : convertPoly q
    convertPoly _ = []

    addPolyLists :: Num a => [a] -> [a] -> [a]
    addPolyLists p q = zipWith (+) (padZeros maxLen p) (padZeros maxLen q)
      where
        maxLen = max (length p) (length q)

    padZeros :: Num a => Int -> [a] -> [a]
    padZeros n xs = xs ++ replicate (n - length xs) 0

    trimZeros :: (Num a, Eq a) => [a] -> [a]
    trimZeros xs = 
      if all (== 0) xs 
      then []
      else reverse (dropWhile (== 0) (reverse xs)) 


{- ----------------------------------------------------------------------------
 - TEST PLAN
-------------------------------------------------------------------------------

Function: polyFun
Test Case Number: 1
Input: polyFun (Sum (Coef 270) (Prod (Coef 343) X)) 3
Expected Output: 1299
Actual Output:   1299
Rationale: Using larger numbers to ensure its working: 270 + 343x (x = 3)

Function: polyFun
Test Case Number: 2
Input: polyFun (Coef 5) 13249
Expected Output: 9
Actual Output:   5
Rationale: This is just a constant so any x value should return the constant

Function: polyFun
Test Case Number: 3
Input: polyFun (Prod (Sum (Coef 1) X) (Sum X (Coef 2))) 3
Expected Output: 20
Actual Output:   20
Rationale: To test polynomial multiplication (1 + x) * (x + 2)
           Using Factored form instead of Standard form

-------------------------------------------------------------------------------

Function: polyDegree
Test Case Number: 1
Input: polyDegree (Sum (Coef 1) (Prod (Coef 2) X))
Expected Output: 1
Actual Output:   1
Rationale: Simple case of 1 + 2x to check the basics

Function: polyDegree
Test Case Number: 2
Input: polyDegree (Prod (Sum (Coef 1) X) (Sum X (Coef 2)))
Expected Output: 2
Actual Output:   2
Rationale: Tests polynomial multiplication (1 + x) * (x + 2)
           to check if it carries out the multiplication
           this polynomial expands to 1 + 3x + x^2
           This case is mentioned in the assignment outline

Function: polyDegree
Test Case Number: 3
Input: polyDegree (Coef 0)
Expected Output: Exception: The degree of a zero polynomial is undefined
Actual Output:   Exception: The degree of a zero polynomial is undefined
Rationale: A zero polynomial doesn't have a degree so it is undefined
           I initially set it to -1, but after conversing with peers
           I decided to change it to throw an error

-------------------------------------------------------------------------------

Function: polyListFun
Test Case Number: 1
Input: polyListFun (PolyList [1, 2, 3]) 2
Expected Output: 17
Actual Output:   17
Rationale: Simple test case with sequentially increasing coefficients
           and sequantialy increasing powers for x
           1 + 2x + 3x^2 (x = 2)

Function: polyListFun
Test Case Number: 2
Input: polyListFun (PolyList []) 3
Expected Output: 0
Actual Output:   0
Rationale: Tests an empty polynomial list (zero polynomial) 
           which should just be 0

Function: polyListFun
Test Case Number: 3
Input: polyListFun (PolyList [0, 0, 0, 0, 1]) 3
Expected Output: 81
Actual Output:   81
Rationale: Skipping the first two terms to see if it holds the place of x^2
           0*x^0 + 0*x^1 + 0*x^2 + 0*x^3 + 1*x^4 -> x^4 (x = 3)

-------------------------------------------------------------------------------

Function: polyListDegree
Test Case Number: 1
Input: polyListDegree (PolyList [1, 0, 3])
Expected Output: 2
Actual Output:   2
Rationale: Skips the second index that is for x^1
           1 + 3x^2

Function: polyListDegree
Test Case Number: 2
Input: polyListDegree (PolyList [0, 0, 0, 0, 0, 0, 0, 0])
Expected Output: Exception: The degree of a zero polynomial is undefined
Actual Output:   Exception: The degree of a zero polynomial is undefined
Rationale: Similar test case from before testing the zero polynomial in list form
           Once again it is undefined and should throw an error

Function: polyListDegree
Test Case Number: 3
Input: polyListDegree (PolyList [4, 5, 0, 0])
Expected Output: 1
Actual Output:   1
Rationale: If extra zeros are added it shouldn't have any affect
           should behave as if it were 4 + 5x which is [4, 5]
           * This list an improper polynomial format

-------------------------------------------------------------------------------

Function: polyListSum
Test Case Number: 1
Input: polyListSum (PolyList [1, 2, 3, 4]) (PolyList [5, 6, 7, 8])
Expected Output: PolyList [6, 8, 10,12]
Actual Output:   PolyList [6, 8, 10, 12]
Rationale: Using 4 term polynomials to ensure everything works

Function: polyListSum
Test Case Number: 2
Input: polyListSum (PolyList [1, 2]) (PolyList [1, 1, 1])
Expected Output: PolyList [2, 3, 1]
Actual Output:   PolyList [2, 3, 1]
Rationale: Polynomials of different lengths
           (1 + 2x) + (1 + x + x^2)            

Function: polyListSum
Test Case Number: 3
Input: polyListSum (PolyList [0, 0, 1]) (PolyList [1, 0, 0])
Expected Output: PolyList [1, 0, 1]
Actual Output:   PolyList [1, 0, 1]
Rationale: Addition of 2 polynomials the "skip" terms
           (x^2) + (1)

Function: polyListSum
Test Case Number: 4
Input: polyListSum (PolyList[0,0,0]) (PolyList[2,3]) 
Expected Output: PolyList [2, 3, 0]
Actual Output:   PolyList [2, 3, 0]
Rationale: Another case of uneven lengths
           Took this test case from the Haskell discussions section

-------------------------------------------------------------------------------

Function: polyListProd
Test Case Number: 1
Input: polyListProd (PolyList [1, 2]) (PolyList [3, 4])
Expected Output: PolyList [3, 10, 8]
Actual Output:   PolyList [3, 10, 8]
Rationale: Tests product of two polynomials 1 + 2x and 3 + 4x
           

Function: polyListProd
Test Case Number: 2
Input: polyListProd (PolyList [1, 0, 1]) (PolyList [1, 1])
Expected Output: PolyList [1, 1, 1, 1]
Actual Output:   PolyList [1, 1, 1, 1]
Rationale: Polynomials of different lengths to see if it 
           "shifts" the powers properly

Function: polyListProd
Test Case Number: 3
Input: polyListProd (PolyList [3]) (PolyList [1, 1, 1])
Expected Output: PolyList [3, 3, 3]
Actual Output:   PolyList [3, 3, 3]
Rationale: product with a constant polynomial essentialy multiplies 
           all of the second polynomial by 3

-------------------------------------------------------------------------------

Function: polyListToPoly
Test Case Number: 1
Input: polyListToPoly (PolyList [1, 2, 3])
Expected Output: Sum (Coef 1) (Prod X (Sum (Coef 2) (Prod X (Coef 3))))
Actual Output:   Sum (Coef 1) (Prod X (Sum (Coef 2) (Prod X (Sum (Coef 3) (Prod X (Coef 0))))))
Rationale: Simple case to check functionality before trying more obscure cases 
           Polynomial has the extra redundant 0 at the end

Function: polyListToPoly
Test Case Number: 2
Input: polyListToPoly (PolyList [])
Expected Output: Coef 0
Actual Output:   Coef 0
Rationale: Tests empty list for zero polynomial

Function: polyListToPoly
Test Case Number: 3
Input: polyListToPoly (PolyList [4, 0, 0])
Expected Output: Sum (Coef 4) (Prod X (Prod X (Coef 0)))
Actual Output:   Sum (Coef 4) (Prod X (Sum (Coef 0) (Prod X (Sum (Coef 0) (Prod X (Coef 0))))))
Rationale: Converts Polynomial with extra / trailing zeros at the end
           Still has the issue with the extra 0, however the polynomials are still equivalent

-------------------------------------------------------------------------------

Function: polyToPolyList
Test Case Number: 1
Input: polyToPolyList (Sum (Coef 1) (Prod X (Coef 2)))
Expected Output: PolyList [1, 2]
Actual Output:   PolyList [1, 2]
Rationale: Testing a normal binomial of 1 + 2x seeing its list form

Function: polyToPolyList
Test Case Number: 2
Input: polyToPolyList (Sum (Coef 1) (Prod X (Prod X (Coef 3))))
Expected Output: PolyList [1, 0, 3]
Actual Output:   PolyList [1, 0, 3]
Rationale: This case 1 + 3x^2 skips the x^1 section
           so it tests if there's a 0 in place

Function: polyToPolyList
Test Case Number: 3
Input: polyToPolyList (Coef 0)
Expected Output: PolyList []
Actual Output:   PolyList []
Rationale: Tests zero polynomial for empty list

Function: polyToPolyList
Test Case Number: 4
Input: polyToPolyList (Sum (Coef 2) (Coef (-2)))
Expected Output: PolyList []
Actual Output:   PolyList []
Rationale: 2 + -2 is 0 so it is effectively also a zero polynomial
           Test case taken from the assignment           

Function: polyToPolyList
Test Case Number: 5
Input: polyToPolyList (Sum (Prod (Coef 1) X) (Prod (Coef (-1)) X))
Expected Output: PolyList []
Actual Output:   PolyList []
Rationale: x + -x is 0 so it is also a zero polynomial
           Test case taken from the assignment 


Function: trimZeros
Test Case Number: 1
Input: trimZeros [3, 5, 0, 0]
Expected Output: [3, 5]
Actual Output: [3, 5]
Rationale: Does the helper function does what it says and trims the zeros off

Function: trimZeros
Test Case Number: 2
Input: trimZeros [0, 0, 0]
Expected Output: []
Actual Output: []
Rationale: Checking to see if the function will reduce a zero list to an empty list          
  
---------------------------------------------------------------------------- -}