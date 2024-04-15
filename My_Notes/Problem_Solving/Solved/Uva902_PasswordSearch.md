# UVA:902:20220518:go

[Reference](https://onlinejudge.org/external/9/902.pdf)



## Question

Being able to send encoded messages during World War II was very important to the Allies. The messages were always sent after being encoded with a known password. Having a fixed password was of course insecure, thus there was a need to change it frequently. However, a mechanism was necessary to send the new password. One of the mathematicians working in the cryptographic team had a clever idea that was to send the password hidden within the message itself. The interesting point was that the receiver of the message only had to know the size of the password and then search for the password within the received text. 

A password with size N can be found by searching the text for the most frequent substring with N characters. After finding the password, all the substrings that coincide with the password are removed from the encoded text. Now, the password can be used to decode the message. 

Your mission has been simplified as you are only requested to write a program that, given the size of the password and the encoded message, determines the password following the strategy given above. 

To illustrate your task, consider the following example in which the password size is three (N = 3) and the text message is just ‘baababacb’. The password would then be aba because this is the substring with size 3 that appears most often in the whole text (it appears twice) while the other six different substrings appear only once (baa ; aab ; bab ; bac ; acb).



### input

The input file contains several test cases, each of them consists of one line with the size of the password, 0 < N ≤ 10, followed by the text representing the encoded message. To simplify things, you can assume that the text only includes lower case letters.



### output

For each test case, your program should print as output a line with the password string.



### sample input

3 baababacb



### sample output

aba



## My Solution

先暴力解..

題目沒提到出現同樣次數的情況要怎麼做，先隨便選好了



```go
// brute force
func Uva902(length int, str string) string {
	subStringCountPair := make(map[string]int)

	left := 0
	right := left + length

	for right <= len(str) {
		subStringCountPair[str[left:right]]++
		left++
		right++
	}

	maxNum := 0
	res := ""
	for key, val := range subStringCountPair {
		if val > maxNum {
			maxNum = val
			res = key
		}
	}

	return res
}
```

雙指針只是方便理解，實際上因為`left`和`right`總是間隔`length`所以完全沒必要。



簡單測一下效率

```go

func Benchmark_902_Force_SimpleCase(b *testing.B) {
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		Uva902(3, "baababacb")
	}
}

func Benchmark_902_Force_DifficultCase(b *testing.B) {
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		Uva902(3, "baababacbafewfwvqeg3qg3fqewfdvdasdvaiiiddkjrmfrtsasvsvgdfsbbdfdrgergewrwgergebdfbdbdbdbewqfwefqzxcvrwfwfaewqfewwgf4g")
	}
}
```

結果

```
goos: windows
goarch: amd64
pkg: test
Benchmark_902_Force_SimpleCase-8      	 6928785	       169 ns/op	       0 B/op	       0 allocs/op
Benchmark_902_Force_DifficultCase-8   	  130680	      8967 ns/op	    7825 B/op	       7 allocs/op
PASS
coverage: 100.0% of statements
ok  	test	2.976s
```



第一個case字串長度為29，第二個為116正好為4倍，速度則差了53倍



---

接著試著用剛學的trie解看看，想不到太好的解法，有點硬要用的感覺...

```go
func Uva902Trie(length int, str string) string {
	trie := NewTrie()

	left := 0
	right := left + length

	for right <= len(str) {
		trie.Insert(str[left:right])
		left++
		right++
	}

	rs, _ := trie.GetMostFrequencyString()
	return string(rs)
}

type Trie struct {
	children [26]*Trie
	strCount int
}

func NewTrie() Trie {
	return Trie{}
}

func (t *Trie) Insert(word string) {
	currentNode := t
	for index, char := range word {
		char = char - 'a'
		if currentNode.children[int(char)] == nil {
			newTrie := NewTrie()
			currentNode.children[int(char)] = &newTrie
		}
		if index == len(word)-1 {
			currentNode.children[int(char)].strCount++
		}
		currentNode = currentNode.children[int(char)]
	}
}

func (t *Trie) Search(word string) bool {
	currentNode := t
	for index, char := range word {
		char = char - 'a'
		if currentNode.children[int(char)] == nil {
			return false
		}
		if index == len(word)-1 {
			return currentNode.children[int(char)].strCount > 0
		}
		currentNode = currentNode.children[int(char)]
	}
	return false // should never go through
}

func (t *Trie) StartsWith(prefix string) bool {
	currentNode := t
	for _, char := range prefix {
		char = char - 'a'
		if currentNode.children[int(char)] == nil {
			return false
		}
		currentNode = currentNode.children[int(char)]
	}
	return true
}

func (t *Trie) GetMostFrequencyString() ([]rune, int) {
	// #region for last char
	var res rune
	var lastFlag bool
	// #endregion for last char
	maxNum := 0
	// #region for others
	var prevString []rune
	// #endregion for others
	for index, child := range t.children {
		if child == nil {
			continue
		}
		if child.strCount != 0 {
			if child.strCount > maxNum {
				maxNum = child.strCount
				res = 'a' + rune(index)
				lastFlag = true
			}
		}
		p, n := child.GetMostFrequencyString()
		if n > maxNum {
			maxNum = n
			prevString = p
			res = 'a' + rune(index)
		}
	}
	if lastFlag {
		return []rune{res}, maxNum
	}
	return append([]rune{res}, prevString...), maxNum
}

```

遞迴邏輯想了40分鐘，最後還寫了一個效率奇差的版本...

```
goos: windows
goarch: amd64
pkg: test
Benchmark_902_Trie_SimpleCase-8   	  631578	      1772 ns/op	    2784 B/op	      29 allocs/op
PASS
coverage: 56.5% of statements
ok  	test	1.518s

```



## Better Solutions

