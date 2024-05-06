# LeetCode:2370:20240425:go

tags: #problem_solve #leetcode/medium #dynamic_programming 

[Reference](https://leetcode.com/problems/longest-ideal-subsequence/)

## Question

You are given a string `s` consisting of lowercase letters and an integer `k`. We call a string `t` **ideal** if the following conditions are satisfied:

- `t` is a **subsequence** of the string `s`.
- The absolute difference in the alphabet order of every two **adjacent** letters in `t` is less than or equal to `k`.

Return _the length of the **longest** ideal string_.

A **subsequence** is a string that can be derived from another string by deleting some or no characters without changing the order of the remaining characters.

**Note** that the alphabet order is not cyclic. For example, the absolute difference in the alphabet order of `'a'` and `'z'` is `25`, not `1`.

**Example 1:**

**Input:** s = "acfgbd", k = 2
**Output:** 4
**Explanation:** The longest ideal string is "acbd". The length of this string is 4, so 4 is returned.
Note that "acfgbd" is not ideal because 'c' and 'f' have a difference of 3 in alphabet order.

**Example 2:**

**Input:** s = "abcd", k = 3
**Output:** 4
**Explanation:** The longest ideal string is "abcd". The length of this string is 4, so 4 is returned.

**Constraints:**

- `1 <= s.length <= 105`
- `0 <= k <= 25`
- `s` consists of lowercase English letters.

## My Solution

### knapsack

use the method to solve [[Knapsack Problem|knapsack problems]] to solve this one. but it seems very very inefficient so I give up while writing.

```go
func longestIdealString(s string, k int) int {
    // just like a knapsack problem, I can choose whether to pick the char or not. but it will be 2^n complexity.
}

type validator struct{
    dp map[string]bool
    k int
}

func newValidator(k) validator{
    return validator{
        dp: make(map[string]bool),
        k: k,
    }
}

func abs(i int)int{
    if i<0{
        return -i
    }
    return i
}

func(v *validator)validate(t string)bool{
    if val, ok := v.dp[t];ok{
        return val
    }
    if len(t) == 1{
        v.dp[t] = true
        return true
    }
    if abs(t[len(t)-1] - t[len(t)-2]) > v.k{
        v.dp[t] = false
        v.dp[t[len(t-2):]] = false
        return false
    }
    res := v.validate(t[:len(t)-1])
    v.dp[t] = res
    return res
}
```


### 數學歸納法


有空再改成英文，現在打算一邊紀錄一邊總結想法，用中文比較順一點。

拿 ex1 當例子 **Input:** s = "acfgbd", k = 2

1. 我們用dp紀錄已經算過的內容
1. 採用以任意字元當結尾的subsequence最長者，因為重複的字元若出現在後方肯定會比出現在前方作為結尾擁有相同或更長的subsequence，例如 "abcdawdqwzsa" 單看字元 a 不論 k 限制為多少，後方的a作為結尾一定包含了以前方的a作為結尾的所有subsequences。
1. 所以dp就訂為 [26]int
1. 以下loop，從最開始的字元開始看
1. 對於字元a (s[0]) ，可以接受的相鄰2以內的字元為 a~c。
1. 觀察 dp[a] dp[b] dp[c] 都是 0 ， 將dp[a] 記為 0+1 繼續。
1. 對於字元c (s[1]) ，可以接受的相鄰2以內的字元為 a~e 。
1. 觀察 dp[a] ~ dp[e] 其中 dp[a] 最大 ， 將dp[c] 記為 dp[a]+1 繼續。


```go
func longestIdealString(s string, k int) int {
    dp := make([]int, 26)
    maxLen := 0

    for _, c := range s {
        charIndex := c - 'a'
        
        currentMax := 0
        for d := max(0, int(charIndex)-k); d <= min(25, int(charIndex)+k); d++ {
            currentMax = max(currentMax, dp[d])
        }

        dp[charIndex] = currentMax + 1
        
        maxLen = max(maxLen, dp[charIndex])
    }

    return maxLen
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

```


![image](https://i.imgur.com/QxVVXLP.png)

## Better Solutions
