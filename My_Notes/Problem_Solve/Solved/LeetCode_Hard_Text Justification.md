# LeetCode:68:20230824:go

tags: #problem_solve #leetcode/hard #golang

[Reference](https://leetcode.com/problems/text-justification/)

## Question

Given an array of strings `words` and a width `maxWidth`, format the text such that each line has exactly `maxWidth` characters and is fully (left and right) justified.

You should pack your words in a greedy approach; that is, pack as many words as you can in each line. Pad extra spaces `' '` when necessary so that each line has exactly `maxWidth` characters.

Extra spaces between words should be distributed as evenly as possible. If the number of spaces on a line does not divide evenly between words, the empty slots on the left will be assigned more spaces than the slots on the right.

For the last line of text, it should be left-justified, and no extra space is inserted between words.

**Note:**

- A word is defined as a character sequence consisting of non-space characters only.
- Each word's length is guaranteed to be greater than `0` and not exceed `maxWidth`.
- The input array `words` contains at least one word.

**Example 1:**

```text
**Input:** words = ["This", "is", "an", "example", "of", "text", "justification."], maxWidth = 16
**Output:**
[
   "This    is    an",
   "example  of text",
   "justification.  "
]
```

**Example 2:**

```text
**Input:** words = ["What","must","be","acknowledgment","shall","be"], maxWidth = 16
**Output:**
[
  "What   must   be",
  "acknowledgment  ",
  "shall be        "
]
**Explanation:** Note that the last line is "shall be    " instead of "shall     be", because the last line must be left-justified instead of fully-justified.
Note that the second line is also left-justified because it contains only one word.
```

**Example 3:**

```text
**Input:** words = ["Science","is","what","we","understand","well","enough","to","explain","to","a","computer.","Art","is","everything","else","we","do"], maxWidth = 20
**Output:**
[
  "Science  is  what we",
  "understand      well",
  "enough to explain to",
  "a  computer.  Art is",
  "everything  else  we",
  "do                  "
]
```

**Constraints:**

- `1 <= words.length <= 300`
- `1 <= words[i].length <= 20`
- `words[i]` consists of only English letters and symbols.
- `1 <= maxWidth <= 100`
- `words[i].length <= maxWidth`

## My Solution

Approach: brute force

```go
func fullJustify(words []string, maxWidth int) []string {
	groups := groupTheWords(words, maxWidth)
	result := make([]string, len(groups))
	for i, group := range groups {
		result[i] = buildLine(group, maxWidth)
	}
	return result
}

func groupTheWords(words []string, maxWidth int) [][]string {
	res := [][]string{}
	currentGroup := []string{}
	width := maxWidth
	for i := 0; i < len(words); i++ {
		if len(words[i]) > width {
			res = append(res, currentGroup)
			width = maxWidth
			currentGroup = []string{}
			i--
			continue
		}
		currentGroup = append(currentGroup, words[i])
		width = width - len(words[i]) - 1
	}
	res = append(res, currentGroup)
	return res
}

func buildLine(words []string, maxWidth int) string {
	wordsCount := len(words)
	wordsLength := reduce(words, func(length int, word string) int {
		return length + len(word)
	})
	remainWidth := maxWidth - wordsLength

	buffer := bytes.Buffer{}

	if wordsCount == 1 {
		buffer.WriteString(words[0])
		for i := 0; i < remainWidth; i++ {
			buffer.WriteString(" ")
		}
		return buffer.String()
	}

	baseSpaces := remainWidth / (wordsCount - 1)
	additionalSpaces := remainWidth % (wordsCount - 1)
	for i, word := range words {
		buffer.WriteString(word)
		if i != wordsCount-1 {
			spaces := baseSpaces
			if i < additionalSpaces {
				spaces++
			}
			for j := 0; j < spaces; j++ {
				buffer.WriteString(" ")
			}
		}
	}
	return buffer.String()
}

func reduce[T any, R any](items []T, delegate func(R, T) R) R {
	r := *new(R)
	for _, item := range items {
		r = delegate(r, item)
	}
	return r
}
```

wrong answer

![image](https://i.imgur.com/jmdncti.png)

I forgot that the last line must be left-justified instead of fully-justified.

fix the issue and try again

```go
func fullJustify(words []string, maxWidth int) []string {
	groups := groupTheWords(words, maxWidth)
	result := make([]string, len(groups))
	for i, group := range groups {
		if i == len(groups)-1 {
			result[i] = buildFinalLine(group, maxWidth)
			break
		}
		result[i] = buildLine(group, maxWidth)
	}
	return result
}

func groupTheWords(words []string, maxWidth int) [][]string {
	res := [][]string{}
	currentGroup := []string{}
	width := maxWidth
	for i := 0; i < len(words); i++ {
		if len(words[i]) > width {
			res = append(res, currentGroup)
			width = maxWidth
			currentGroup = []string{}
			i--
			continue
		}
		currentGroup = append(currentGroup, words[i])
		width = width - len(words[i]) - 1
	}
	res = append(res, currentGroup)
	return res
}

func buildLine(words []string, maxWidth int) string {
	wordsCount := len(words)
	wordsLength := reduce(words, func(length int, word string) int {
		return length + len(word)
	})
	remainWidth := maxWidth - wordsLength

	buffer := bytes.Buffer{}

	if wordsCount == 1 {
		buffer.WriteString(words[0])
		for i := 0; i < remainWidth; i++ {
			buffer.WriteString(" ")
		}
		return buffer.String()
	}

	baseSpaces := remainWidth / (wordsCount - 1)
	additionalSpaces := remainWidth % (wordsCount - 1)
	for i, word := range words {
		buffer.WriteString(word)
		if i != wordsCount-1 {
			spaces := baseSpaces
			if i < additionalSpaces {
				spaces++
			}
			for j := 0; j < spaces; j++ {
				buffer.WriteString(" ")
			}
		}
	}
	return buffer.String()
}

func buildFinalLine(words []string, maxWidth int) string {
	buffer := bytes.NewBufferString(words[0])
	for i := 1; i < len(words); i++ {
		buffer.WriteString(" ")
		buffer.WriteString(words[i])
	}

	for buffer.Len() < maxWidth {
		buffer.WriteString(" ")
	}

	return buffer.String()
}

func reduce[T any, R any](items []T, delegate func(R, T) R) R {
	r := *new(R)
	for _, item := range items {
		r = delegate(r, item)
	}
	return r
}
```

result:

![image](https://i.imgur.com/kNMWDlB.png)

Analysis:

```go
func groupTheWords(words []string, maxWidth int) [][]string
```

Time Complexity: O(n), where n is the number of words in the input.
Space Complexity: O(m), where m is the number of groups formed. In the worst case, each word is its own group, so m could be equal to n.

```go
func buildLine(words []string, maxWidth int) string
```

Time Complexity: O(k), where k is the number of words in the input group. The function processes each word once.
Space Complexity: O(l), where l is the length of the final line that's built. The buffer space used is proportional to the length of the line.

```go
func buildFinalLine(words []string, maxWidth int) string
```

Time Complexity: O(k), where k is the number of words in the input group. The function processes each word once.
Space Complexity: O(l), where l is the length of the final line that's built. The buffer space used is proportional to the length of the line.

```go
func fullJustify(words []string, maxWidth int) []string
```

Time Complexity: O(n) + O(m \* k) + O(m \* k) = O(n + m \* k), where n is the number of words, m is the number of groups, and k is the average number of words in each group.
Space Complexity: O(n + m \* k), since the space complexity of each function is additive.

## Better Solutions

### Solution 1

[reference](https://leetcode.com/problems/text-justification/solutions/3952202/easy-solution-pyton3-c-c-java-with-image/)

```csharp
public class Solution {
    public IList<string> FullJustify(string[] words, int maxWidth) {
        List<string> res = new List<string>();

        int i = 0;
        int width = 0;
        List<string> curLine = new List<string>();

        while (i < words.Length) {
            string curWord = words[i];

            if (width + curWord.Length <= maxWidth) {
                curLine.Add(curWord);
                width += curWord.Length + 1;
                i++;
            } else {
                int spaces = maxWidth - width + curLine.Count;

                int added = 0;
                int j = 0;

                while (added < spaces) {
                    if (j >= curLine.Count - 1) {
                        j = 0;
                    }

                    curLine[j] += " ";
                    added++;
                    j++;
                }

                res.Add(string.Join("", curLine));

                curLine.Clear();
                width = 0;
            }
        }

        for (int word = 0; word < curLine.Count - 1; word++) {
            curLine[word] += " ";
        }
        curLine[curLine.Count - 1] += new string(' ', maxWidth - width + 1);

        res.Add(string.Join("", curLine));

        return res;
    }
}
```

Analysis:

1. **Main Loop**:
   - Time Complexity: O(n), where n is the number of words. The main loop iterates through each word exactly once.
   - Space Complexity: O(m), where m is the maximum number of words that can be in a line. This is the space used by the `curLine` list.

2. **Secondary Loop** (Adding spaces to the line):
   - The secondary loop that adds spaces to the line has a maximum iteration count of `spaces`, which can be proportional to `maxWidth` (in the worst case).
   - Time Complexity: O(maxWidth), which is a constant factor.
   - Space Complexity: O(1), as it only uses a few integer variables.

3. **Final Adjustments**:
   - The final adjustments to the last line involve adding spaces to the end of the last word.
   - Time Complexity: O(m), where m is the number of words in the last line (usually a constant).
   - Space Complexity: O(1), as it only uses a constant amount of space.

4. **Joining Strings**:
   - The `string.Join` method is used to concatenate strings together, and its time complexity is linear with respect to the total length of the strings being joined in this context.
   - Time Complexity: O(n + k), where n is the total number of characters in the words and k is the number of strings in the `curLine`.
   - Space Complexity: O(n + k), where n is the total number of characters in the words and k is the number of strings in the `curLine`.
