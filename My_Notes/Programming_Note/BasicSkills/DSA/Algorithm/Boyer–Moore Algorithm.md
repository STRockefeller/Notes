# Boyer–Moore Algorithm

The Boyer–Moore algorithm is a string-searching algorithm that efficiently finds occurrences of a pattern in a given text. It was developed by Robert S. Boyer and J Strother Moore in 1977. The algorithm is particularly effective for large patterns and texts, as it can achieve sub-linear average case time complexity.

## Algorithm Overview

The Boyer–Moore algorithm utilizes two heuristics to skip unnecessary comparisons during the search process: the "bad character rule" and the "good suffix rule." These heuristics allow the algorithm to skip ahead in the text based on previously matched characters and patterns.

1. Preprocessing Phase:

    * Build a bad character table, which records the rightmost occurrence of each character in the pattern.
    * Build a good suffix table, which identifies the longest suffix within the pattern that matches a prefix.
2. Searching Phase:

    * Start comparing the pattern with the text from right to left.
    * Move the pattern according to the rules of the bad character and good suffix heuristics until a mismatch occurs or a complete match is found.
    * If a complete match is found, record the occurrence and continue searching for additional matches.

## Example Code

Here is an example implementation of the Boyer–Moore algorithm in Python:

```python
def boyer_moore_search(text, pattern):
    n = len(text)
    m = len(pattern)
    if m == 0:
        return []

    # Build bad character table
    bad_char = {}
    for i in range(m):
        bad_char[pattern[i]] = i

    # Build good suffix table
    suffix = [0] * (m + 1)
    border = [0] * (m + 1)
    compute_suffix(pattern, suffix, border)

    # Search for occurrences
    occurrences = []
    i = 0
    while i <= n - m:
        j = m - 1
        while j >= 0 and pattern[j] == text[i + j]:
            j -= 1
        if j < 0:
            occurrences.append(i)
            i += suffix[0]
        else:
            x = j - bad_char.get(text[i + j], -1)
            y = border[j + 1]
            i += max(x, y)

    return occurrences

def compute_suffix(pattern, suffix, border):
    m = len(pattern)
    i = m
    j = m + 1
    border[i] = j
    while i > 0:
        while j <= m and pattern[i - 1] != pattern[j - 1]:
            if suffix[j] == 0:
                suffix[j] = j - i
            j = border[j]
        i -= 1
        j -= 1
        border[i] = j
    j = border[0]
    for i in range(m):
        if suffix[i] == 0:
            suffix[i] = j
        if i == j:
            j = border[j]
```

## References

1. Boyer R, Moore JS. A Fast String Searching Algorithm. Commun ACM. 1977;20(10):762-772. doi:10.1145/359842.359859

2. Cormen TH, Leiserson CE, Rivest RL, Stein C. Introduction to Algorithms. 3rd ed. The MIT Press; 2009.
