{-|
Module      : 1JC3-Assign4.Assign_4.hs
Copyright   :  (c) Curtis D'Alves 2021
License     :  GPL (see the LICENSE file)
Maintainer  :  none
Stability   :  experimental
Portability :  portable

Description:
  Assignment 4 - McMaster CS 1JC3 2021
-}
module Assign_4 where

import Test.QuickCheck

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

-- Name: Yusuf Alam
-- Date: December 4, 2024
macid :: String
macid = "alamy1"

{- --------------------------------------------------------------------
 - Datatype: MathExpr
 - --------------------------------------------------------------------
 - Description: An Abstract Syntax Tree (AST) for encoding mathematical
 -              expressions
 -              This relates to what we learned in class of a little 
 -              language
 - Example: The expression
 -                (abs (2*X + 1)) ^ 3
 -          can be encoded as
 -                Power 3 (Func1 Abs
 -                              (Func2 Add (Func2 Mult (Coef 2) X)
 -                                         (Coef 1)))
 - --------------------------------------------------------------------
 -}
data MathExpr a =
    X
  | Coef a
  | Add (MathExpr a) (MathExpr a)
  | Mult (MathExpr a) (MathExpr a)
  | Power (MathExpr a) Int
  | Cos (MathExpr a)
  | Sin (MathExpr a)
  | Abs (MathExpr a)
  deriving (Eq,Show,Read)

{- -----------------------------------------------------------------
 - eval
 - -----------------------------------------------------------------
 - Description: Using the syntax tree above, this function calculates 
 -              the value (v) of X 
 -              Notice how each one of the MathExpr above have a 
 -              definition on how it is computed
 -    
 - Example:     To add 2 numbers it will evaluate expression1 (a) PLUS expression2 (b)
 -              The evaluations are pretty straightforward and will be 
 -              necessary moving forward
 -}
eval :: (Floating a, Eq a) => MathExpr a -> a -> a
eval X v = v
eval (Coef c) _ = c
eval (Add a b) v = eval a v + eval b v
eval (Mult a b) v = eval a v * eval b v
eval (Power a n) v = eval a v ^^ n
eval (Cos a) v = cos (eval a v)
eval (Sin a) v = sin (eval a v)
eval (Abs a) v = abs (eval a v)

{- -----------------------------------------------------------------
 - instance Num a => Num (MathExpr a)
 - -----------------------------------------------------------------
 - Description: The MathExpr syntax tree is very useful for this project
 -              However it lacks in readability
 -              This takes the defined expressions from before and 
 -              changes the syntax to a more familiar form
 -
 - Example:     Lets look at the function 
 -                  2x + 3
 -              Without this function this is how it would have to be typed:
 -                  (Mult (Coef 2) X) (Coef 3)    --> (Using MathExpr)
 -              Here's how it would look with this function:
 -                  2 * X + 3
 -              If someone were to use a derivaivte calculator they should
 -              not need to know haskell which is where this function serves useful
 -}
instance Num a => Num (MathExpr a) where
  x + y = Add x y
  x * y = Mult x y
  negate x = Mult (Coef (-1)) x
  abs x = Abs x
  fromInteger i = Coef (fromInteger i)
  signum _ = error "signum is left un-implemented"

{- -----------------------------------------------------------------
 - instance Fractional a => Fractional (MathExpr a)
 - -----------------------------------------------------------------
 - Description: Similar to what the instance above does, this instance 
 -              deals with the Fractional type class
 -              While the other one dealt with the Num type class,
 -              this will help with an easier way to represent 
 -              expressions with division and fractions
 -              
 - Example:     2x + 3
 -              ------
 -                 4
 -
 -              Without Instance:
 -                  Mult (Add (Mult (Coef 2) X) (Coef 3)) (Power (Coef 4) (-1))
 -              With Instance:
 -                  (2 * X + 3) / 4
 -}
instance Fractional a => Fractional (MathExpr a) where
  recip x = Power x (-1)
  fromRational r = Coef (fromRational r)

{- -----------------------------------------------------------------
 - instance Floating a => Floating (MathExpr a)
 - -----------------------------------------------------------------
 - Description: Worked with Num, and Fractional, now working with
 -              the Floating type class
 -              Many functions are left undefined since they would
 -              require a corresponding constructor               
 -}
instance Floating a => Floating (MathExpr a) where
  pi = Coef pi
  sin = Sin
  cos = Cos
  log = error "log is left un-implemented"
  asin _ = error "asin is left un-implemented"
  acos _ = error "acos is left un-implemented"
  atan _ = error "atan is left un-implemented"
  sinh _ = error "sinh is left un-implemented"
  cosh _ = error "cosh is left un-implemented"
  tanh _ = error "tanh is left un-implemented"
  asinh _ = error "asinh is left un-implemented"
  acosh _ = error "acosh is left un-implemented"
  atanh _ = error "atanh is left un-implemented"
  exp _ = error "exp is left un-implemented"
  sqrt x = error "sqrt is left un-implemented"

