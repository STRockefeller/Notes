# LeetCode:202:20220913:Dart

[Reference](https://leetcode.com/problems/happy-number/)

## Question

Write an algorithm to determine if a number `n` is happy.

A **happy number** is a number defined by the following process:

- Starting with any positive integer, replace the number by the sum of the squares of its digits.
- Repeat the process until the number equals 1 (where it will stay), or it **loops endlessly in a cycle** which does not include 1.
- Those numbers for which this process **ends in 1** are happy.

Return `true` *if* `n` *is a happy number, and* `false` *if not*.

**Example 1:**

**Input:** n = 19
**Output:** true
**Explanation:**
12 + 92 = 82
82 + 22 = 68
62 + 82 = 100
12 + 02 + 02 = 1

**Example 2:**

**Input:** n = 2
**Output:** false

**Constraints:**

- `1 <= n <= 2^31 - 1`

## My Solution

錯了一次，timeout 解法如下

```dart
import 'dart:collection';

class Solution {
  HashSet<int> duplicatedNums = new HashSet<int>();
  bool isHappy(int n) {
    if (n == 1) return true;
    if (duplicatedNums.contains(n)) return false;
    duplicatedNums.add(n);
    int sum = 0;
    while (n > 1) {
      final d = n % 10;
      sum += d * d;
      n ~/= 10;
    }
    sum += n * n;
    return isHappy(sum);
  }
}
```



後來去看了下wiki，得知unhappy numbers 有個循環

![](https://i.imgur.com/F4Os0Qq.png)

於是就把他寫死在程式碼裡面，就通過了

```dart
import 'dart:collection';

class Solution {
  HashSet<int> duplicatedNums = new HashSet<int>();
  Solution(){
    duplicatedNums.addAll([4,16,37,58,89,145,42,20]);
  }
  bool isHappy(int n) {
    print(n);
    if (n == 1) return true;
    if (duplicatedNums.contains(n)) return false;
    int sum = 0;
    while (n > 1) {
      final d = n % 10;
      sum += d * d;
      n ~/= 10;
    }
    sum += n * n;
    return isHappy(sum);
  }
}
```

## Better Solutions

### Solution1

```c
int digitSquareSum(int n) {
    int sum = 0, tmp;
    while (n) {
        tmp = n % 10;
        sum += tmp * tmp;
        n /= 10;
    }
    return sum;
}

bool isHappy(int n) {
    int slow, fast;
    slow = fast = n;
    do {
        slow = digitSquareSum(slow);
        fast = digitSquareSum(fast);
        fast = digitSquareSum(fast);
    } while(slow != fast);
    if (slow == 1) return 1;
    else return 0;
}
```

很酷的解法，他甚至沒有用到hashset，不過也很難一眼看出，為什麼這麼做是可行的。

來試著分析一下。

把它搬到play ground 後，print一些細節出來如下

```c
#include<stdio.h>
#include<stdlib.h>

int digitSquareSum(int n) {
    int sum = 0, tmp;
    while (n) {
        tmp = n % 10;
        sum += tmp * tmp;
        n /= 10;
    }
    return sum;
}

bool isHappy(int n) {
    int slow, fast;
    slow = fast = n;
    do {
        slow = digitSquareSum(slow);
        fast = digitSquareSum(fast);
        fast = digitSquareSum(fast);
        printf("slow: %d\r\n",slow);
        printf("fast: %d\r\n",fast);
    } while(slow != fast);
    if (slow == 1) return 1;
    else return 0;
}

int main(void) {
    printf(isHappy(119)?"true":"false");
    return 0;
}
```

```bash
Finished in 0 ms
slow: 83
fast: 73
slow: 73
fast: 89
slow: 58
fast: 42
slow: 89
fast: 4
slow: 145
fast: 37
slow: 42
fast: 89
slow: 20
fast: 42
slow: 4
fast: 4
false
```

答案是true的case如下(input : 19)

```bash
Finished in 3 ms
slow: 82
fast: 68
slow: 68
fast: 1
slow: 100
fast: 1
slow: 1
fast: 1
true
```

看起來像是個變種的快慢指針

成功的case比較不重要，把失敗的case拿來分析看看

```tex
slow:   ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4
fast:   ⬆
```



```tex
slow:         ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4
fast:              ⬆
```



```tex
slow:              ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4
fast:                        ⬆
```



```tex
slow:                   ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4
fast:                                    ⬆
```



```tex
slow:                        ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4
fast:                                             ⬆
```



```tex
slow:                             ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4 - 16 - 37
fast:                                                      ⬆
```



```tex
slow:                                   ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4 - 16 - 37
fast:                        ⬆
```



```tex
slow:                                        ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4 - 16 - 37
fast:                                   ⬆
```



```tex
slow:                                             ⬇
number: 119 - 83 - 73 - 58 - 89 - 145 - 42 - 20 - 4 - 16 - 37
fast:                                             ⬆
```

簡單來說 根據 `Floyd Cycle Detection Algorithm` ，只要我的數列中有迴圈存在，那麼快慢指針一定會在迴圈的某處重疊。



最後我想來驗證看看這個寫法究竟快不快

我用dart寫一遍，方便跟我之前的成績做比較。



![image](https://i.imgur.com/3RswRWv.png)



時間和空間都勝過我先前的遞迴解法。
