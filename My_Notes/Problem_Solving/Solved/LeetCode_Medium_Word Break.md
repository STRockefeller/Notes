# LeetCode:139:20230804:go

tags: #problem_solve #leetcode/medium #trie #dynamic_programming 

[Reference](https://leetcode.com/problems/word-break/)

## Question

Given a string `s` and a dictionary of strings `wordDict`, return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words.

**Note** that the same word in the dictionary may be reused multiple times in the segmentation.

**Example 1:**

**Input:** s = "leetcode", wordDict = ["leet","code"]
**Output:** true
**Explanation:** Return true because "leetcode" can be segmented as "leet code".

**Example 2:**

**Input:** s = "applepenapple", wordDict = ["apple","pen"]
**Output:** true
**Explanation:** Return true because "applepenapple" can be segmented as "apple pen apple".
Note that you are allowed to reuse a dictionary word.

**Example 3:**

**Input:** s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
**Output:** false

**Constraints:**

- `1 <= s.length <= 300`
- `1 <= wordDict.length <= 1000`
- `1 <= wordDict[i].length <= 20`
- `s` and `wordDict[i]` consist of only lowercase English letters.
- All the strings of `wordDict` are **unique**.

## My Solution

Approach: [[Aho-Corasick algorithm]]

```go
func wordBreak(s string, wordDict []string) bool {
	dict := buildTrie(wordDict)
	addFailureLinks(dict)
	foundIndex := search(s, dict)

	indexLengthPair := make([][]int, len(s))
	for word, appearedAt := range foundIndex {
		len := len(word)
		for _, index := range appearedAt {
			indexLengthPair[index] = append(indexLengthPair[index], len)
		}
	}

	return validateIndexLengthPair(indexLengthPair, 0)
}

func validateIndexLengthPair(indexLengthPair [][]int, from int) bool {
	for _, l := range indexLengthPair[from] {
		if from+l == len(indexLengthPair) {
			return true
		}
		if from+l > len(indexLengthPair) {
			continue
		}
		if validateIndexLengthPair(indexLengthPair, from+l) {
			return true
		}
	}
	return false
}

// Define the trieNode structure
type trieNode struct {
	children map[rune]*trieNode
	isEnd    bool
	failure  *trieNode
	output   []string
}

// Create a new TrieNode
func tewTrieNode() *trieNode {
	return &trieNode{
		children: make(map[rune]*trieNode),
		isEnd:    false,
		failure:  nil,
		output:   nil,
	}
}

// Build the trie from the given patterns
func buildTrie(patterns []string) *trieNode {
	root := tewTrieNode()

	for _, pattern := range patterns {
		node := root
		for _, char := range pattern {
			if _, ok := node.children[char]; !ok {
				node.children[char] = tewTrieNode()
			}
			node = node.children[char]
		}
		node.isEnd = true
		node.output = append(node.output, pattern)
	}

	return root
}

// Add failure links to the trie nodes
func addFailureLinks(root *trieNode) {
	queue := make([]*trieNode, 0)

	for _, child := range root.children {
		child.failure = root
		queue = append(queue, child)
	}

	for len(queue) > 0 {
		curr := queue[0]
		queue = queue[1:]

		for char, child := range curr.children {
			queue = append(queue, child)

			failure := curr.failure
			for failure != nil && failure.children[char] == nil {
				failure = failure.failure
			}

			if failure == nil {
				child.failure = root
			} else {
				child.failure = failure.children[char]
			}

			// Copy output from failure node
			child.output = append(child.output, child.failure.output...)
		}
	}
}

// search for patterns in the text using the Aho-Corasick algorithm
func search(text string, root *trieNode) map[string][]int {
	result := make(map[string][]int)
	node := root

	for i, char := range text {
		for node != nil && node.children[char] == nil {
			node = node.failure
		}

		if node == nil {
			node = root
		} else {
			node = node.children[char]
		}

		if node == nil {
			node = root
		} else {
			for _, pattern := range node.output {
				result[pattern] = append(result[pattern], i-len(pattern)+1)
			}
		}
	}

	return result
}
```

timed out

![image](https://i.imgur.com/KZV6DEg.png)

```go
func validateIndexLengthPair(indexLengthPair [][]int, from int) bool {
	for _, l := range indexLengthPair[from] {
		if from+l == len(indexLengthPair) {
			return true
		}
		if from+l > len(indexLengthPair) {
			continue
		}
		if validateIndexLengthPair(indexLengthPair, from+l) {
			return true
		}
	}
	return false
}
```

this part took too much time.

I have no idea how to edit it, maybe I can try to search from the other side 😈 ~~and fail with "baaaaaaaaa"~~.

```go
func wordBreak(s string, wordDict []string) bool {
	dict := buildTrie(wordDict)
	addFailureLinks(dict)
	foundIndex := search(s, dict)

	backIndexLengthPair := make([][]int, len(s))
	for word, appearedAt := range foundIndex {
		len := len(word)
		for _, index := range appearedAt {
			backIndexLengthPair[index+len] = append(backIndexLengthPair[index], len)
		}
	}

	return validateBackIndexLengthPair(backIndexLengthPair, len(s)-1)
}

func validateBackIndexLengthPair(indexBackLengthPair [][]int, from int) bool {
	for _, l := range indexBackLengthPair[from] {
		if from-l == 0 {
			return true
		}
		if from-l < 0 {
			continue
		}
		if validateBackIndexLengthPair(indexBackLengthPair, from-l) {
			return true
		}
	}
	return false
}

// Define the trieNode structure
type trieNode struct {
	children map[rune]*trieNode
	isEnd    bool
	failure  *trieNode
	output   []string
}

// Create a new TrieNode
func tewTrieNode() *trieNode {
	return &trieNode{
		children: make(map[rune]*trieNode),
		isEnd:    false,
		failure:  nil,
		output:   nil,
	}
}

// Build the trie from the given patterns
func buildTrie(patterns []string) *trieNode {
	root := tewTrieNode()

	for _, pattern := range patterns {
		node := root
		for _, char := range pattern {
			if _, ok := node.children[char]; !ok {
				node.children[char] = tewTrieNode()
			}
			node = node.children[char]
		}
		node.isEnd = true
		node.output = append(node.output, pattern)
	}

	return root
}

// Add failure links to the trie nodes
func addFailureLinks(root *trieNode) {
	queue := make([]*trieNode, 0)

	for _, child := range root.children {
		child.failure = root
		queue = append(queue, child)
	}

	for len(queue) > 0 {
		curr := queue[0]
		queue = queue[1:]

		for char, child := range curr.children {
			queue = append(queue, child)

			failure := curr.failure
			for failure != nil && failure.children[char] == nil {
				failure = failure.failure
			}

			if failure == nil {
				child.failure = root
			} else {
				child.failure = failure.children[char]
			}

			// Copy output from failure node
			child.output = append(child.output, child.failure.output...)
		}
	}
}

// search for patterns in the text using the Aho-Corasick algorithm
func search(text string, root *trieNode) map[string][]int {
	result := make(map[string][]int)
	node := root

	for i, char := range text {
		for node != nil && node.children[char] == nil {
			node = node.failure
		}

		if node == nil {
			node = root
		} else {
			node = node.children[char]
		}

		if node == nil {
			node = root
		} else {
			for _, pattern := range node.output {
				result[pattern] = append(result[pattern], i-len(pattern)+1)
			}
		}
	}

	return result
}
```

timed out again

![image](https://i.imgur.com/6i8Yu27.png)


---

After a few months... 2024/5/25

New approach:
- dynamic programming
- use a bool array to represent if the prefix of `s` could be broken or not
- if the first j chars in the string can be boken, then we can just validate the rest chars in the string.

```go
func wordBreak(s string, wordDict []string) bool {
    if s == ""{
        return true
    }

    // dp[i] means that s[:i] can be broken or not
    dp := make([]bool,len(s)+1)
    dp[0] = true

    for i:=1;i<=len(s);i++{
        for j:=0;j<i;j++{
            if dp[i]{
                break
            }
            if dp[j]{
                w := string(s[j:i])
                for _,word := range wordDict{
                    if w == word{
                        dp[i] = true
                        break
                    }
                }
            }
        }
    }
    return dp[len(s)]
}
```

![image](https://i.imgur.com/VvQHZSG.png)
## Better Solutions
