# LeetCode::20230823:dart

tags: #problem_solve #leetcode/medium #dart #heap #priority_queue #quick_sort
[Reference](https://leetcode.com/problems/reorganize-string/)

## Question

Given a string `s`, rearrange the characters of `s` so that any two adjacent characters are not the same.

Return _any possible rearrangement of_ `s` _or return_ `""` _if not possible_.

**Example 1:**

**Input:** s = "aab"
**Output:** "aba"

**Example 2:**

**Input:** s = "aaab"
**Output:** ""

**Constraints:**

- `1 <= s.length <= 500`
- `s` consists of lowercase English letters.

## My Solution

Approach:

- Focus on characters with the largest and second largest number in `s`
- If the characters with the largest number is more than `s.length / 2`, it is impossible to have rearrange the given string.

this method can be implement by the following ways:

- priority queue (max heap), but if I want to get the second item I should take the first one first and insert it into the queue after operating.
- sort the string first, and do bubble down after each operation.

### implement by sorting first

```dart
class Solution {
  String reorganizeString(String s) {
    List<int> charAmount = List.generate(26, (index) => 0);
    s.codeUnits.map((asciiDecimal) => asciiDecimal - 97).forEach((index) {
      charAmount[index]++;
    });
    List<int> charOrder = List.generate(26, (index) => index);
    _quickSort(charOrder, charAmount, 0, 25);
    if (charAmount[charOrder[0]] > (s.length / 2).round()) {
      return "";
    }

    String result = "";
    int previous = -1;
    while (result.length < s.length) {
      if (charOrder[0] != previous) {
        previous = charOrder[0];
        result += String.fromCharCode(previous + 97);
        charAmount[previous]--;
        _bubbleDown(charOrder, charAmount, 0);
        continue;
      }
      previous = charOrder[1];
      result += String.fromCharCode(previous + 97);
      charAmount[previous]--;
      _bubbleDown(charOrder, charAmount, 1);
    }

    return result;
  }

  void _quickSort(List<int> order, List<int> amount, int low, int high) {
    if (low < high) {
      int pivot = amount[order[high]];
      int i = low;
      for (int j = low; j < high; j++) {
        if (amount[order[j]] >= pivot) {
          int temp = order[i];
          order[i] = order[j];
          order[j] = temp;
          i++;
        }
      }

      int temp = order[i];
      order[i] = order[high];
      order[high] = temp;

      _quickSort(order, amount, low, i - 1);
      _quickSort(order, amount, i + 1, high);
    }
  }

  void _bubbleDown(List<int> order, List<int> amount, int index) {
    Function(int, int) swap = (i, j) {
      int temp = order[i];
      order[i] = order[j];
      order[j] = temp;
    };

    int target = amount[order[index]];
    for (int i = index + 1; i < 26 && amount[order[i]] > target; i++) {
      swap(i, i - 1);
    }
  }
}
```

improve: use `StringBuffer` instead of `String`

```dart
class Solution {
  String reorganizeString(String s) {
    List<int> charAmount = List.generate(26, (index) => 0);
    s.codeUnits.map((asciiDecimal) => asciiDecimal - 97).forEach((index) {
      charAmount[index]++;
    });
    List<int> charOrder = List.generate(26, (index) => index);
    _quickSort(charOrder, charAmount, 0, 25);
    if (charAmount[charOrder[0]] > (s.length / 2).round()) {
      return "";
    }

    StringBuffer buffer = StringBuffer();
    int previous = -1;
    while (buffer.length < s.length) {
      if (charOrder[0] != previous) {
        previous = charOrder[0];
        buffer.writeCharCode(previous + 97);
        charAmount[previous]--;
        _bubbleDown(charOrder, charAmount, 0);
        continue;
      }
      previous = charOrder[1];
      buffer.writeCharCode(previous + 97);
      charAmount[previous]--;
      _bubbleDown(charOrder, charAmount, 1);
    }

    return buffer.toString();
  }

  void _quickSort(List<int> order, List<int> amount, int low, int high) {
    if (low < high) {
      int pivot = amount[order[high]];
      int i = low;
      for (int j = low; j < high; j++) {
        if (amount[order[j]] >= pivot) {
          int temp = order[i];
          order[i] = order[j];
          order[j] = temp;
          i++;
        }
      }

      int temp = order[i];
      order[i] = order[high];
      order[high] = temp;

      _quickSort(order, amount, low, i - 1);
      _quickSort(order, amount, i + 1, high);
    }
  }

  void _bubbleDown(List<int> order, List<int> amount, int index) {
    Function(int, int) swap = (i, j) {
      int temp = order[i];
      order[i] = order[j];
      order[j] = temp;
    };

    int target = amount[order[index]];
    for (int i = index + 1; i < 26 && amount[order[i]] > target; i++) {
      swap(i, i - 1);
    }
  }
}
```

Result

![image](https://i.imgur.com/lsFr9NC.png)

analysis:

time complexity:

1. initialize `charAmount` : O(n)
2. quick sort: O(n log n)
3. build the result string: O(n)

overall: O(n log n)

space complexity:

1. initialize `charAmount` and `charOrder` : O(1)
2. string buffer: O(n)
3. quick sort: O(log n)

overall: O(n)

## Better Solutions
