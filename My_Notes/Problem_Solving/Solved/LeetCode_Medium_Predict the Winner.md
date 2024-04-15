# LeetCode:486:20230728:go

tags: #problem_solve #dynamic_programming #golang

[Reference](https://leetcode.com/problems/predict-the-winner/)

## Question

You are given an integer array `nums`. Two players are playing a game with this array: player 1 and player 2.

Player 1 and player 2 take turns, with player 1 starting first. Both players start the game with a score of `0`. At each turn, the player takes one of the numbers from either end of the array (i.e., `nums[0]` or `nums[nums.length - 1]`) which reduces the size of the array by `1`. The player adds the chosen number to their score. The game ends when there are no more elements in the array.

Return `true` if Player 1 can win the game. If the scores of both players are equal, then player 1 is still the winner, and you should also return `true`. You may assume that both players are playing optimally.

**Example 1:**

**Input:** nums = [1,5,2]
**Output:** false
**Explanation:** Initially, player 1 can choose between 1 and 2.
If he chooses 2 (or 1), then player 2 can choose from 1 (or 2) and 5. If player 2 chooses 5, then player 1 will be left with 1 (or 2).
So, final score of player 1 is 1 + 2 = 3, and player 2 is 5.
Hence, player 1 will never be the winner and you need to return false.

**Example 2:**

**Input:** nums = [1,5,233,7]
**Output:** true
**Explanation:** Player 1 first chooses 1. Then player 2 has to choose between 5 and 7. No matter which number player 2 choose, player 1 can choose 233.
Finally, player 1 has more score (234) than player 2 (12), so you need to return True representing player1 can win.

**Constraints:**

- `1 <= nums.length <= 20`
- `0 <= nums[i] <= 10^7`

## My Solution

Approach:

- dynamic programming
- track the score difference between player 1 and player 2 (positive if player 1 is leading)
- on player 1's turn: let the difference larger
- on player 2's turn: let the difference smaller

in the first step, I attempted to implement without dp.

```go
func PredictTheWinner(nums []int) bool {
	return predictTheWinnerPlayer1(0, nums) >= 0
}

func predictTheWinnerPlayer1(diff int, nums []int) int {
	if len(nums) == 0 {
		return diff
	}
	newNumsFirst, first := takeFirst(nums)
	resFirst := predictTheWinnerPlayer2(diff+first, newNumsFirst)

	newNumsLast, last := takeLast(nums)
	resLast := predictTheWinnerPlayer2(diff+last, newNumsLast)

	if resFirst+first > resLast+last {
		return resFirst + first
	}

	return resLast + last
}

func predictTheWinnerPlayer2(diff int, nums []int) int {
	if len(nums) == 0 {
		return diff
	}
	newNumsFirst, first := takeFirst(nums)
	resFirst := predictTheWinnerPlayer1(diff-first, newNumsFirst)

	newNumsLast, last := takeLast(nums)
	resLast := predictTheWinnerPlayer1(diff-last, newNumsLast)

	if resFirst-first < resLast-last {
		return resFirst - first
	}

	return resLast - last
}

func takeLast(nums []int) (rest []int, last int) {
	return nums[:len(nums)-1], nums[len(nums)-1]
}

func takeFirst(nums []int) (rest []int, first int) {
	return nums[1:], nums[0]
}

```

(it is able to combine the `predictTheWinnerPlayer1` and `predictTheWinnerPlayer2` to a function, but it will cause additional if scopes)

it should be slow, so let's add a dp table to store the answers we have calculated.

attempt to submit...

![image](https://i.imgur.com/m5Cp1Na.png)

😕😕😕❓❓❓ How come this answer is acceptable?

(it is a bit of a hassle to design the dp table since an array which is not a comparable type cannot be used as a map key)

```go
func PredictTheWinner(nums []int) bool {
	n := len(nums)
	dp := make([][]int, n)
	for i := 0; i < n; i++ {
		dp[i] = make([]int, n)
	}

	for i := 0; i < n; i++ {
		dp[i][i] = nums[i]
	}

	for length := 1; length < n; length++ {
		for start := 0; start < n-length; start++ {
			end := start + length
			dp[start][end] = max(nums[start]-dp[start+1][end], nums[end]-dp[start][end-1])
		}
	}

	return dp[0][n-1] >= 0
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

![image](https://i.imgur.com/RGxUA75.png)

## Better Solutions
