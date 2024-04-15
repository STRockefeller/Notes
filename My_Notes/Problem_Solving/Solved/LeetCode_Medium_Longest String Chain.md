# LeetCode:1048:20230923:dart

tags: #problem_solve #leetcode/medium #dart #dynamic_programming #aho_corasick #trie

[Reference](https://leetcode.com/problems/longest-string-chain/description/)

## Question

You are given an array of `words` where each word consists of lowercase English letters.

`wordA` is a **predecessor** of `wordB` if and only if we can insert **exactly one** letter anywhere in `wordA` **without changing the order of the other characters** to make it equal to `wordB`.

- For example, `"abc"` is a **predecessor** of `"abac"`, while `"cba"` is not a **predecessor** of `"bcad"`.

A **word chain** is a sequence of words `[word1, word2, ..., wordk]` with `k >= 1`, where `word1` is a **predecessor** of `word2`, `word2` is a **predecessor** of `word3`, and so on. A single word is trivially a **word chain** with `k == 1`.

Return _the **length** of the **longest possible word chain** with words chosen from the given list of_ `words`.

**Example 1:**

**Input:** words = ["a","b","ba","bca","bda","bdca"]
**Output:** 4
**Explanation**: One of the longest word chains is ["a","ba","bda","bdca"].

**Example 2:**

**Input:** words = ["xbc","pcxbcf","xb","cxbc","pcxbc"]
**Output:** 5
**Explanation:** All the words can be put in a word chain ["xb", "xbc", "cxbc", "pcxbc", "pcxbcf"].

**Example 3:**

**Input:** words = ["abcd","dbqca"]
**Output:** 1
**Explanation:** The trivial word chain ["abcd"] is one of the longest word chains.
["abcd","dbqca"] is not a valid word chain because the ordering of the letters is changed.

**Constraints:**

- `1 <= words.length <= 1000`

## My Solution

```dart
class Solution {
  int longestStrChain(List<String> words) {
    int minLen = 9999999999;
    int maxLen = 0;
    final Map<int, List<String>> groups = {};
    words.forEach((word) {
      minLen = word.length < minLen ? word.length : minLen;
      maxLen = word.length > maxLen ? word.length : maxLen;
      groups[word.length] = (groups[word.length] ?? []) + [word];
    });

    final Map<String, int> dp = {};
    groups[minLen]!.forEach((word) {
      dp[word] = 1;
    });

    for (int i = 1 + minLen; i <= maxLen; i++) {
      (groups[i] ?? []).forEach((word) {
        List<String> predecessors = _getPredecessors(word, groups[i - 1] ?? []);
        if (predecessors.length == 0) {
          dp[word] = 1;
          return;
        }
        int prevMax = 0;
        predecessors.forEach((element) {
          if ((dp[element] ?? 0) > prevMax) {
            prevMax = dp[element]!;
          }
        });
        dp[word] = prevMax + 1;
      });
    }

    return dp.entries
        .reduce((longestChain, element) =>
            element.value > longestChain.value ? element : longestChain)
        .value;
  }

  List<String> _getPredecessors(String word, List<String> candidates) {
    return candidates.where((element) => _isChained(word, element)).toList();
  }

  bool _isChained(String longer, String shorter) {
    for (int i = 0; i < shorter.length; i++) {
      if (longer[i] != shorter[i]) {
        return longer.substring(i + 1) == shorter.substring(i);
      }
    }
    return true;
  }
}
```

## Better Solutions

### Solution 1

AC

```java
class Solution {
    public int longestStrChain(String[] words) {
        if (words == null || words.length == 0) return 0;
        int res = 1;

		//Bucket sort all words using hashmap by its length.
		//and store the min and max length.
        Map<Integer, List<String>> dict = new HashMap<>();
        int len = 0;
        int min = Integer.MAX_VALUE, max = Integer.MIN_VALUE;
        for (String w : words) {
            len = w.length();
            min = Math.min(min, len);
            max = Math.max(max, len);
            List<String> list = dict.getOrDefault(len, new ArrayList<>());
            list.add(w);
            dict.put(len, list);
        }

		// here the "map" is used for DP
		// where the key is the string and the value is the longest chain this word can form by far.
        HashMap<String, Integer> map = new HashMap();
        for (String w : dict.get(min)) {
            map.put(w, 1);
        }

        for (int i = min + 1; i <= max; i++) {
            List<String> pre = dict.get(i - 1);
            for (String s : dict.get(i)) {
                int m = 1;
                for (String p: pre) {
                    if (isChain(p, s)) m = Math.max(m, map.get(p) + 1);
                }
                map.put(s, m);
                if (m > res) res = m;
            }
        }

        return res;
    }


    private boolean isChain(String s1, String s2) {
        if (s1.length() + 1 != s2.length()) return false;
        boolean coin = false;
        int j = 0;
        for (int i = 0; i < s1.length(); i++, j++) {
            if (s1.charAt(i) != s2.charAt(j)) {
                if (coin) {
                    return false;
                } else {
                    coin = true;
                    i--;
                }
            }
        }
        return true;
    }
}
```