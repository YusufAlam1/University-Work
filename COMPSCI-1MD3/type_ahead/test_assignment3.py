import pytest
from assignment3 import insert, count_words, contains, height, count_from_prefix, get_suggestions

# the doc test ones
def test_count_words():
    data = {}
    insert(data, "test")
    insert(data, "testing")
    insert(data, "doc")
    insert(data, "docs")
    insert(data, "document")
    insert(data, "documenting")
    assert count_words(data) == 6

def test_contains():
    data = {}
    insert(data, "tree")
    insert(data, "trie")
    insert(data, "try")
    insert(data, "trying")
    assert contains(data, "try") == True
    assert contains(data, "trying") == True
    assert contains(data, "the") == False

def test_height():
    data = {}
    insert(data, "test")
    insert(data, "testing")
    insert(data, "doc")
    insert(data, "docs")
    insert(data, "document")
    insert(data, "documenting")
    assert height(data) == 11

def test_count_from_prefix():
    data = {}
    insert(data, "python")
    insert(data, "pro")
    insert(data, "professionnal")
    insert(data, "program")
    insert(data, "programming")
    insert(data, "programmer")
    insert(data, "programmers")
    assert count_from_prefix(data, 'pro') == 5
    assert count_from_prefix(data, 'Pro') == 0

def test_get_suggestions():
    data = {}
    insert(data, "python")
    insert(data, "pro")
    insert(data, "professionnal")
    insert(data, "program")
    insert(data, "programming")
    insert(data, "programmer")
    insert(data, "programmers")
    assert get_suggestions(data, "progr") == ['program', 'programming', 'programmer', 'programmers']
    assert get_suggestions(data, "Progr") == []

# extra that werent in the doc test
def test_count_words_empty():
    data = {}
    assert count_words(data) == 0

def test_count_words_single_word():
    data = {}
    insert(data, "apple")
    assert count_words(data) == 1

def test_count_words_duplicate_inserts():
    data = {}
    insert(data, "apple")
    insert(data, "apple")
    assert count_words(data) == 1

def test_contains_empty_trie():
    data = {}
    assert contains(data, "any") == False

def test_contains_partial_word():
    data = {}
    insert(data, "basketball")
    assert contains(data, "basket") == False

def test_contains_case_sensitivity():
    data = {}
    insert(data, "hello")
    assert contains(data, "Hello") == False

def test_contains_word_not_in_trie():
    data = {}
    insert(data, "world")
    assert contains(data, "word") == False

def test_height_empty_trie():
    data = {}
    assert height(data) == 0

def test_height_single_word():
    data = {}
    insert(data, "banana")
    assert height(data) == 6

def test_height_with_multiple_words():
    data = {}
    insert(data, "fun")
    insert(data, "function")
    insert(data, "functional")
    assert height(data) == 10

def test_count_from_prefix_no_matching_prefix():
    data = {}
    insert(data, "coding")
    insert(data, "code")
    assert count_from_prefix(data, "pro") == 0

def test_count_from_prefix_empty_prefix():
    data = {}
    insert(data, "abc")
    insert(data, "abcd")
    insert(data, "abcdef")
    assert count_from_prefix(data, "") == 0

def test_count_from_prefix_exact_match():
    data = {}
    insert(data, "pro")
    assert count_from_prefix(data, "pro") == 0

def test_get_suggestions_no_match():
    data = {}
    insert(data, "physics")
    assert get_suggestions(data, "chem") == []

def test_get_suggestions_with_exact_match():
    data = {}
    insert(data, "program")
    insert(data, "programming")
    insert(data, "programmer")
    suggestions = get_suggestions(data, "program")
    assert "program" not in suggestions
    assert sorted(suggestions) == sorted(["programming", "programmer"])

def test_combined_operations():
    data = {}
    insert(data, "music")
    insert(data, "musician")
    insert(data, "musical")
    assert count_words(data) == 3
    assert contains(data, "music")
    assert not contains(data, "mus")
    assert height(data) == 8
    assert count_from_prefix(data, "mus") == 3
    assert get_suggestions(data, "mus") == ["music", "musician", "musical",]

def test_complex_trie_operations():
    data = {}
    insert(data, "basket")
    insert(data, "basketball")
    insert(data, "basketballer")
    insert(data, "basketballers")
    insert(data, "ball")
    assert count_words(data) == 5
    assert height(data) == 13
    assert count_from_prefix(data, "basket") == 3
    assert get_suggestions(data, "basketball") == ["basketballer", "basketballers"]