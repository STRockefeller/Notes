# LeetCode:1326:20230831:go

tags: #problem_solve #leetcode/hard #golang #greedy_algorithm #dynamic_programming

[Reference](https://leetcode.com/problems/minimum-number-of-taps-to-open-to-water-a-garden/)

## Question

There is a one-dimensional garden on the x-axis. The garden starts at the point `0` and ends at the point `n`. (i.e The length of the garden is `n`).

There are `n + 1` taps located at points `[0, 1, ..., n]` in the garden.

Given an integer `n` and an integer array `ranges` of length `n + 1` where `ranges[i]` (0-indexed) means the `i-th` tap can water the area `[i - ranges[i], i + ranges[i]]` if it was open.

Return _the minimum number of taps_ that should be open to water the whole garden, If the garden cannot be watered return **-1**.

**Example 1:**

![image](https://assets.leetcode.com/uploads/2020/01/16/1685_example_1.png)

**Input:** n = 5, ranges = `[3,4,1,1,0,0]`
**Output:** 1
**Explanation:** The tap at point 0 can cover the interval `[-3,3]`
The tap at point 1 can cover the interval `[-3,5]`
The tap at point 2 can cover the interval `[1,3]`
The tap at point 3 can cover the interval `[2,4]`
The tap at point 4 can cover the interval `[4,4]`
The tap at point 5 can cover the interval `[5,5]`
Opening Only the second tap will water the whole garden `[0,5]`

**Example 2:**

**Input:** n = 3, ranges = `[0,0,0,0]`
**Output:** -1
**Explanation:** Even if you activate all the four taps you cannot water the whole garden.

**Constraints:**

- `1 <= n <= 10^4`
- `ranges.length == n + 1`
- `0 <= ranges[i] <= 100`

## My Solution

Approach?:

- the input array can be simplified by removing the taps which has been covered by another one. e.g. [3,2,1] => [3,0,0]
- Assume that index i has value k, if the value of index i-n or index i+n has value <= k-n, then the value can be ignored and changed to 0.

implementation

```go
func simplifyArr(arr []int) {
	min := 0
	maybeIgnore := func(i int) {
		if arr[i] <= min {
			arr[i] = 0
			min--
			return
		}
		min = arr[i] - 1
	}
	for i := 0; i < len(arr); i++ {
		maybeIgnore(i)
	}

	min = 0
	for i := len(arr) - 1; i >= 0; i-- {
		maybeIgnore(i)
	}
}
```

- Open all remain taps, and calculate the watering coverage.
- Check if the whole garden is covered or return -1
- Try to close the redundant taps (I am not sure how to do this)

```go
func minTaps(n int, ranges []int) int {
	simplifyArr(ranges)
	taps := getTaps(ranges)
	areaCoverage := make([]int, n) // if areaCoverage[0] = 2 it means that the area between 0 and 1 is covered by two taps

	for _, tap := range taps {
		for _, area := range tap.water() {
			areaCoverage[area]++
		}
	}

	for _, area := range areaCoverage {
		if area == 0 {
			return -1
		}
	}

	/* -------------------------------- not sure -------------------------------- */
	ans := len(taps)

	removeDuplicated := func(t tap) {
		for _, area := range t.water() {
			if areaCoverage[area] == 1 {
				return
			}
		}
		for _, area := range t.water() {
			areaCoverage[area]--
		}
		ans--
	}

	for _, tap := range taps {
		removeDuplicated(tap)
	}

	return ans
}

func getTaps(ranges []int) []tap {
	res := []tap{}
	for i, r := range ranges {
		if r != 0 {
			from := i - r
			to := i + r
			if from < 0 {
				from = 0
			}
			if to > len(ranges)-1 {
				to = len(ranges) - 1
			}
			res = append(res, tap{
				index: i,
				from:  from,
				to:    to,
			})
		}
	}
	return res
}

type tap struct {
	index int
	from  int
	to    int
}

func (t tap) water() []int {
	res := make([]int, t.to-t.from)
	i := 0
	for area := t.from; area < t.to; area++ {
		res[i] = area
		i++
	}
	return res
}

func simplifyArr(arr []int) {
	min := 0
	maybeIgnore := func(i int) {
		if arr[i] <= min {
			arr[i] = 0
			min--
			return
		}
		min = arr[i] - 1
	}
	for i := 0; i < len(arr); i++ {
		maybeIgnore(i)
	}

	min = 0
	for i := len(arr) - 1; i >= 0; i-- {
		maybeIgnore(i)
	}
}
```

result:

![image](https://i.imgur.com/VPnPhlQ.png)

It's surprising that this answer was accepted. (⊙_⊙;)

---

refactor: store the result of the method `water` to avoid duplicated calculation

```go
func minTaps(n int, ranges []int) int {
	simplifyArr(ranges)
	taps := getTaps(ranges)
	areaCoverage := make([]int, n) // if areaCoverage[0] = 2 it means that the area between 0 and 1 is covered by two taps

	for _, tap := range taps {
		for _, area := range tap.water() {
			areaCoverage[area]++
		}
	}

	for _, area := range areaCoverage {
		if area == 0 {
			return -1
		}
	}

	/* -------------------------------- not sure -------------------------------- */
	ans := len(taps)

	removeDuplicated := func(t tap) {
		for _, area := range t.water() {
			if areaCoverage[area] == 1 {
				return
			}
		}
		for _, area := range t.water() {
			areaCoverage[area]--
		}
		ans--
	}

	for _, tap := range taps {
		removeDuplicated(tap)
	}

	return ans
}

func getTaps(ranges []int) []tap {
	res := make([]tap, 0, len(ranges))
	for i, r := range ranges {
		if r != 0 {
			from := i - r
			to := i + r
			if from < 0 {
				from = 0
			}
			if to > len(ranges)-1 {
				to = len(ranges) - 1
			}
			res = append(res, tap{
				index: i,
				from:  from,
				to:    to,
			})
		}
	}
	return res
}

type tap struct {
	index        int
	from         int
	to           int
	wateredAreas []int
}

func (t tap) water() []int {
	if t.wateredAreas != nil {
		return t.wateredAreas
	}
	t.wateredAreas = make([]int, t.to-t.from)
	i := 0
	for area := t.from; area < t.to; area++ {
		t.wateredAreas[i] = area
		i++
	}
	return t.wateredAreas
}

func simplifyArr(arr []int) {
	min := 0
	maybeIgnore := func(i int) {
		if arr[i] <= min {
			arr[i] = 0
			min--
			return
		}
		min = arr[i] - 1
	}
	for i := 0; i < len(arr); i++ {
		maybeIgnore(i)
	}

	min = 0
	for i := len(arr) - 1; i >= 0; i-- {
		maybeIgnore(i)
	}
}
```

result:

![image](https://i.imgur.com/No3XlEx.png)

![image](https://i.imgur.com/Gna60ui.png)

## Better Solutions

### Solution 1 (Greedy)

[reference](https://leetcode.com/problems/minimum-number-of-taps-to-open-to-water-a-garden/solutions/3982461/99-5-greedy-with-dynamic-dp/)

```go
func minTaps(n int, ranges []int) int {
    arr := make([]int, n+1)

    for i, r := range ranges {
        if r == 0 {
            continue
        }
        left := max(0, i - r)
        arr[left] = max(arr[left], i + r)
    }

    end, far_can_reach, cnt := 0, 0, 0
    for i := 0; i <= n; i++ {
        if i > end {
            if far_can_reach <= end {
                return -1
            }
            end = far_can_reach
            cnt++
        }
        far_can_reach = max(far_can_reach, arr[i])
    }

    if end < n {
        cnt++
    }
    return cnt
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

### Solution 2 (DP)

[reference](https://leetcode.com/problems/minimum-number-of-taps-to-open-to-water-a-garden/solutions/3982461/99-5-greedy-with-dynamic-dp/)

```python
class Solution:
    def minTaps(self, n: int, ranges: List[int]) -> int:
        dp = [float('inf')] * (n + 1)
        dp[0] = 0

        for i, r in enumerate(ranges):
            start, end = max(0, i - r), min(n, i + r)
            for j in range(start + 1, end + 1):
                dp[j] = min(dp[j], dp[start] + 1)

        return dp[-1] if dp[-1] != float('inf') else -1
```
