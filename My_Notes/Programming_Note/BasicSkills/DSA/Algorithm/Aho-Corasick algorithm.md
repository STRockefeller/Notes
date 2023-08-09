# Aho Corasick algorithm

tags: #string_searching_algorithms #algorithms
[wiki](https://en.wikipedia.org/wiki/Aho%E2%80%93Corasick_algorithm)

## Abstract

與[[Knuth–Morris–Pratt algorithm]]同為字串比對演算法，主要是用來處理KMP在多個字串間搜尋時間複雜度會明顯提升的問題。

閱讀這篇筆記之前，請先熟讀 [[Trie]] 和 [[Knuth–Morris–Pratt algorithm]] 的筆記。

這個演算法大致可以看成在trie的搜尋中加入KMP 的 LPS table 的概念

假設我有個字串"ABCDABD"在trie裡面

![image](./graph/Aho-Corasick%20algorithm-1.svg)

在KMP筆記裡面我們曾經算過他的LPS table : [0000120]，代表查詢失敗後要從哪個位置繼續

把這個作法帶到trie裡面，用箭頭標出重試的位置。

![image](./graph/Aho-Corasick%20algorithm-2.svg)

## Failure Index

![](https://i.imgur.com/tv4dZ3x.png)

trie裡面一共有7個詞，分別是`a`, `ab`, `bab`, `bc`, `bca`, `c`, `caa`

![image](./graph/Aho-Corasick%20algorithm-3.svg)

求出他們的LPS Table:

* `a` : [0]
* `ab` : [00]
* `bab` : [001]
* `bc` : [00]
* `bca` : [000]
* `c` : [0]
* `caa` : [000]

若只按照LPS來看，畫上失敗後指向的位置，如下

![image](./graph/Aho-Corasick%20algorithm-4.svg)

接著用Latex來畫trie好了

以AC演算法來說，除了指向自己的節點以外，還要能指向其他branches的節點，例如`bab` 出錯， 要從 `ab` 接著繼續， `ba` 出錯， 要從 `a` 接著繼續

![image](./graph/Aho-Corasick%20algorithm-5.svg)

## Try and Error

大概知道AC在幹嘛之後，先來試著自己實作一次看看，不確定能不能寫出來，不過應該是不錯的練習。

一開始想說在insert階段就決定錯誤指向的位置，不過馬上就被自己否決掉了，以上免得例子來說，假設我一開始只有`bca`一個字，那三個節點都指向root。但後來新增`caa`之後，那三個節點指向的位置就要跟著改變。這樣一來每次新增一個詞都可能導致前面做白工，顯然不太好。

我想等全部的詞都insert完成後，再來一次搞定全部的error index 應該是比較可行的做法。

總之先來實作一個簡單的trie結構。

```go
package ac

// trie for a-z
type TrieNode struct {
 nextNodes [26]*TrieNode
 retryNode *TrieNode
 isWord    bool
}

func NewTrieNode() TrieNode {
 return TrieNode{
  nextNodes: [26]*TrieNode{},
  retryNode: &TrieNode{},
  isWord:    false,
 }
}

func (tn *TrieNode) Insert(str string) {
 currentNode := tn
 for _, r := range str {
  i := r - 'a'
  if currentNode.nextNodes[i] == nil {
   nextNode := NewTrieNode()
   currentNode.nextNodes[i] = &nextNode
  }
  currentNode = currentNode.nextNodes[i]
 }
 currentNode.isWord = true
}

func (tn *TrieNode) Search(str string) bool {
 currentNode := tn
 for _, r := range str {
  i := r - 'a'
  if currentNode.nextNodes[i] == nil {
   return false
  }
  currentNode = currentNode.nextNodes[i]
 }
 return currentNode.isWord
}

func (tn *TrieNode) FillRetryNode() {

}

```

我新增了一個field去紀錄 error index，另外新增了一個方法去填寫這個field

感覺資訊有點不夠，假如我現在的節點是`bac`的`c` 位置

![](https://i.imgur.com/xW7Chqd.png)

照理來說我應該去找`ac` 或 `c` ，因此我需要知道我現在的位置是 `bac` ，但一般的trie結構甚至不知道父節點是啥，更別說整個字是甚麼了。

目前想到的解決方法:

* 改結構，讓節點知道父節點甚至於到目前為止經過的節點資訊。
* 不事先計算，等到出錯的時候，再來找error index。不過這樣一來會有重複計算的情況發生，也不是我們所樂見的。
