# LeetCode:208:20220518:Go

tags: #leetcode/medium #golang #trie  

[Reference](https://leetcode.com/problems/implement-trie-prefix-tree/)
## Question

A [**trie**](https://en.wikipedia.org/wiki/Trie) (pronounced as "try") or **prefix tree** is a tree data structure used to efficiently store and retrieve keys in a dataset of strings. There are various applications of this data structure, such as autocomplete and spellchecker.

Implement the Trie class:

- `Trie()` Initializes the trie object.
- `void insert(String word)` Inserts the string `word` into the trie.
- `boolean search(String word)` Returns `true` if the string `word` is in the trie (i.e., was inserted before), and `false` otherwise.
- `boolean startsWith(String prefix)` Returns `true` if there is a previously inserted string `word` that has the prefix `prefix`, and `false` otherwise.

 

**Example 1:**

```
Input
["Trie", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output
[null, null, true, false, true, null, true]

Explanation
Trie trie = new Trie();
trie.insert("apple");
trie.search("apple");   // return True
trie.search("app");     // return False
trie.startsWith("app"); // return True
trie.insert("app");
trie.search("app");     // return True
```

 

**Constraints:**

- `1 <= word.length, prefix.length <= 2000`
- `word` and `prefix` consist only of lowercase English letters.
- At most `3 * 104` calls **in total** will be made to `insert`, `search`, and `startsWith`.

## My Solution

golang 答題模板如下

```go
type Trie struct {
}

func Constructor() Trie {

}

func (this *Trie) Insert(word string) {

}

func (this *Trie) Search(word string) bool {

}

func (this *Trie) StartsWith(prefix string) bool {

}

/**
 * Your Trie object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Insert(word);
 * param_2 := obj.Search(word);
 * param_3 := obj.StartsWith(prefix);
 */
```

話說我記得以前golint不允許用this代指自己



題目沒有明確給出字元的範圍，先用全ASCII來做好了

總感覺可以用map做，算了還是先用經典的array來實作好了，晚點再試試map有沒有比較好



```go
type Trie struct {
	children [128]*Trie
	isString bool
}

func Constructor() Trie {
	return Trie{}
}

func (this *Trie) Insert(word string) {
	currentNode := this
	for index, char := range word {
		if currentNode.children[int(char)] == nil {
			newTrie := Constructor()
			currentNode.children[int(char)] = &newTrie
		}
		if index == len(word)-1 {
			currentNode.children[int(char)].isString = true
		}
		currentNode = currentNode.children[int(char)]
	}
}

func (this *Trie) Search(word string) bool {
	currentNode := this
	for index, char := range word {
		if currentNode.children[int(char)] == nil {
			return false
		}
		if index == len(word)-1 {
			return currentNode.children[int(char)].isString
		}
		currentNode = currentNode.children[int(char)]
	}
	return false // should never go through
}

func (this *Trie) StartsWith(prefix string) bool {
	currentNode := this
	for _, char := range prefix {
		if currentNode.children[int(char)] == nil {
			return false
		}
		currentNode = currentNode.children[int(char)]
	}
	return true
}

/**
 * Your Trie object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Insert(word);
 * param_2 := obj.Search(word);
 * param_3 := obj.StartsWith(prefix);
 */

```

寫完才發現自己眼幹沒看到

> `word` and `prefix` consist only of lowercase English letters.



還是來改一下好了，節省點空間

```go
type Trie struct {
	children [26]*Trie
	isString bool
}

func Constructor() Trie {
	return Trie{}
}

func (this *Trie) Insert(word string) {
	currentNode := this
	for index, char := range word {
		char = char - 'a'
		if currentNode.children[int(char)] == nil {
			newTrie := Constructor()
			currentNode.children[int(char)] = &newTrie
		}
		if index == len(word)-1 {
			currentNode.children[int(char)].isString = true
		}
		currentNode = currentNode.children[int(char)]
	}
}

func (this *Trie) Search(word string) bool {
	currentNode := this
	for index, char := range word {
		char = char - 'a'
		if currentNode.children[int(char)] == nil {
			return false
		}
		if index == len(word)-1 {
			return currentNode.children[int(char)].isString
		}
		currentNode = currentNode.children[int(char)]
	}
	return false // should never go through
}

func (this *Trie) StartsWith(prefix string) bool {
	currentNode := this
	for _, char := range prefix {
		char = char - 'a'
		if currentNode.children[int(char)] == nil {
			return false
		}
		currentNode = currentNode.children[int(char)]
	}
	return true
}

/**
 * Your Trie object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Insert(word);
 * param_2 := obj.Search(word);
 * param_3 := obj.StartsWith(prefix);
 */

```

![](https://i.imgur.com/nk0oCT7.png)

一次過，讚喔



```go
type Trie struct {
	children map[rune]*Trie
	isString bool
}

func Constructor() Trie {
	return Trie{
		children: make(map[rune]*Trie),
	}
}

func (this *Trie) Insert(word string) {
	currentNode := this
	for index, char := range word {
		char = char - 'a'
		if currentNode.children[char] == nil {
			newTrie := Constructor()
			currentNode.children[char] = &newTrie
		}
		if index == len(word)-1 {
			currentNode.children[char].isString = true
		}
		currentNode = currentNode.children[char]
	}
}

func (this *Trie) Search(word string) bool {
	currentNode := this
	for index, char := range word {
		char = char - 'a'
		if currentNode.children[char] == nil {
			return false
		}
		if index == len(word)-1 {
			return currentNode.children[char].isString
		}
		currentNode = currentNode.children[char]
	}
	return false // should never go through
}

func (this *Trie) StartsWith(prefix string) bool {
	currentNode := this
	for _, char := range prefix {
		char = char - 'a'
		if currentNode.children[char] == nil {
			return false
		}
		currentNode = currentNode.children[char]
	}
	return true
}

/**
 * Your Trie object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Insert(word);
 * param_2 := obj.Search(word);
 * param_3 := obj.StartsWith(prefix);
 */

```



來試試map的效率如何

![](https://i.imgur.com/OtPvIOW.png)



空間省了一點，時間慢了很多。看來用array不是沒道理的



## Better Solutions



### Solution 1

python 號稱 贏過99%時間、 95%空間的答案

```python
class Trie(object):

	def __init__(self):
		self.trie = {}


	def insert(self, word):
		t = self.trie
		for c in word:
			if c not in t: t[c] = {}
			t = t[c]
		t["-"] = True


	def search(self, word):
		t = self.trie
		for c in word:
			if c not in t: return False
			t = t[c]
		return "-" in t

	def startsWith(self, prefix):
		t = self.trie
		for c in prefix:
			if c not in t: return False
			t = t[c]
		return True
```

感覺跟我的解法差不多，可能這題目也沒啥可以發揮的空間吧
