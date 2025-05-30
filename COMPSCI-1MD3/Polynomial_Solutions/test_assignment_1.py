from assignment_1 import is_valid_number, is_valid_term, approx_equal, degree_of, get_coefficient

import pytest

def test_is_valid_number():
    assert is_valid_number("10") == True
    assert is_valid_number("-124") == True
    assert is_valid_number("12.9") == True
    assert is_valid_number("12.9.0") == False
    assert is_valid_number("abc") == False
    assert is_valid_number("") == False
    assert is_valid_number("12.") == True
    assert is_valid_number(".12") == True
    assert is_valid_number("-") == False
    assert is_valid_number("12-") == False


def test_is_valid_term():
    assert is_valid_term("44.4x^6") == True
    assert is_valid_term("7x^ 8.8") == False
    assert is_valid_term("x12") == False
    assert is_valid_term("155x^") == False
    assert is_valid_term("1x^1") == True
    assert is_valid_term("120") == True
    assert is_valid_term("16xx") == False
    assert is_valid_term("2x^^2") == False
    assert is_valid_term("40^x^2^2") == False
    assert is_valid_term("^2x") == False


def test_approx_equal():
    assert approx_equal(5, 4, 1) == True
    assert approx_equal(5, 3, 1) == False
    assert approx_equal(0.999, 1, 0.0011) == True
    assert approx_equal(0.999, 1, 0.0001) == False
    assert approx_equal(1, 1, 1) == True
    assert approx_equal(1, 100, 1000000) == True
    assert approx_equal(2000, 100, 10) == False
    assert approx_equal(1, 2, 3) == True
    assert approx_equal(10, 9, 100) == True
    assert approx_equal(0.99, 0.11, 9) == True


def test_degree_of():
    assert degree_of("55x^6") == 6
    assert degree_of("44x^8") == 8
    assert degree_of("10x^0.5") == 0.5
    assert degree_of("12x^1") == 1
    assert degree_of("34x^1") == 1
    assert degree_of("1x^1") == 1
    assert degree_of("120") == 0
    assert degree_of("1x^100") == 100
    assert degree_of("12x^123") == 123
    assert degree_of("x^100") == 100


def test_get_coefficient():
    assert get_coefficient("55x^6") == 55.0
    assert get_coefficient("50x") == 50.0
    assert get_coefficient("x") == 1.0
    assert get_coefficient("x^20") == 1.0
    assert get_coefficient("10") == 10.0
    assert get_coefficient("50x^100") == 50.0
    assert get_coefficient(".11x^2") == 0.11
    assert get_coefficient("1.32x^6") == 1.32
    assert get_coefficient("1.23x^6") == 1.23
    assert get_coefficient("100.0x^10") == 100.0
