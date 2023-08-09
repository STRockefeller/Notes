# LeetCode:474:20230519:dart

tags: #problem_solve #dynamic_programming #knapsack_problem

[Reference](https://leetcode.com/problems/ones-and-zeroes/)

## Question

You are given an array of binary strings `strs` and two integers `m` and `n`.

Return _the size of the largest subset of `strs` such that there are **at most**_ `m` `0`_'s and_ `n` `1`_'s in the subset_.

A set `x` is a **subset** of a set `y` if all elements of `x` are also elements of `y`.

**Example 1:**

```
**Input:** strs = ["10","0001","111001","1","0"], m = 5, n = 3
**Output:** 4
**Explanation:** The largest subset with at most 5 0's and 3 1's is {"10", "0001", "1", "0"}, so the answer is 4.
Other valid but smaller subsets include {"0001", "1"} and {"10", "1", "0"}.
{"111001"} is an invalid subset because it contains 4 1's, greater than the maximum of 3.
```

**Example 2:**

```
**Input:** strs = ["10","0","1"], m = 1, n = 1
**Output:** 2
**Explanation:** The largest subset is {"0", "1"}, so the answer is 2.
```

**Constraints:**

- `1 <= strs.length <= 600`
- `1 <= strs[i].length <= 100`
- `strs[i]` consists only of digits `'0'` and `'1'`.
- `1 <= m, n <= 100`

## My Solution

有點像是背包問題([[Knapsack Problem]])，可以看成每一個item 取 或 不取 的選擇。 接著把剩餘的容量 (m and n) 以及剩餘的 items(strs) 接著做同樣的處理，經典的 dynamic programming 解法。

```dart
import 'dart:math';

class Solution {
  int findMaxForm(List<String> strs, int m, int n) {
    if (strs.isEmpty) return 0;

    String firstOne = strs.removeAt(0);
    TupleInteger ti = _countDigits(firstOne);
    int m2 = m - ti.zeroes;
    int n2 = n - ti.ones;
    return m2 >= 0 && n2 >= 0
        ? max(findMaxForm(strs, m2, n2) + 1, findMaxForm(strs, m, n))
        : findMaxForm(strs, m, n);
  }

  TupleInteger _countDigits(String str) {
    int ones = 0;
    int zeroes = 0;
    for (int char in str.runes) char == 48 ? zeroes++ : ones++;
    return TupleInteger(zeroes, ones);
  }
}

class TupleInteger {
  int ones = 0;
  int zeroes = 0;
  TupleInteger(this.zeroes, this.ones);
}
```

結果第二個基本Case就沒過了，`["10","0","1"] m=1 n=1`, `expected: 2, actual: 1`
稍微試了一下 `sol.findMaxForm(["0", "1"], 1, 1)` 的輸出確實是 `2`，所以問題出在`max`的環節判斷有誤。
做了下修正把三元去掉改成在最初的步驟篩掉不要的情況。

```dart
import 'dart:math';

class Solution {
  int findMaxForm(List<String> strs, int m, int n) {
    if (strs.isEmpty) return 0;
    if (m < 0 || n < 0) return -9999;

    String firstOne = strs.removeAt(0);
    TupleInteger ti = _countDigits(firstOne);
    int m2 = m - ti.zeroes;
    int n2 = n - ti.ones;
    return max(findMaxForm(strs, m2, n2) + 1, findMaxForm(strs, m, n));
  }

  TupleInteger _countDigits(String str) {
    int ones = 0;
    int zeroes = 0;
    for (int char in str.runes) char == 48 ? zeroes++ : ones++;
    return TupleInteger(zeroes, ones);
  }
}

class TupleInteger {
  int ones = 0;
  int zeroes = 0;
  TupleInteger(this.zeroes, this.ones);
}
```

這次死在這個case `["10","0001","111001","1","0"] m=4 n=3`, `expected: 3, actual: 4`
問題出在 `m` 以及 `n` 的判斷應該放在 `isEmpty` 之前，這樣才不會在不符合條件的情況下 `return 0`。

```dart
import 'dart:math';

class Solution {
  int findMaxForm(List<String> strs, int m, int n) {
    if (m < 0 || n < 0 ) return -9999;
    if (strs.isEmpty) return 0;
    List<String> clone = new List<String>.from(strs);
    String firstOne = clone.removeAt(0);
    TupleInteger ti = _countDigits(firstOne);
    int m2 = m - ti.zeroes;
    int n2 = n - ti.ones;
    return max(findMaxForm(clone, m2, n2) + 1, findMaxForm(clone, m, n));
  }

  TupleInteger _countDigits(String str) {
    int ones = 0;
    int zeroes = 0;
    for (int char in str.runes) char == 48 ? zeroes++ : ones++;
    return TupleInteger(zeroes, ones);
  }
}

class TupleInteger {
  int ones = 0;
  int zeroes = 0;
  TupleInteger(this.zeroes, this.ones);
}
```

修正之後變成 timeout。 再來想想要怎麼提升效率。
雖然明顯在這題中很難出現重複的情況，不過暫時沒有其他想法，還是不抱希望的來試試看加上個map紀錄已經處理過的案例

```dart
import 'dart:math';

class Solution {
  Map<MapKey, int> dpMap = new Map<MapKey, int>();

  int findMaxForm(List<String> strs, int m, int n) {
    if (m < 0 || n < 0) return -9999;
    if (strs.isEmpty) return 0;
    MapKey mapKey = MapKey(strs, m, n);
    if (dpMap.containsKey(mapKey)) return dpMap[mapKey] ?? 0;
    List<String> clone = new List<String>.from(strs);
    String firstOne = clone.removeAt(0);
    TupleInteger ti = _countDigits(firstOne);
    int m2 = m - ti.zeroes;
    int n2 = n - ti.ones;
    int res = max(findMaxForm(clone, m2, n2) + 1, findMaxForm(clone, m, n));
    dpMap[mapKey] = res;
    return res;
  }

  TupleInteger _countDigits(String str) {
    int ones = 0;
    int zeroes = 0;
    for (int char in str.runes) char == 48 ? zeroes++ : ones++;
    return TupleInteger(zeroes, ones);
  }
}

class TupleInteger {
  int ones = 0;
  int zeroes = 0;
  TupleInteger(this.zeroes, this.ones);
}

class MapKey {
  final List<String> strArr;
  final int m;
  final int n;
  MapKey(this.strArr, this.m, this.n);
}
```

結果依然是timeout, 也不意外就是了。

---

先不管之前的作法，再從頭開始分析這個題目:

1. length == 1 的字串盡可能選取，即便是極端情況，例如 `[1, 10, 100]` `m=10000, n=1` 的情況下，`1` 依然和 `10` `100` 有同等價值。
2. length >=2 之後目前看來無法做類似的判斷。
3. 承 1 與 2 ， 可以在最初把題目分為 length == 1 的部分 和 除此之外的部分，分別進行處理。
4. 先依長度進行排序或許是個好主意 (不肯定)
5. 中途篩掉肯定無法使用的項目或許是個好主意 (不肯定) ， 例如當 `m=3` 時，把陣列中 `0` 多餘 3 個的項目先去除掉。

先把比較有把握的部分寫下去

```dart
import 'dart:math';

class Solution {
  int findMaxForm(List<String> strs, int m, int n) {
    /* ------------------- where the length of the string is 1 ------------------ */
    int zeroesCount = strs.where((str) => str == "0").length;
    int onesCount = strs.where((str) => str == "1").length;
    int part1Value = min(m, zeroesCount) + min(n, onesCount);
    m = m > zeroesCount ? m - zeroesCount : 0;
    n = n > onesCount ? n - onesCount : 0;
    /* -------------------------------- rest part ------------------------------- */
    List<String> restPart = strs.where((str) => str.length > 1).toList();
    int part2Value = _findMaxForm(restPart, m, n);
    return part1Value + part2Value;
  }

  int _findMaxForm(List<String> strs, int m, int n) {
    if (m < 0 || n < 0) return -9999;
    if (strs.isEmpty || (m == 0 && n == 0)) return 0;
    List<String> clone = new List<String>.from(strs);
    String firstOne = clone.removeAt(0);
    TupleInteger ti = _countDigits(firstOne);
    int m2 = m - ti.zeroes;
    int n2 = n - ti.ones;
    return max(_findMaxForm(clone, m2, n2) + 1, _findMaxForm(clone, m, n));
  }

  TupleInteger _countDigits(String str) {
    int ones = 0;
    int zeroes = 0;
    for (int char in str.runes) char == 48 ? zeroes++ : ones++;
    return TupleInteger(zeroes, ones);
  }
}

class TupleInteger {
  int ones = 0;
  int zeroes = 0;
  TupleInteger(this.zeroes, this.ones);
}
```

這個版本確實比起之前快得多，但是依然是timeout，測試案例中有個長度超過600並且每個項目都不是一個字元的case。
總之，僅針對 length == 1 做處理是不夠的。

試試看先處理資料會不會比較快:

1. 把list內容改為包含zeroes,ones的結構
2. 依照zeroes+ones升冪排序
3. 移除不符合條件的項目

先做了除了排序的部分，因為排序之後要怎麼利用還沒想到。

```dart
import 'dart:math';

class Solution {
  int findMaxForm(List<String> strs, int m, int n) {
    int zeroesCount = 0;
    int onesCount = 0;
    List<TupleInteger> restPart = [];
    for (String str in strs) {
      if (str == "0") {
        zeroesCount++;
      } else if (str == "1") {
        onesCount++;
      } else {
        restPart.add(_countDigits(str));
      }
    }
    int part1Value = min(m, zeroesCount) + min(n, onesCount);
    m = m > zeroesCount ? m - zeroesCount : 0;
    n = n > onesCount ? n - onesCount : 0;
    int part2Value = _findMaxForm(restPart, m, n);
    return part1Value + part2Value;
  }

  int _findMaxForm(List<TupleInteger> strs, int m, int n) {
    if (strs.isEmpty || (m == 0 && n == 0)) return 0;
    List<TupleInteger> clone = strs
        .where((element) => element.zeroes <= m && element.ones <= n)
        .toList();
    if (clone.isEmpty) return 0;
    TupleInteger firstOne = clone.removeAt(0);
    int m2 = m - firstOne.zeroes;
    int n2 = n - firstOne.ones;
    return max(_findMaxForm(clone, m2, n2) + 1, _findMaxForm(clone, m, n));
  }

  TupleInteger _countDigits(String str) {
    int ones = 0;
    int zeroes = 0;
    for (int char in str.runes) char == 48 ? zeroes++ : ones++;
    return TupleInteger(zeroes, ones);
  }
}

class TupleInteger {
  int ones = 0;
  int zeroes = 0;
  TupleInteger(this.zeroes, this.ones);
}
```

老樣子，雖然變快了，但依然不夠。

---

再次修正了下DP

```dart
import 'dart:math';

class Solution {
  int findMaxForm(List<String> strs, int m, int n) {
    int zeroesCount = 0;
    int onesCount = 0;
    List<TupleInteger> restPart = [];
    for (String str in strs) {
      if (str == "0") {
        zeroesCount++;
      } else if (str == "1") {
        onesCount++;
      } else {
        restPart.add(_countDigits(str));
      }
    }
    int part1Value = min(m, zeroesCount) + min(n, onesCount);
    m = m > zeroesCount ? m - zeroesCount : 0;
    n = n > onesCount ? n - onesCount : 0;
    int part2Value = _findMaxForm(restPart, m, n);
    return part1Value + part2Value;
  }

  int _findMaxForm(List<TupleInteger> strs, int m, int n) {
    List<List<int>> dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));
    for (TupleInteger str in strs) {
      for (int i = m; i >= str.zeroes; i--) {
        for (int j = n; j >= str.ones; j--) {
          dp[i][j] = max(dp[i][j], dp[i - str.zeroes][j - str.ones] + 1);
        }
      }
    }
    return dp[m][n];
  }

  TupleInteger _countDigits(String str) {
    int ones = 0;
    int zeroes = 0;
    for (int char in str.runes) char == 48 ? zeroes++ : ones++;
    return TupleInteger(zeroes, ones);
  }
}

class TupleInteger {
  int ones = 0;
  int zeroes = 0;
  TupleInteger(this.zeroes, this.ones);
}
```

這次通過了

![result](https://i.imgur.com/0tFGYXl.png)

還以為 beats 100% 我超猛，結果是冷門語言根本沒人寫...

## Better Solutions

### Solution1

```cpp
class Solution {
    int dfs(int i, int s, int m, int n, vector<string> &strs, vector<vector<vector<int>>> &dp) {
        if(i == s) return 0;
        if(dp[i][m][n] != -1) return dp[i][m][n];

        int notpick = dfs(i + 1, s, m, n, strs, dp);
        int cnt0 = 0, cnt1 = 0, pick = 0;
        for(char c : strs[i]) {
            c == '0' ? cnt0++ : cnt1++;
        }
        if(m >= cnt0 && n >= cnt1) {
            pick = 1 + dfs(i + 1, s, m - cnt0, n - cnt1, strs, dp);
        }
        return dp[i][m][n] = max(pick, notpick);
    }
public:
    int findMaxForm(vector<string>& strs, int m, int n) {
        int s = strs.size();
        vector<vector<vector<int>>> dp(s, vector<vector<int>>(m + 1, vector<int>(n + 1, -1)));
        return dfs(0, s, m, n, strs, dp);
    }
};
```

### Solution2

```cpp
class Solution {
public:
    int findMaxForm(vector<string>& strs, int m, int n) {
        int s = strs.size();
        vector<vector<vector<int>>> dp(s + 1, vector<vector<int>>(m + 1, vector<int>(n + 1)));

        for(int i=s-1; i>=0; i--) {
            for(int j=0; j<=m; j++) {
                for(int k=0; k<=n; k++) {
                    int notpick = dp[i + 1][j][k];
                    int cnt0 = 0, cnt1 = 0, pick = 0;
                    for(char c : strs[i]) {
                        c == '0' ? cnt0++ : cnt1++;
                    }
                    if(j >= cnt0 && k >= cnt1) {
                        pick = 1 + dp[i + 1][j - cnt0][k - cnt1];
                    }
                    dp[i][j][k] = max(pick, notpick);
                }
            }
        }
        return dp[0][m][n];
    }
};
```

### Solution3

```cpp
int findMaxForm(vector<string>& strs, int m, int n) {
	// dp[i][j] will store Max subset size possible with zeros_limit = i, ones_limit = j
	vector<vector<int> > dp(m + 1, vector<int>(n + 1));
	for(auto& str : strs) {
		// count zeros & ones frequency in current string
		int zeros = count(begin(str), end(str), '0'), ones = size(str) - zeros;
		// which positions of dp will be updated ?
		// Only those having atleast `zeros` 0s(i >= zeros) and `ones` 1s(j >= ones)
		for(int i = m; i >= zeros; i--)
			for(int j = n; j >= ones; j--)
				dp[i][j] = max(dp[i][j], // either leave the current string
							   dp[i - zeros][j - ones] + 1); // or take it by adding 1 to optimal solution of remaining balance
		// at this point each dp[i][j] will store optimal value for items considered till now & having constraints i and j respectively
	}
	return dp[m][n];
}
```