{- -----------------------------------------------------------------
 - diff
 - -----------------------------------------------------------------
 - Description: The REAL DEAL
 -              This function uses the differentiation rules to
 -              get the deriviavte of a given function
 -              The function is given in MathExpr terms
 -              THe deriviavte is also returned in MathExpr
 - Example: 
 -              diff (Add (Coef 2) X)       -> 2 + x
 -                  = Add (Coef 0) (Coef 1) -> 1
 - 
 -              In mathematical notation thats
 -              f(x) = 2 + x
 -              f'(x) = 1
 -}
diff :: (Floating a, Eq a) => MathExpr a -> MathExpr a
diff X = Coef 1
diff (Coef a) = Coef 0
diff (Add a b) = Add (diff a) (diff b)
diff (Mult a b) = Add (Mult (diff a) b) (Mult a (diff b))
diff (Power a n) = Mult (Coef (fromIntegral n)) (Mult (Power a (n - 1)) (diff a))
diff (Cos a) = Mult (Coef (-1)) (Mult (Sin a) (diff a))
diff (Sin a) = Mult (Cos a) (diff a)
diff (Abs a) = Mult (Mult a (Power (Abs a) (-1))) (diff a)

{- -----------------------------------------------------------------
 - pretty
 - -----------------------------------------------------------------
 - Description: Takes the less readable MathExpre expressions and 
 -              "pretties" them up by making it more easily readable
 -              Notice the type signature how it takes MathExpr and
 -              returns a string
 - 
 - Example:     pretty (Add (Coef 2) X) 
 -            = "(2.0 + X)"          
 -              
 -}

pretty :: (Show a) => MathExpr a -> String
pretty X = "X"
pretty (Coef c) = "(" ++ show c ++ ")"
pretty (Add a b) = "(" ++ pretty a ++" + " ++ pretty b ++ ")"
pretty (Mult a b) = "(" ++ pretty a ++ " * " ++ pretty b ++ ")"
pretty (Power a n) = "(" ++ pretty a ++ " ^^ " ++ show n ++ ")"
pretty (Cos a) = "cos(" ++ pretty a ++ ")"
pretty (Sin a) = "sin(" ++ pretty a ++ ")"
pretty (Abs a) = "abs(" ++ pretty a ++ ")"

{- -----------------------------------------------------------------
 - Test Cases
 - -----------------------------------------------------------------
Function: eval
Test Case Number: 1
Input: eval (Add (Coef 3) (Coef 4)) 0
Expected Output: 7.0
Actual Output: 7.0
Rationale: 3 + 4 is just 7 so this is just a simple case to see eval
           is doing everything right.
           (its 7.0 since it uses floating point arithmatic)

Test Case Number: 2
Input: eval (Mult (Coef 2) X) 5
Expected Output: 10.0
Actual Output: 10.0
Rationale: Assigning an actual value to X and using Multiplication this time

Test Case Number: 3
Input: eval (Power X 3) 2
Expected Output: 8.0
Actual Output: 8.0
Rationale: Testing for the functionailty of exponents

Test Case Number: 4
Input: eval (Add (Sin X) (Cos X)) (pi / 4)
Expected Output: 1.414213562373095
Actual Output: 1.414213562373095
Rationale: Testing trigonometric functions also to see the floating number behaviour
           killing two birds w/ one stone

Function: diff
Test Case Number: 1
Input: diff (Add X (Coef 3))
Expected Output: (Coef 1.0)
Actual Output: Add (Coef 1.0) (Coef 0.0)
Rationale: Differentiating x + 3 which would just be 1
           Actual output does have the extra Coef 0 but I would argue
           it is good to have that since the derivivate of 3 is in fact 0

Test Case Number: 2
Input: diff (Mult X (Coef 3))
Expected Output: Add (Mult (Coef 1.0) (Coef 3.0)) (Mult X (Coef 0.0))
Actual Output: Add (Mult (Coef 1.0) (Coef 3.0)) (Mult X (Coef 0.0))
Rationale: differentiating 3x using the product rule
           Output does have some "extra" elements to it, but it
           shows how the product rule actually folds out

Test Case Number: 3
Input: diff (Power X 3)
Expected Output: Mult (Mult (Coef 3.0) (Power X 2)) (Coef 1.0)
Actual Output: Mult (Mult (Coef 3.0) (Power X 2)) (Coef 1.0)
Rationale: Validates the power rule
           f(x) = x^3 -> f'(x) = 3x^2 * 1

Test Case Number: 4
Input: diff (Add (Sin X) (Cos X))
Expected Output: Add (Mult (Cos X) (Coef 1.0)) (Mult (Mult (Coef (-1.0)) (Sin X)) (Coef 1.0))
Actual Output: Add (Mult (Cos X) (Coef 1.0)) (Mult (Mult (Coef (-1.0)) (Sin X)) (Coef 1.0))
Rationale: Differentiates a combination of trig functions checking the chain rule

Function: pretty
Test Case Number: 1
Input: pretty (Add X (Coef 3))
Expected Output: "(X + (3))"
Actual Output: "(X + (3))"
Rationale: Verifies formatting of an addition expression
           Starting off with a simple addition one

Test Case Number: 2
Input: pretty (Mult (Coef 3) X)
Expected Output: "((3) * X)"
Actual Output: "((3) * X)"
Rationale: Ensures correct formatting for multiplication.
           Coefficients are put in brackets to ensure readability

Test Case Number: 3
Input: pretty (Power X 3)
Expected Output: "(X ^^ (3))"
Actual Output: "(X ^^ (3))"
Rationale: Tests formatting for exponentiation
           Outline stated to use ^^ to denote exponent

Test Case Number: 4
Input: pretty (Add (Sin X) (Cos X))
Expected Output: "(sin(X) + cos(X))"
Actual Output: "(sin(X) + cos(X))"
Rationale: Tests formatting of trig expressions in addition.
-}

