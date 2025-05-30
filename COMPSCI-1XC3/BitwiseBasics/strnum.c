#include "a2.h"

float str2float(char str[]) {

    int i = 0;
    float result = 0.0f;
    float sign = 1.0f;
    float decimal = 0.0f;
    float decimalPlace = 0.1f;
    bool isDecimal = false;
    
    // checking the first element in the array to see if theres a + / - sign indexes one more after the fact
    if (str[0] == '-') {
        sign = -1.0f;
        i++;
    } else if (str[0] == '+') { // "+3.0" should still be considered valid
        i++;
    }

    // \0 is at the end of the string so once it hits that the array is finished
    while (str[i] != '\0') {
        if (str[i] >= '0' && str[i] <= '9') {
            if (!isDecimal) {
                result = result * 10.0f + (str[i] - '0');
            } else {
                decimal += (str[i] - '0') * decimalPlace;
                decimalPlace *= 0.1f;
            }
        } else if (str[i] == '.') {
            if (isDecimal) {
                return 0.0f;
            }
            isDecimal = true;
        } else if (str[i] == 'f' || str[i] == 'F') {

            if (str[i+1] != '\0') {
                return 0.0f;
            }
        } else {
            return 0.0f;
        }
        i++;
    }
    
    return sign * (result + decimal);
}

int str2int(char str[]) {
    float f_value = str2float(str); //if input passes through float function, the number is an int w/ a truncated decimal
    return (int)f_value;
}

bool isStringPalindrome(char str[]) {

    int length = 0;
    while (str[length] != '\0') {
        length++;
    }

    if (length <= 1) {
        return true; //singleton value always palindrome
    }

    for (int i = 0; i < length / 2; i++) {
        char left = str[i];
        char right = str[length - 1 - i];

        // making sure everything is lowercase by taking advantage of the ascii values
        if (left >= 'A' && left <= 'Z') {
            left = left + 32;
        }
        if (right >= 'A' && right <= 'Z') {
            right = right + 32;
        }
        
        if (left != right) {
            return false;
        }
    }
    
    return true;
}

bool isIntegerPalindrome(unsigned num) {
    if (num < 10) {
        return true; // similar to before singleton always palindrome
    }

    unsigned divisor = 1;
    while (num / divisor >= 10) {
        divisor *= 10;
    }
    
    do {
        unsigned first = num / divisor;
        unsigned last = num % 10;
        
        if (first != last) {
            return false;
        }
        
        num = (num % divisor) / 10;
        divisor /= 100;
    } while (num > 0 && divisor > 0);
    
    return true;
}