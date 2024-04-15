# LeetCode:17:20230803:go

tags: #problem_solve #leetcode/medium #golang

[Reference](https://leetcode.com/problems/letter-combinations-of-a-phone-number/)

## Question

Given a string containing digits from `2-9` inclusive, return all possible letter combinations that the number could represent. Return the answer in **any order**.

A mapping of digits to letters (just like on the telephone buttons) is given below. Note that 1 does not map to any letters.

![](https://assets.leetcode.com/uploads/2022/03/15/1200px-telephone-keypad2svg.png)

**Example 1:**

**Input:** digits = "23"
**Output:** ["ad","ae","af","bd","be","bf","cd","ce","cf"]

**Example 2:**

**Input:** digits = ""
**Output:** []

**Example 3:**

**Input:** digits = "2"
**Output:** ["a","b","c"]

**Constraints:**

- `0 <= digits.length <= 4`
- `digits[i]` is a digit in the range `['2', '9']`.

## My Solution

Approach: recursion (I think it could be solved with dp, but the max length of digits is only 4 . It is not worth it to do this)

```go
var mapping = map[string][]string{
	"2": {"a", "b", "c"},
	"3": {"d", "e", "f"},
	"4": {"g", "h", "i"},
	"5": {"j", "k", "l"},
	"6": {"m", "n", "o"},
	"7": {"p", "q", "r", "s"},
	"8": {"t", "u", "v"},
	"9": {"w", "x", "y", "z"},
}

func letterCombinations(digits string) []string {
	if len(digits) == 0 {
		return []string{}
	}
	if len(digits) == 1 {
		return mapping[digits]
	}

	first := digits[:1]
    res := []string{}
	for _, char := range mapping[first] {
        res = append(res, addPrefix(char,letterCombinations(digits[1:]))...)
	}
    return res
}

func addPrefix(prefix string, arr []string)[]string{
    res := make([]string,len(arr))
    for i,str := range arr{
        res[i] = prefix + str
    }
    return res
}
```

## Better Solutions
