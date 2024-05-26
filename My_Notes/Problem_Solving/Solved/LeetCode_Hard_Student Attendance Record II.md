# 題目來源:題號:解題日期:語言

tags: #problem_solve

[Reference](https://leetcode.com/problems/student-attendance-record-ii/description/)

## Question

An attendance record for a student can be represented as a string where each character signifies whether the student was absent, late, or present on that day. The record only contains the following three characters:

'A': Absent.
'L': Late.
'P': Present.
Any student is eligible for an attendance award if they meet both of the following criteria:

The student was absent ('A') for strictly fewer than 2 days total.
The student was never late ('L') for 3 or more consecutive days.
Given an integer n, return the number of possible attendance records of length n that make a student eligible for an attendance award. The answer may be very large, so return it modulo 109 + 7.

 

Example 1:

Input: n = 2
Output: 8
Explanation: There are 8 records with length 2 that are eligible for an award:
"PP", "AP", "PA", "LP", "PL", "AL", "LA", "LL"
Only "AA" is not eligible because there are 2 absences (there need to be fewer than 2).
Example 2:

Input: n = 1
Output: 3
Example 3:

Input: n = 10101
Output: 183236316

## My Solution

Approach: dfs

```go
func checkRecord(n int) int {
    return dfs(n,0,0,false)
}

func dfs(n int, day int,consecutiveL int,hasA bool)int{
    if day == n-1{
        res := 1 // today is P
        if consecutiveL!=2{
            res++ // today is L
        }
        if !hasA{
            res++ // today is A
        }
        return res
    }

    p := dfs(n,day+1,0,hasA)

    l := 0
    if consecutiveL <=1{
        l = dfs(n,day+1,consecutiveL+1,hasA)
    }

    a := 0
    if !hasA{
        a = dfs(n,day+1,0,false)
    }
    return p+l+a
}
```

timeout

![image](https://i.imgur.com/Ys0LOIJ.png)

---

use dp to improve the efficiency

```go
func checkRecord(n int) int {
    memo := make(map[[3]int]int)
    return dfs(n, 0, 0, false, memo)
}

func dfs(n int, day int, consecutiveL int, hasA bool, memo map[[3]int]int) int {
    if day == n {
        return 1
    }
    
    state := [3]int{day, consecutiveL, boolToInt(hasA)}
    if val, exists := memo[state]; exists {
        return val
    }
    
    res := dfs(n, day + 1, 0, hasA, memo) // add 'P'
    
    if consecutiveL < 2 {
        res += dfs(n, day + 1, consecutiveL + 1, hasA, memo) // add 'L'
    }
    
    if !hasA {
        res += dfs(n, day + 1, 0, true, memo) // add 'A'
    }
    
    memo[state] = res
    return res
}

func boolToInt(b bool) int {
    if b {
        return 1
    }
    return 0
}
```

got wrong answer when n is big

![image](https://i.imgur.com/a9uP8Pb.png)

oh! i forgot to mod 10^9+7

```go
func checkRecord(n int) int {
    memo := make(map[[3]int]int64)
    return int(dfs(n, 0, 0, false, memo) % 1000000007)
}

func dfs(n int, day int, consecutiveL int, hasA bool, memo map[[3]int]int64) int64 {
    if day == n {
        return 1
    }
    
    state := [3]int{day, consecutiveL, boolToInt(hasA)}
    if val, exists := memo[state]; exists {
        return val
    }
    
    res := dfs(n, day + 1, 0, hasA, memo) // add 'P'
    
    if consecutiveL < 2 {
        res += dfs(n, day + 1, consecutiveL + 1, hasA, memo) // add 'L'
    }
    
    if !hasA {
        res += dfs(n, day + 1, 0, true, memo) // add 'A'
    }
    
    memo[state] = res
    return res
}

func boolToInt(b bool) int {
    if b {
        return 1
    }
    return 0
}
```

still wrong

![image](https://i.imgur.com/DCet2o2.png)


---

mod 10^9+7 in every steps

```go
func checkRecord(n int) int {
    memo := make(map[stateKey]int64)
    return int(dfs(n, 0, 0, false, memo) % 1000000007)
}

type stateKey struct {
    day          int
    consecutiveL int
    hasA         bool
}

func dfs(n int, day int, consecutiveL int, hasA bool, memo map[stateKey]int64) int64 {
    if day == n {
        return 1
    }

    key := stateKey{day, consecutiveL, hasA}
    if val, exists := memo[key]; exists {
        return val
    }

    var res int64
    res = dfs(n, day + 1, 0, hasA, memo) % 1000000007 // add 'P'

    if consecutiveL < 2 {
        res = (res + dfs(n, day + 1, consecutiveL + 1, hasA, memo)) % 1000000007 // add 'L'
    }

    if !hasA {
        res = (res + dfs(n, day + 1, 0, true, memo)) % 1000000007 // add 'A'
    }

    memo[key] = res
    return res
}
```

![image](https://i.imgur.com/LgXyPGC.png)

---

```go
func checkRecord(n int) int {
    const MOD int = 1000000007

    // dp[i][j][k] will be the number of valid sequences of length i
    // j represents the number of 'A's (0 or 1)
    // k represents the number of consecutive 'L's (0, 1, or 2)
    dp := make([][][]int, n+1)
    for i := range dp {
        dp[i] = make([][]int, 2)
        for j := range dp[i] {
            dp[i][j] = make([]int, 3)
        }
    }

    // Base case: There's one way to have a sequence of length 0 (an empty sequence)
    dp[0][0][0] = 1

    for i := 1; i <= n; i++ {
        for j := 0; j <= 1; j++ {
            for k := 0; k <= 2; k++ {
                // Add 'P'
                dp[i][j][0] = (dp[i][j][0] + dp[i-1][j][k]) % MOD
                // Add 'A'
                if j > 0 {
                    dp[i][j][0] = (dp[i][j][0] + dp[i-1][j-1][k]) % MOD
                }
                // Add 'L'
                if k < 2 {
                    dp[i][j][k+1] = (dp[i][j][k+1] + dp[i-1][j][k]) % MOD
                }
            }
        }
    }

    // Sum all valid sequences of length n
    result := 0
    for j := 0; j <= 1; j++ {
        for k := 0; k <= 2; k++ {
            result = (result + dp[n][j][k]) % MOD
        }
    }

    return result
}
```

![image](https://i.imgur.com/iTQcNV5.png)

## Better Solutions

### Solution1

```go
func checkRecord(s int) int {
	if s == 0 {
		return 1
	}
	if s == 1 {
		return 3
	}
	if s == 2 {
		return 8
	}
	mod := int(1e9 + 7)
	dp := make([]int, s+1)
	dp[0] = 1
	dp[1] = 2
	dp[2] = 4
	for i := 3; i <= s; i++ {
		dp[i] = (dp[i-1] + dp[i-2] + dp[i-3]) % mod
	}
	ans := dp[s]
	for i := 1; i <= s; i++ {
		ans += (dp[i-1] * dp[s-i]) % mod
		ans %= mod
	}
	return ans
}
```

finish in 23ms (god like)

#### Code Explanation (by GPT)

The function `checkRecord(s int) int` calculates the number of valid attendance records of length `s`. Here's how it works:

1. **Base Cases**:
   - If `s` is 0, there's only one valid record: the empty record. So, return 1.
   - If `s` is 1, there are three possible valid records: "P", "L", and "A". So, return 3.
   - If `s` is 2, there are eight possible valid records: "PP", "PL", "LP", "LL", "AP", "PA", "LA", and "AL". So, return 8.

2. **Initialization**:
   - Define a large number `mod` which is \(10^9 + 7\). This is used to ensure that our results fit within standard integer ranges by taking the modulo at each step.
   - Create an array `dp` of size `s+1` to store the number of valid records of each length from 0 to `s`.
   - Initialize the first few elements of `dp` based on the base cases:
     - `dp[0] = 1` (one way to have a length 0 record)
     - `dp[1] = 2` (two ways to have a length 1 record without considering 'A')
     - `dp[2] = 4` (four ways to have a length 2 record without considering 'A')

3. **Fill the dp array**:
   - For each length from 3 to `s`, calculate the number of valid records as:
     - `dp[i] = (dp[i-1] + dp[i-2] + dp[i-3]) % mod`
     - This means that for a record of length `i`, we can form it by adding 'P' to a record of length `i-1`, or 'L' to a record of length `i-2`, or another 'L' to a record of length `i-3`.

4. **Calculate the final answer**:
   - Initialize `ans` to `dp[s]`. This is the number of valid records of length `s` without any 'A'.
   - For each position `i` from 1 to `s`, add the number of valid records that have an 'A' at position `i`:
     - Multiply the number of valid records of length `i-1` (before 'A') by the number of valid records of length `s-i` (after 'A'), then take modulo `mod`.
     - Add this product to `ans` and take modulo `mod` again.

5. **Return the final result**:
   - Return the value of `ans` which now contains the total number of valid records of length `s`.

### Simple Summary

1. **Base Cases**: Handle special small lengths directly.
2. **Dynamic Programming Setup**: Use an array to store results for each length up to `s`.
3. **State Transition**: Calculate results for each length based on previous lengths.
4. **Including 'A'**: Adjust the count by considering records with exactly one 'A'.
5. **Result**: Return the total count modulo \(10^9 + 7\).

This ensures that the function runs efficiently even for large `s` by leveraging previously computed results and dynamic programming.