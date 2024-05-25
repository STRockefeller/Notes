tags: #string_searching_algorithms #algorithms #hash #rehash

references:
- [mark-lin](https://mark-lin.com/posts/20200625/)
- [programiz](https://www.programiz.com/dsa/rabin-karp-algorithm)

## Abstract

和其他字串搜尋演算法大同小異，都是拿來解決找substring的問題。

為了簡化問題，這篇中會先以一對一查詢為主，多組的查詢還是用[[Aho-Corasick algorithm]]吧。

在最開頭先聲明，平均而言這個演算法的速度是不及我先前學過的[[(Archive) Knuth–Morris–Pratt algorithm]]，特定案例中，rabin-karp會略快一些。

題外話，golang的strings package 就是用rabin-karp來實作字串搜尋的。

## About Rabin-Karp

在一般的情況下一對一的字串搜尋(假設原字串長度為m要找的字串長度為n)，最差的情況就是`O(m*n)` 。rabin-karp的複雜度則會落在`O(m+n)` 到 `O(m*n)` 之間。

實現的原理就是把兩邊的字串經過hash處理後再比對。

## Example

以下直接舉個例子

我直接拿[[(Archive) Knuth–Morris–Pratt algorithm]]那篇的例子來用

```text
Input:  txt[] =  "ABC ABCDAB ABCDABCDABDE"
        pat[] =  "ABCDABD"
Output: Pattern found at index 15
```

在rabin-karp的作法如下


### hash

首先先依Substring length 來對雙方做 hash。

這邊用的hash function是有要求的:
- 要能夠rehash
- 避免overflow
- collision 發生機率低

這邊先弄個陽春版的hash function，假設我的hash function io 如下

| input              | output |
| ------------------ | ------ |
| A                  | 1      |
| B                  | 2      |
| C                  | 3      |
| D                  | 4      |
| E                  | 5      |
| \<empty string\>   | 10     |
| AB                 | 1+2    |
| 復合的字串以此類推 |        |


接著來比較

```go
for i := range txt{
	var hashValue uint
	for j := range pat{
		hashVlaue += hash(txt[i+j])
	}
	if hashValue == hash(pat){
		// ...
	}
}
```

等等，怎麼有兩層 for loop ?! 這不就跟暴力解一樣了嗎?

#### rehash

這個時候就要用到先前提到的rehash，hash function 中，我們若能在O(1)的複雜度下，推算出下一個hash value，則稱其為rehashable

以上例中的hash function為例。從`txt`中取長度為7的substring

`"ABC ABC"` => 1+2+3+10+1+2+3 = 22
下一個為
`"BC ABCD"` => 2+3+10+1+2+3+4 = 25
可以看為 22 - 1(最開頭的A) + 4(最末的D) = 25

如此一來我們就可以把前例改成

```go
var hashValue uint
for i := range txt{
	if i:= 0{
		for j := range pat{
			hashValue += hash(txt[j])
		}
	}else{
		hashValue - hash(txt[i-1]) + hash(txt[i+j])
	}
	
	if hashValue == hash(pat){
		// ...
	}
}
```

#### collision

時間複雜度的問題解決了，但是扯到hash就一定繞不開碰撞問題，上面的那個陽春版hash function明眼人一看就知道一定碰個鼻青臉腫。

因為複合字串是每個字元的hash value加起來，所以像是 AAD(1+1+4) 會撞上 ABC(1+2+3)
另外，因為加法符合交換率，所以 ABC 和 CBA 也會碰上。

碰撞問題的解法這邊就不討論了，會離題，之後再另開筆記紀錄之。

我們需要處理碰撞問題之餘，使用更好的 hash function 來降低碰撞機率，是我們更加樂見的作法。

## Aditional

![about hash funciton](https://i.imgur.com/roAauME.png)