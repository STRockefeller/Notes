# LeetCode:976:20220912:Go

[Reference](https://leetcode.com/problems/largest-perimeter-triangle/)

## Question

Given an integer array `nums`, return *the largest perimeter of a triangle with a non-zero area, formed from three of these lengths*. If it is impossible to form any triangle of a non-zero area, return `0`.

**Example 1:**

**Input:** nums = [2,1,2]
**Output:** 5

**Example 2:**

**Input:** nums = [1,2,1]
**Output:** 0

**Constraints:**

- `3 <= nums.length <= 10^4`
- `1 <= nums[i] <= 10^6`

## My Solution

雖然是Easy難度的題目，不過一開始寫錯了，還是記錄起來引以為鑑。

錯誤解答

```go
func largestPerimeter(nums []int) int {
	sides := findLongestThree(nums)
	if sides[0] >= sides[1]+sides[2] {
		return 0 // not a triangle
	}
	return sides[0] + sides[1] + sides[2]
}

func findLongestThree(nums []int) [3]int {
	var first, second, third int
	for _, num := range nums {
		if num > first {
			third = second
			second = first
			first = num
		} else if num > second {
			third = second
			second = num
		} else if num > third {
			third = num
		}
	}
	return [3]int{first, second, third}
}

```



錯誤的地方在於，有時候最長的三個邊沒辦法組成三角形，但是往下找卻可以，例如`[3 6 2 3]`。

解決辦法的話，就是當沒辦法組成三角形時，捨棄最常邊，然後補上剩下的邊中最長者。因為不確定要補多少次，所以先進行排序。



寫完如下

```go
func largestPerimeter(nums []int) int {
    nums = reverseMergeSort(nums)
	for i := 0; i <= len(nums)-3; i++ {
		if nums[i] < nums[i+1]+nums[i+2] {
			return nums[i] + nums[i+1] + nums[i+2]
		}
	}
	return 0
}

const min = -1

func reverseMergeSort(nums []int) []int {
	if len(nums) == 1 {
		return nums
	}
	middle := len(nums) / 2
	return merge(reverseMergeSort(clone(nums[:middle])), reverseMergeSort(clone(nums[middle:])))
}

func clone(src []int) []int {
	res := make([]int, len(src))
	copy(res, src)
	return res
}

func merge(part1, part2 []int) []int {
	res := make([]int, len(part1)+len(part2))
	if len(part2) > len(part1) {
		part1 = append(part1, min)
	}
	part1 = append(part1, min)
	part2 = append(part2, min)

	var part1Index, part2Index int
	for i := range res {
		if part1[part1Index] >= part2[part2Index] {
			res[i] = part1[part1Index]
			part1Index++
			continue
		}
		res[i] = part2[part2Index]
		part2Index++
	}

	return res
}
```

通過了，但是結果差強人意

![](https://i.imgur.com/iPHJkdT.png)

merge sort 空間使用量大不意外，但是速度上的表現就真的是不如預期了。



## Better Solutions

### Solution1

```cpp
int largestPerimeter(vector<int>& A) {
  sort(begin(A), end(A));
  for (auto i = A.size() - 1; i >= 2; --i)
    if (A[i] < A[i - 1] + A[i - 2]) 
        return A[i] + A[i - 1] + A[i - 2];
  return 0;
}
```

基本上和我的解法一樣，不過排序使用正常的升冪排序。看完才想到我幹嘛特地把排序反著寫= =



### Solution2

```java
class Solution {
    public int largestPerimeter(int[] nums) {
     Arrays.sort(nums);
      for(int i = nums.length - 1; i > 1; i --) 
        if(nums[i] < nums[i - 1] + nums[i - 2]) 
          return nums[i] + nums[i - 1] + nums[i - 2];
      
      return 0;
    }
}
```

還是一樣的解法，不過這個人自稱它的速度贏過99%以上的解答，難道我自己實作排序沒寫好反而拖慢了速度嗎?
