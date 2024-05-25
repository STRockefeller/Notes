
# KMP (Knuth-Morris-Pratt) Algorithm

tags: #string_searching_algorithms #kmp #algorithms 

## Concept and Principles

The KMP (Knuth-Morris-Pratt) algorithm is a [[String Searching Algorithms|string-matching algorithm]] designed to find the first occurrence of a pattern string (P) within a text string (T) efficiently. It achieves this by avoiding unnecessary comparisons using information [[voc-gleaned|gleaned]] from previous character matches. 

### Principles:
1. **Prefix Function ([[LPS Array for KMP Algorithm|LPS Array]]):** The algorithm precomputes an array called the Longest Prefix Suffix (LPS) array, which stores the length of the longest proper prefix of the pattern that is also a suffix for each position in the pattern. This array helps in determining the next positions to match in the pattern without re-evaluating previously matched characters.
2. **Efficient Matching:** By using the LPS array, the algorithm can skip certain comparisons, thus reducing the overall time complexity compared to the naive approach.

## Steps and Pseudocode

### Steps:

1. **Preprocess the Pattern:**
   - Compute the LPS array for the pattern.
2. **Pattern Matching:**
   - Iterate through the text and pattern using the LPS array to skip unnecessary comparisons.

### Pseudocode:

```python
def computeLPSArray(pattern):
    M = len(pattern)
    lps = [0] * M
    length = 0  # length of the previous longest prefix suffix
    i = 1
    
    while i < M:
        if pattern[i] == pattern[length]:
            length += 1
            lps[i] = length
            i += 1
        else:
            if length != 0:
                length = lps[length - 1]
            else:
                lps[i] = 0
                i += 1
    return lps

def KMPSearch(text, pattern):
    N = len(text)
    M = len(pattern)
    lps = computeLPSArray(pattern)
    i = 0  # index for text
    j = 0  # index for pattern
    
    while i < N:
        if pattern[j] == text[i]:
            i += 1
            j += 1
        
        if j == M:
            print(f"Pattern found at index {i - j}")
            j = lps[j - 1]
        elif i < N and pattern[j] != text[i]:
            if j != 0:
                j = lps[j - 1]
            else:
                i += 1
```

## Complexity Analysis

- **Time Complexity:**
  - The time complexity of the KMP algorithm is \(O(N + M)\), where \(N\) is the length of the text and \(M\) is the length of the pattern.
  - The preprocessing step to compute the LPS array takes \(O(M)\) time.
  - The actual search process in the text takes \(O(N)\) time.

- **Space Complexity:**
  - The space complexity is \(O(M)\) due to the storage of the LPS array.

## Practical Applications

1. **Text Searching:** KMP is widely used in text editors and search engines to find substrings within large texts efficiently.
2. **Bioinformatics:** It is used in DNA sequence analysis to locate specific gene sequences within larger DNA strings.
3. **Plagiarism Detection:** The algorithm helps in detecting similar text patterns across documents.
4. **Networking:** Used in network packet analysis to search for patterns in data streams.

## Variants and Extended Concepts

1. **KMP for Multiple Patterns:** Extensions of the KMP algorithm can handle multiple patterns simultaneously, such as the Aho-Corasick algorithm.
2. **Approximate String Matching:** Variants exist to handle approximate matches where the pattern can differ slightly from the text.
3. **2D Pattern Matching:** The principles of KMP can be extended to two-dimensional pattern matching for image processing applications.
4. **Parallel KMP:** Parallel versions of the algorithm have been developed to leverage multi-core processors for faster processing.

The KMP algorithm remains a fundamental technique in computer science for efficient string matching, balancing preprocessing overhead with rapid search capabilities.