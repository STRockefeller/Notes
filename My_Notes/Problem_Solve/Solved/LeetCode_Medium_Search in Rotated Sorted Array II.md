# LeetCode:81:20230810:go

tags: #problem_solve #leetcode/medium #binary_search #golang

[Reference](https://leetcode.com/problems/search-in-rotated-sorted-array-ii/)

## Question

There is an integer array `nums` sorted in non-decreasing order (not necessarily with **distinct** values).

Before being passed to your function, `nums` is **rotated** at an unknown pivot index `k` (`0 <= k < nums.length`) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (**0-indexed**). For example, `[0,1,2,4,4,4,5,6,6,7]` might be rotated at pivot index `5` and become `[4,5,6,6,7,0,1,2,4,4]`.

Given the array `nums` **after** the rotation and an integer `target`, return `true` _if_ `target` _is in_ `nums`_, or_ `false` _if it is not in_ `nums`_._

You must decrease the overall operation steps as much as possible.

**Example 1:**

**Input:** nums = [2,5,6,0,0,1,2], target = 0
**Output:** true

**Example 2:**

**Input:** nums = [2,5,6,0,0,1,2], target = 3
**Output:** false

**Constraints:**

- `1 <= nums.length <= 5000`
- `-10^4 <= nums[i] <= 10^4`
- `nums` is guaranteed to be rotated at some pivot.
- `-10^4 <= target <= 10^4`

## My Solution

the previous problem is [[LeetCode_Medium_Search in Rotated Sorted Array]]

I tried the previous answer and failed with ![image](https://i.imgur.com/VpHIqYX.png)

according to the case ![image](https://i.imgur.com/uPeaxn5.png)

I could not check the pivot point is at the left or right part by the mid value and the left/right value since they may be duplicated.

---

Approach: if I move the left/right point to prevent it from equaling the mid point ...

```go
func search(nums []int, target int) bool {
	low, high := 0, len(nums)-1

	for low <= high {
		mid := (low + high) / 2

		if nums[mid] == target {
			return true
		}

		if nums[low] == nums[mid] && low != mid {
			low += 1
			continue
		}

		if nums[high] == nums[mid] && high != mid {
			high -= 1
			continue
		}

		if nums[low] <= nums[mid] {
			if nums[low] <= target && target < nums[mid] {
				high = mid - 1
			} else {
				low = mid + 1
			}
		} else {
			if nums[mid] < target && target <= nums[high] {
				low = mid + 1
			} else {
				high = mid - 1
			}
		}
	}

	return false
}
```

Solved

## Better Solutions
