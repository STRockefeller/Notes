# LeetCode:1615:20230818:go

tags: #problem_solve #leetcode/medium #golang #graph

[Reference](https://leetcode.com/problems/maximal-network-rank/)

## Question

There is an infrastructure of `n` cities with some number of `roads` connecting these cities. Each `roads[i] = [ai, bi]` indicates that there is a bidirectional road between cities `ai` and `bi`.

The **network rank** of **two different cities** is defined as the total number of **directly** connected roads to **either** city. If a road is directly connected to both cities, it is only counted **once**.

The **maximal network rank** of the infrastructure is the **maximum network rank** of all pairs of different cities.

Given the integer `n` and the array `roads`, return _the **maximal network rank** of the entire infrastructure_.

**Example 1:**

![](https://assets.leetcode.com/uploads/2020/09/21/ex1.png)

```text
**Input:** n = 4, roads = [[0,1],[0,3],[1,2],[1,3]]
**Output:** 4
**Explanation:** The network rank of cities 0 and 1 is 4 as there are 4 roads that are connected to either 0 or 1. The road between 0 and 1 is only counted once.
```

**Example 2:**

![](https://assets.leetcode.com/uploads/2020/09/21/ex2.png)

```text
**Input:** n = 5, roads = [[0,1],[0,3],[1,2],[1,3],[2,3],[2,4]]
**Output:** 5
**Explanation:** There are 5 roads that are connected to cities 1 or 2.
```

**Example 3:**

```text
**Input:** n = 8, roads = [[0,1],[1,2],[2,3],[2,4],[5,6],[5,7]]
**Output:** 5
**Explanation:** The network rank of 2 and 5 is 5. Notice that all the cities do not have to be connected.
```

**Constraints:**

- `2 <= n <= 100`
- `0 <= roads.length <= n * (n - 1) / 2`
- `roads[i].length == 2`
- `0 <= ai, bi <= n-1`
- `ai != bi`
- Each pair of cities has **at most one** road connecting them.

## My Solution

Approach:

- for each city, save the number of roads.
- take the two cities which have the max number of roads and calculate the rank.
- if there are more cities that have the same number of roads such as [9,9,9,8,7], consider if they are connected directly.

```go
func maximalNetworkRank(n int, roads [][]int) int {
	cities := make([]int, n)
	connectedCities := make([][]bool, n)
	for i := range connectedCities {
		connectedCities[i] = make([]bool, n)
	}
	for _, road := range roads {
		cities[road[0]]++
		connectedCities[road[0]][road[1]] = true
		cities[road[1]]++
		connectedCities[road[1]][road[0]] = true
	}

	calculateRank := func(cityIndices [2]int) int {
		if connectedCities[cityIndices[0]][cityIndices[1]] {
			return cities[cityIndices[0]] + cities[cityIndices[1]] - 1
		}
		return cities[cityIndices[0]] + cities[cityIndices[1]]
	}

	if n == 2 {
		return calculateRank([2]int{0, 1})
	}

	indices := make([]int, len(cities))
	for i := range cities {
		indices[i] = i
	}

	sort.Slice(indices, func(i, j int) bool {
		return cities[indices[i]] > cities[indices[j]]
	})

	consideredCitiesNum := 2
	for i := 2; i < n && cities[indices[i]] == cities[indices[i-1]]; i++ {
		consideredCitiesNum++
	}

	consideredCities := indices[:consideredCitiesNum]
	for i := 0; i < consideredCitiesNum-1; i++ {
		for j := i + 1; j < consideredCitiesNum; j++ {
			if !connectedCities[consideredCities[i]][consideredCities[j]] {
				return cities[consideredCities[i]] + cities[consideredCities[j]]
			}
		}
		if i == 0 && consideredCities[0] > consideredCities[1] {
			break
		}
	}
	return cities[consideredCities[0]] + cities[consideredCities[1]] - 1
}
```

Complexity:

- time: O(n log n) (sorting indices)
- space: O(n^2) (connectedCities)

result: wrong answer

![image](https://i.imgur.com/M6qT51h.png)

test with the following case

![image](./../images/LeetCode_Medium_Maximal%20Network%20Rank-0.svg)

```go
n := 10
roads := [][]int{{0,1},{1,2},{1,3},{3,4},{3,5},{6,8},{7,8},{8,9}}
```

I got the correct answer(6) in this case. umm..what's wrong with it?

## Better Solutions
