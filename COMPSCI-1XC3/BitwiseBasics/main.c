#include "a2.h"
#include <stdio.h>
#include <stdbool.h>

int main()
{
    // float f = str2float("-11.1f"); 
    // int i = str2int("-1355"); 
    // bool issp = isStringPalindrome("amanaplanacanalPanama"); 
    // bool isip = isIntegerPalindrome(12321); 

    // unsigned r = reversebits(0b11010);
    // unsigned m = mul(12u, 3u); 


        // STR2FLOAT TEST CASES
        char *floatTests[] = {"-11.1f", "123.456", "0.0", "-0.99", "1.2e2", "3.14159", "99.", ".25", "-.75", "1e-3", "NaN", "Infinity", "12.34.56", "AA"};
        int floatTestCount = sizeof(floatTests) / sizeof(floatTests[0]);
        printf("Testing str2float:\n");
        for (int i = 0; i < floatTestCount; i++) {
            printf("str2float(\"%s\") = %f\n", floatTests[i], str2float(floatTests[i]));
        }
    

        // STR2INT TEST CASES
        char *intTests[] = {"-1355", "42", "0", "99999", "-99999", "+123", "-0", "1.5", "12a", "a12", "9999999999"};
        int intTestCount = sizeof(intTests) / sizeof(intTests[0]);
        printf("\nTesting str2int:\n");
        for (int i = 0; i < intTestCount; i++) {
            printf("str2int(\"%s\") = %d\n", intTests[i], str2int(intTests[i]));
        }
    

        // STRPALINDROME TEST CASES
        char *palindromeTests[] = {"amanaplanacanalPanama", "racecar", "hello", "madam", "noon", "abba", "abcd", "Aba", "abcba", "WasItACarOrACatISaw"};
        int palindromeTestCount = sizeof(palindromeTests) / sizeof(palindromeTests[0]);
        printf("\nTesting isStringPalindrome:\n");
        for (int i = 0; i < palindromeTestCount; i++) {
            printf("isStringPalindrome(\"%s\") = %s\n", palindromeTests[i], isStringPalindrome(palindromeTests[i]) ? "true" : "false");
        }
    

        // INTPALINDROME TEST CASES
        int intPalindromeTests[] = {123321, 12321, 12345, 0, 7, 22, 1001, 98789, 45654, 111};
        int intPalindromeTestCount = sizeof(intPalindromeTests) / sizeof(intPalindromeTests[0]);
        printf("\nTesting isIntegerPalindrome:\n");
        for (int i = 0; i < intPalindromeTestCount; i++) {
            printf("isIntegerPalindrome(%d) = %s\n", intPalindromeTests[i], isIntegerPalindrome(intPalindromeTests[i]) ? "true" : "false");
        }
    

        // REVERSEBITS TEST CASES
        unsigned reverseTests[] = {0b101, 0b11010, 0b1001, 0b11110000, 0b1, 0b10, 0b100, 0b111, 0b10000000, 0};
        int reverseTestCount = sizeof(reverseTests) / sizeof(reverseTests[0]);
        printf("\nTesting reversebits:\n");
        for (int i = 0; i < reverseTestCount; i++) {
            printf("reversebits(0b%04x) = %u\n", reverseTests[i], reversebits(reverseTests[i]));
        }

    
        // MULTIPLYBITS TEST CASES
        unsigned mulTests[][2] = {{12, 3}, {7, 6}, {0, 1}, {1, 0}, {1, 1}, {15, 15}, {100, 200}, {255, 255}, {2, 8}, {31, 4}};
        int mulTestCount = sizeof(mulTests) / sizeof(mulTests[0]);
        printf("\nTesting mul:\n");
        for (int i = 0; i < mulTestCount; i++) {
            printf("mul(%u, %u) = %u\n", mulTests[i][0], mulTests[i][1], mul(mulTests[i][0], mulTests[i][1]));
        }

    return 0;
}