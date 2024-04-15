# LeetCode:518:20230811:dart

tags: #problem_solve #leetcode/medium #dynamic_programming #knapsack_problem #dart

[Reference](https://leetcode.com/problems/coin-change-ii/)

## Question

You are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money.

Return _the number of combinations that make up that amount_. If that amount of money cannot be made up by any combination of the coins, return `0`.

You may assume that you have an infinite number of each kind of coin.

The answer is **guaranteed** to fit into a signed **32-bit** integer.

**Example 1:**

**Input:** amount = 5, coins = [1,2,5]
**Output:** 4
**Explanation:** there are four ways to make up the amount:
5=5
5=2+2+1
5=2+1+1+1
5=1+1+1+1+1

**Example 2:**

**Input:** amount = 3, coins = [2]
**Output:** 0
**Explanation:** the amount of 3 cannot be made up just with coins of 2.

**Example 3:**

**Input:** amount = 10, coins = [10]
**Output:** 1

**Constraints:**

- `1 <= coins.length <= 300`
- `1 <= coins[i] <= 5000`
- All the values of `coins` are **unique**.
- `0 <= amount <= 5000`

## My Solution

```dart
import 'dart:math';

class Solution {
  int change(int amount, List<int> coins) {
    if (amount == 0) {
      return 1;
    }
    // index => amount, value => combinations
    List<int> dp = List.generate(amount + 1, (index) => -1);
    dp[0] = 1;
    coins.sort((a, b) => b.compareTo(a));
    return _changeWithDP(
        amount, coins.where((element) => element <= amount).toList(), dp);
  }

  int _changeWithDP(int amount, List<int> coins, List<int> dp) {
    if (dp[amount] != -1) {
      return dp[amount];
    }
    if (coins.length == 0) {
      dp[amount] == 0;
      return 0;
    }
    if (coins.length == 1) {
      int res = amount % coins[0] == 0 ? 1 : 0;
      dp[amount] = res;
      return res;
    }
    int coin = coins.first;
    int combinations = 0;
    for (int cost = 0; cost <= amount; cost += coin) {
      combinations += _changeWithDP(amount - cost, coins.skip(1).toList(), dp);
    }

    dp[amount] = combinations;
    return combinations;
  }
}
```

wrong answer

![image](https://i.imgur.com/UNtIF2J.png)

### Quick Select

do it again with quick select

```dart
class Solution {
  int findKthLargest(List<int> nums, int k) {
    return _quickSelect(nums, 0, nums.length - 1, k);
  }

  int _partition(List<int> arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (arr[j] >= pivot) {
        i++;
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }

    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    return i + 1;
  }

  int _quickSelect(List<int> arr, int low, int high, int k) {
    if (low <= high) {
      int partitionIndex = _partition(arr, low, high);

      if (partitionIndex == k - 1) {
        return arr[partitionIndex];
      } else if (partitionIndex < k - 1) {
        return _quickSelect(arr, partitionIndex + 1, high, k);
      } else {
        return _quickSelect(arr, low, partitionIndex - 1, k);
      }
    }

    return -1; // Error or not found
  }
}
```

result:

![image](https://i.imgur.com/JudooZp.png)

compare with previous one

![image](https://i.imgur.com/bklzTZM.png)

## Better Solutions
