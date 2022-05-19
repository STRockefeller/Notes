# Knuth–Morris–Pratt algorithm

[wiki](https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm)

[初學者學 KMP 演算法](https://yeefun.github.io/kmp-algorithm-for-beginners/)



## wiki sample

[維基百科](https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm)這個範例還滿好懂得，借來用一下

To illustrate the algorithm's details, consider a (relatively artificial) run of the algorithm, where `W` = "ABCDABD" and `S` = "ABC ABCDAB ABCDABCDABDE". At any given time, the algorithm is in a state determined by two integers:

- `m`, denoting the position within `S` where the prospective match for `W` begins,
- `i`, denoting the index of the currently considered character in `W`.

In each step the algorithm compares `S[m+i]` with `W[i]` and increments `i` if they are equal. This is depicted, at the start of the run, like

![](https://i.imgur.com/NlW4j9w.png)

The algorithm compares successive characters of `W` to "parallel" characters of `S`, moving from one to the next by incrementing `i` if they match. However, in the fourth step `S[3] = ' '` does not match `W[3] = 'D'`. Rather than beginning to search again at `S[1]`, we note that no `'A'` occurs between positions 1 and 2 in `S`; hence, having checked all those characters previously (and knowing they matched the corresponding characters in `W`), there is no chance of finding the beginning of a match. Therefore, the algorithm sets `m = 3` and `i = 0`.

![](https://i.imgur.com/aNS3Lu7.png)

This match fails at the initial character, so the algorithm sets `m = 4` and `i = 0`

![](https://i.imgur.com/1h1NBAh.png)

Here, `i` increments through a nearly complete match `"ABCDAB"` until `i = 6` giving a mismatch at `W[6]` and `S[10]`. However, just prior to the end of the current partial match, there was that substring `"AB"` that could be the beginning of a new match, so the algorithm must take this into consideration. As these characters match the two characters prior to the current position, those characters need not be checked again; the algorithm sets `m = 8` (the start of the initial prefix) and `i = 2` (signaling the first two characters match) and continues matching. Thus the algorithm not only omits previously matched characters of `S` (the `"AB"`), but also previously matched characters of `W` (the prefix `"AB"`).

![](https://i.imgur.com/5HPgM5R.png)

This search at the new position fails immediately because `W[2]` (a `'C'`) does not match `S[10]` (a `' '`). As in the first trial, the mismatch causes the algorithm to return to the beginning of `W` and begins searching at the mismatched character position of `S`: `m = 10`, reset `i = 0`.

![](https://i.imgur.com/U8HWZW2.png)

The match at `m=10` fails immediately, so the algorithm next tries `m = 11` and `i = 0`.

![](https://i.imgur.com/ZPJtJbU.png)

Once again, the algorithm matches `"ABCDAB"`, but the next character, `'C'`, does not match the final character `'D'` of the word `W`. Reasoning as before, the algorithm sets `m = 15`, to start at the two-character string `"AB"` leading up to the current position, set `i = 2`, and continue matching from the current position.

![](https://i.imgur.com/FTHGgo3.png)

This time the match is complete, and the first character of the match is `S[15]`.