# LeetCode:33:20230808:go

tags: #problem_solve #leetcode/medium #golang #binary_search

[Reference](https://leetcode.com/problems/search-in-rotated-sorted-array/)

## Question

There is an integer array `nums` sorted in ascending order (with **distinct** values).

Prior to being passed to your function, `nums` is **possibly rotated** at an unknown pivot index `k` (`1 <= k < nums.length`) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (**0-indexed**). For example, `[0,1,2,4,5,6,7]` might be rotated at pivot index `3` and become `[4,5,6,7,0,1,2]`.

Given the array `nums` **after** the possible rotation and an integer `target`, return _the index of_ `target` _if it is in_ `nums`_, or_ `-1` _if it is not in_ `nums`.

You must write an algorithm with `O(log n)` runtime complexity.

**Example 1:**

**Input:** nums = [4,5,6,7,0,1,2], target = 0
**Output:** 4

**Example 2:**

**Input:** nums = [4,5,6,7,0,1,2], target = 3
**Output:** -1

**Example 3:**

**Input:** nums = [1], target = 0
**Output:** -1

**Constraints:**

- `1 <= nums.length <= 5000`
- -$10^4$ <= `nums[i]` <= $10^4$
- All values of `nums` are **unique**.
- `nums` is an ascending array that is possibly rotated.
- -$10^4$ <= `target` <= $10^4$

## My Solution

Approach (binary search):

1. find pivot point
2. find target

![image](https://i.imgur.com/bXJ2YJo.png)

![image](https://i.imgur.com/JUQHOzv.png)

pivot locate in the:

- index 0 if right > mid > left
- left part if left > right > mid
- right part if mid > left > right

```go
func search(nums []int, target int) int {
	if len(nums) == 1 {
		if nums[0] == target {
			return 0
		}
		return -1
	}

	left := 0
	right := len(nums) - 1

	isPivotPoint := func(index int) bool {
		if index == 0 {
			return nums[len(nums)-1] > nums[0]
		}

		return nums[index-1] > nums[index]
	}

	pivot := -1
	for left <= right {
		mid := left + ((right - left) / 2)
		if isPivotPoint(mid) {
			pivot = mid
			break
		}
		if nums[left] > nums[mid] {
			right = mid - 1
			continue
		}
		if nums[right] > nums[mid] {
			pivot = left
			break
		}
		left = mid + 1
	}
	if pivot == -1 {
		pivot = left
	}

	if nums[len(nums)-1] >= target {
		left = pivot
		right = len(nums) - 1
	} else {
		left = 0
		right = pivot - 1
	}

	for left <= right {
		mid := left + ((right - left) / 2)
		if nums[mid] == target {
			return mid
		}
		if nums[mid] > target {
			right = mid - 1
			continue
		}
		left = mid + 1
	}
	return -1
}
```

result:

![image](https://i.imgur.com/FcyjfJc.png)

## Better Solutions

### solution 1

according to [this solution](https://leetcode.com/problems/search-in-rotated-sorted-array/solutions/3879263/100-binary-search-easy-video-o-log-n-optimal-solution/).

```go
func search(nums []int, target int) int {
    low, high := 0, len(nums) - 1

    for low <= high {
        mid := (low + high) / 2

        if nums[mid] == target {
            return mid
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

    return -1
}
```
