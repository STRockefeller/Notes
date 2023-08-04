# LeetCode:77:20230801:dart

tags: #problem_solve #leetcode/medium #dart #dynamic_programming

[Reference](https://leetcode.com/problems/combinations/description/)

## Question

Given two integers `n` and `k`, return _all possible combinations of_ `k` _numbers chosen from the range_ `[1, n]`.

You may return the answer in **any order**.

**Example 1:**

**Input:** n = 4, k = 2
**Output:** [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
**Explanation:** There are 4 choose 2 = 6 total combinations.
Note that combinations are unordered, i.e., [1,2] and [2,1] are considered to be the same combination.

**Example 2:**

**Input:** n = 1, k = 1
**Output:** [[1]]
**Explanation:** There is 1 choose 1 = 1 total combination.

**Constraints:**

- `1 <= n <= 20`
- `1 <= k <= n`

## My Solution

Approach: dp

```dart
class Solution {
  // dp[arrSize][from][to] is a List<List<int>>
  List<List<List<List<List<int>>>>> dp = List.generate(
    21,
    (i) => List.generate(
      21,
      (j) => List.generate(21, (k) => <List<int>>[]),
    ),
  );

  List<List<int>> combine(int n, int k) {
    return _combineRange(1, n, k);
  }

  List<List<int>> _combineRange(int from, int to, int arrSize) {
    if (dp[arrSize][from][to].isNotEmpty) {
      return dp[arrSize][from][to];
    }
    List<List<int>> res = [];
    if (arrSize == 1) {
      for (int i = from; i <= to; i++) {
        res.add([i]);
      }

      dp[arrSize][from][to] = res;
      return res;
    }

    for (int i = from; i <= to - arrSize + 1; i++) {
      res.addAll(_combineRange(i + 1, to, arrSize - 1).map((arr) {
        List<int> newArr = [i];
        newArr.addAll(arr);
        return newArr;
      }));
    }

    dp[arrSize][from][to] = res;
    return res;
  }
}
```

result

![image](https://i.imgur.com/ZnlShxI.png)

## Better Solutions

### Solution 1

```c#
public class Solution {
    public IList<IList<int>> Combine(int n, int k) {
        var result = new List<IList<int>>();
        GenerateCombinations(1, n, k, new List<int>(), result);
        return result;
    }

    private void GenerateCombinations(int start, int n, int k, List<int> combination, IList<IList<int>> result) {
        if (k == 0) {
            result.Add(new List<int>(combination));
            return;
        }
        for (var i = start; i <= n; ++i) {
            combination.Add(i);
            GenerateCombinations(i + 1, n, k - 1, combination, result);
            combination.RemoveAt(combination.Count - 1);
        }
    }
}
```
