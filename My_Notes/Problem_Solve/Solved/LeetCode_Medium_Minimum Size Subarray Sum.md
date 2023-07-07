# LeetCode:209:20230706:Go

tags: #problem_solve #golang

[Reference](https://leetcode.com/problems/minimum-size-subarray-sum/)

## Question

Given an array of positive integers nums and a positive integer target, return the minimal length of a
subarray
 whose sum is greater than or equal to target. If there is no such subarray, return 0 instead.

Example 1:

```text
Input: target = 7, nums = [2,3,1,2,4,3]
Output: 2
Explanation: The subarray [4,3] has the minimal length under the problem constraint.
```

Example 2:

```text
Input: target = 4, nums = [1,4,4]
Output: 1
```

Example 3:

```text
Input: target = 11, nums = [1,1,1,1,1,1,1,1]
Output: 0
```

Constraints:

1 <= target <= $10^9$
1 <= nums.length <= $10^5$
1 <= nums[i] <= $10^4$

Follow up: If you have figured out the O(n) solution, try coding another solution of which the time complexity is O(n log(n)).

## My Solution

Approach: two pointers

```go
func minSubArrayLen(target int, nums []int) int {
	// pointers
	start := 0

	sum := 0
	const maxLength = 100001
	length := maxLength

	moveStart := func() {
		sum -= nums[start]
		start++
	}

	updateLength := func(end int) {
		tempLength := end - start + 1
		if tempLength < length {
			length = tempLength
		}
	}

	for end, num := range nums {
		sum += num
		if sum >= target {
			for sum >= target && start <= end {
				updateLength(end)
				if start == end {
					break
				}
				moveStart()
			}
		}
	}

	if length == maxLength {
		return 0
	}
	return length
}
```

![image](https://i.imgur.com/WhjHSuo.png)

## Better Solutions
