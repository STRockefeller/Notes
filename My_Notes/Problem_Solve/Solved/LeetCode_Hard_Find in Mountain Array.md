# LeetCode:1095:20231012:go

tags: #problem_solve #leetcode/hard #binary_search #golang

[Reference](https://leetcode.com/problems/find-in-mountain-array)

## Question

(This problem is an interactive problem.)

You may recall that an array arr is a mountain array if and only if:

arr.length >= 3
There exists some i with 0 < i < arr.length - 1 such that:
arr[0] < arr[1] < ... < arr[i - 1] < arr[i]
arr[i] > arr[i + 1] > ... > arr[arr.length - 1]
Given a mountain array mountainArr, return the minimum index such that mountainArr.get(index) == target. If such an index does not exist, return -1.

You cannot access the mountain array directly. You may only access the array using a MountainArray interface:

MountainArray.get(k) returns the element of the array at index k (0-indexed).
MountainArray.length() returns the length of the array.
Submissions making more than 100 calls to MountainArray.get will be judged Wrong Answer. Also, any solutions that attempt to circumvent the judge will result in disqualification.

Example 1:

Input: array = [1,2,3,4,5,3,1], target = 3
Output: 2
Explanation: 3 exists in the array, at index=2 and index=5. Return the minimum index, which is 2.
Example 2:

Input: array = [0,1,2,4,2,1], target = 3
Output: -1
Explanation: 3 does not exist in the array, so we return -1.

Constraints:

3 <= mountain_arr.length() <= 10^4
0 <= target <= 10^9
0 <= mountain_arr.get(index) <= 10^9

## My Solution

Approach:

- find peak (binary search)
- find the target in the left part
- find the target in the right part if I could not find it at the previous

```go
/**
 * // This is the MountainArray's API interface.
 * // You should not implement it, or speculate about its implementation
 * type MountainArray struct {
 * }
 *
 * func (this *MountainArray) get(index int) int {}
 * func (this *MountainArray) length() int {}
 */

type slant int

const (
	topRight slant = iota
	topLeft
	peak
)

func findInMountainArray(target int, mountainArr *MountainArray) int {
	peak := findPeak(mountainArr)
	if mountainArr.get(peak) == target{
		return peak
	}
	var res int
	res = findLeftPart(target, peak, mountainArr)
	if res == -1 {
		res = findRightPart(target, peak, mountainArr)
	}
	return res
}

func findLeftPart(target int, peak int, mountainArr *MountainArray) int {
	l := 0
	r := peak
	for l < r {
		m := (l + r) / 2
		switch {
		case mountainArr.get(m) > target:
			r = m - 1
		case mountainArr.get(m) < target:
			l = m + 1
		default:
			return m
		}
	}
	
    if mountainArr.get(l) == target{
        return l
    }
    return -1
}

func findRightPart(target int, peak int, mountainArr *MountainArray) int {
	l := peak
	r := mountainArr.length() - 1
	for l < r {
		m := (l + r) / 2
		switch {
		case mountainArr.get(m) > target:
			l = m + 1
		case mountainArr.get(m) < target:
			r = m - 1
		default:
			return m
		}
	}

    if mountainArr.get(l) == target{
        return l
    }
	return -1
}

func findPeak(mountainArr *MountainArray) int {
	l := 0
	r := mountainArr.length() - 1
	for l < r {
		m := (l + r) / 2
		s := getSlant(m, mountainArr)
		switch s {
		case peak:
			return m
		case topLeft:
			r = m - 1
		case topRight:
			l = m + 1
		}
	}
	return l
}

func getSlant(target int, mountainArr *MountainArray) slant {
	if target == 0 {
		return topRight
	}
	if target == mountainArr.length()-1 {
		return topLeft
	}

	l := mountainArr.get(target - 1)
	m := mountainArr.get(target)
	r := mountainArr.get(target + 1)

	switch {
	case l > m:
		return topLeft
	case r > m:
		return topRight
	default:
		return peak
	}
}
```

result:

![image](https://i.imgur.com/ypoDbiN.png)

## Better Solutions
