# LeetCode:1647:20230912:dart

tags: #problem_solve #leetcode/medium #dart

[Reference](https://leetcode.com/problems/minimum-deletions-to-make-character-frequencies-unique/)

## Question

A string `s` is called **good** if there are no two different characters in `s` that have the same **frequency**.

Given a string `s`, return _the **minimum** number of characters you need to delete to make_ `s` _**good**._

The **frequency** of a character in a string is the number of times it appears in the string. For example, in the string `"aab"`, the **frequency** of `'a'` is `2`, while the **frequency** of `'b'` is `1`.

**Example 1:**

**Input:** s = "aab"
**Output:** 0
**Explanation:** `s` is already good.

**Example 2:**

**Input:** s = "aaabbbcc"
**Output:** 2
**Explanation:** You can delete two 'b's resulting in the good string "aaabcc".
Another way it to delete one 'b' and one 'c' resulting in the good string "aaabbc".

**Example 3:**

**Input:** s = "ceabaacb"
**Output:** 2
**Explanation:** You can delete both 'c's resulting in the good string "eabaab".
Note that we only care about characters that are still in the string at the end (i.e. frequency of 0 is ignored).

**Constraints:**

- `1 <= s.length <= 10^5`
- `s` contains only lowercase English letters.

## My Solution

Approach:

- use a map to calculate the frequencies of each character
- convert the map to another map which stores key: frequencies , value: characters count. (maybe an array is better?)

```dart
class Solution {
  int minDeletions(String s) {
    Map<int, int> characterFrequencyPair = {};

    int maxFrequencies = 0;
    s.runes.forEach((c) {
      int temp = (characterFrequencyPair[c] ?? 0) + 1;
      characterFrequencyPair[c] = temp;
      maxFrequencies = temp > maxFrequencies ? temp : maxFrequencies;
    });

    // index: frequency , value char counts
    final List<int> frequencyCharCounts =
        List.generate(maxFrequencies + 1, (index) => 0);

    characterFrequencyPair.forEach((_, freq) {
      frequencyCharCounts[freq]++;
    });

    int deletions = 0;
    for (int i = maxFrequencies; i > 0; i--) {
      while (frequencyCharCounts[i] > 1) {
        frequencyCharCounts[i]--;
        deletions++;
        frequencyCharCounts[i - 1]++;
      }
    }

    return deletions;
  }
}
```

since there is a constraint that s contains only lowercase English letters I can use an array instead of the first map.

```dart
class Solution {
  int minDeletions(String s) {
    List<int> characterFrequencyPair = List.generate(26, (index) => 0);

    int maxFrequencies = 0;
    s.runes.forEach((c) {
      int i = c - 97;
      characterFrequencyPair[i]++;
      maxFrequencies = characterFrequencyPair[i] > maxFrequencies
          ? characterFrequencyPair[i]
          : maxFrequencies;
    });

    // index: frequency , value char counts
    final List<int> frequencyCharCounts =
        List.generate(maxFrequencies + 1, (index) => 0);

    characterFrequencyPair.forEach((freq) {
      if (freq != 0) frequencyCharCounts[freq]++;
    });

    int deletions = 0;
    for (int i = maxFrequencies; i > 0; i--) {
      while (frequencyCharCounts[i] > 1) {
        frequencyCharCounts[i]--;
        deletions++;
        frequencyCharCounts[i - 1]++;
      }
    }

    return deletions;
  }
}
```

result: ![image](https://i.imgur.com/JYfKG0e.png)

## Better Solutions
