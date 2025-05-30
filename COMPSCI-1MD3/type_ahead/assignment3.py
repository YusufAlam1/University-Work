from typing import List

def insert(data, s: str)-> None:
    if s == "":
        return
    if len(s) == 1:
        if s in data:
            data[s][1] = True
        else:
            data[s] = [{}, True]
    if s[0] in data:
        insert(data[s[0]][0], s[1:])
    else:
        data[s[0]]= [{}, False]
        insert(data[s[0]][0], s[1:])


def count_words(data)->int:
    """
    Returns the number of words encoded in data. You may assume
    data is a valid trie.

    >>> data = {}
    >>> insert(data, "test")
    >>> insert(data, "testing")
    >>> insert(data, "doc")
    >>> insert(data, "docs")
    >>> insert(data, "document")
    >>> insert(data, "documenting")

    >>> count_words(data)
    6
    """
    count = 0
    for key in data:
        if data[key][1]:
            count += 1
        count += count_words(data[key][0])
    return count


def contains(data, s: str)-> bool:
    """
    Returns True if and only if s is encoded within data. You may
    assume data is a valid trie.

    >>> data = {}
    >>> insert(data, "tree")
    >>> insert(data, "trie")
    >>> insert(data, "try")
    >>> insert(data, "trying")
    
    >>> contains(data, "try")
    True
    >>> contains(data, "trying")
    True
    >>> contains(data, "the")
    False
    """
    if s == "":
        return False
    if s[0] in data:
        if len(s) == 1:
            return data[s[0]][1]
        else:
            return contains(data[s[0]][0], s[1:])
    else:
        return False

    # if s in get_suggestions(data, ""):
    #     return

def height(data)->int:
    """
    Returns the length of longest word encoded in data. You may
    assume that data is a valid trie.

    >>> data = {}
    >>> insert(data, "test")
    >>> insert(data, "testing")
    >>> insert(data, "doc")
    >>> insert(data, "docs")
    >>> insert(data, "document")
    >>> insert(data, "documenting")

    >>> height(data)
    11
    """
    longest = 0
    for key in data:
        branch = height(data[key][0]) + 1
        if branch > longest:
            longest = branch
    return longest

def count_from_prefix(data, prefix: str)-> int:
    """
    Returns the number of words in data which starts with the string
    prefix, but is not equal to prefix. You may assume data is a valid
    trie.

    data = {}
    >>> insert(data, "python")
    >>> insert(data, "pro")
    >>> insert(data, "professionnal")
    >>> insert(data, "program")
    >>> insert(data, "programming")
    >>> insert(data, "programmer")
    >>> insert(data, "programmers")

    >>> count_from_prefix(data, 'pro')
    5
    """
    if prefix == "":
        return 0
    
    for char in prefix:
        if char in data:
            data = data[char][0]
        else:
            return 0
    
    if contains(data, prefix):
        total = count_words(data) - 1
    else:
        total = count_words(data)
    
    return total

    # return len(get_suggestions(data, prefix)) 
    # tehcnically also works

def get_suggestions(data, prefix:str)-> List[str]:
    """
    Returns a list of words which are encoded in data, and starts with
    prefix, but is not equal to prefix. You may assume data is a valid
    trie.

    data = {}
    >>> insert(data, "python")
    >>> insert(data, "pro")
    >>> insert(data, "professionnal")
    >>> insert(data, "program")
    >>> insert(data, "programming")
    >>> insert(data, "programmer")
    >>> insert(data, "programmers")

    >>> get_suggestions(data, "progr")
    ['program', 'programming', 'programmer', 'programmers']
    """
    if prefix == "":
        return []

    def collect_words(point, currentW):
        words = [] 
        for char in point:
            sub, isComp = point[char]  # takes the subtree out
            newW = currentW + char  # slowly concatenating the new word
            if isComp:
                words.append(newW)

            subWs = collect_words(sub, newW)
            for word in subWs:
                words.append(word)  # putting it all together
        return words

    for char in prefix:
        if char in data:
            data = data[char][0]
        else:
            return []

    suggestions = collect_words(data, prefix)

    new_suggestions = []
    for word in suggestions:
        if word != prefix:
            new_suggestions.append(word)

    return new_suggestions