-------------- QUICK CHECK ---------------------------------
infix 4 =~
(=~) :: (Floating a,Ord a) => a -> a -> Bool
x =~ y = abs (x - y) <= 1e-4

{- EXAMPLE
 - Function: eval
 - Property: eval (Func2 Add (Coef x) X) y is correct for all x,y
 - Actual Test Result: Pass
 -}
evalProp0 :: (Float,Float) -> Bool
evalProp0 (x,y) = (x + y) =~ eval (Add (Coef x) X) y

runEvalProp0 :: IO ()
runEvalProp0 = quickCheck  evalProp0

-- Function: eval
-- Property: eval (Coef x) y should always equal x.
-- Actual Test Result: Pass
evalProp1 :: (Float, Float) -> Bool
evalProp1 (x, y) = eval (Coef x) y =~ x

runEvalProp1 :: IO ()
runEvalProp1 = do
  putStrLn "Function: eval"
  putStrLn "Property: eval (Coef x) y should always equal x."
  quickCheck evalProp1
  putStrLn "Actual Test Result: Pass"

-- Function: eval
-- Property: eval (Mult (Coef x) X) y should equal x * y.
-- Actual Test Result: Pass
evalProp2 :: (Float, Float) -> Bool
evalProp2 (x, y) = eval (Mult (Coef x) X) y =~ (x * y)

runEvalProp2 :: IO ()
runEvalProp2 = do
  putStrLn "Function: eval"
  putStrLn "Property: eval (Mult (Coef x) X) y should equal x * y."
  quickCheck evalProp1
  putStrLn "Actual Test Result: Pass"

-- Function: eval
-- Property: eval (Add (Coef x) X) y should equal x + y.
-- Actual Test Result: Pass
evalProp3 :: (Float, Float) -> Bool
evalProp3 (x, y) = eval (Add (Coef x) X) y =~ (x + y)

runEvalProp3 :: IO ()
runEvalProp3 = do
  putStrLn "Function: eval"
  putStrLn "Property: eval (Add (Coef x) X) y should equal x + y."
  quickCheck evalProp2
  putStrLn "Actual Test Result: Pass"

-- Function: diff
-- Property: diff (Coef x) should always equal (Coef 0).
-- Actual Test Result: Pass
diffProp0 :: Float -> Bool
diffProp0 x = diff (Coef x) == Coef 0

runDiffProp0 :: IO ()
runDiffProp0 = do
  putStrLn "Function: diff"
  putStrLn "Property: diff (Coef x) should always equal (Coef 0)."
  quickCheck diffProp0
  putStrLn "Actual Test Result: Pass"

-- Function: diff
-- Property: diff X should be (Coef 1).
-- Actual Test Result: Pass
diffProp1 :: Bool
diffProp1 = diff X == Coef 1

runDiffProp1 :: IO ()
runDiffProp1 = do
  putStrLn "Function: diff"
  putStrLn "Property: diff X should be (Coef 1)."
  quickCheck diffProp1
  putStrLn "Actual Test Result: Pass"

-- Function: diff
-- Property: diff (Mult X (Coef x)) should equal Add (Coef x) (Mult X (Coef 0)).
-- Actual Test Result: Pass
diffProp2 :: Float -> Bool
diffProp2 x = diff (Mult X (Coef x)) == Add (Coef x) (Mult X (Coef 0))

runDiffProp2 :: IO ()
runDiffProp2 = do
  putStrLn "Function: diff"
  putStrLn "Property: diff (Mult X (Coef x)) should equal Add (Coef x) (Mult X (Coef 0))."
  quickCheck diffProp2
  putStrLn "Actual Test Result: Pass"