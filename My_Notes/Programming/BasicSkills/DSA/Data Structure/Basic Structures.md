# Basic Structures

tags: #data_structure #array #linked_list #queue #stack

Reference:

[演算法筆記](http://web.ntnu.edu.tw/~algo/Data.html)

## Abstract

這邊記錄一些比較基本的結構供以後快速複習，獨立開篇寫太麻煩了。

## Array

一個格子放入一筆資料，資料可以是一個數字、一個字元（所有字元合起來變成字串）、一個物件等等。

搜尋、插入、刪除的時間複雜度都是 O(N) 。資料已排序，則支援二元搜尋。

### Dynamic Array

根據資料數量，調整陣列大小，稱作 Dynamic Array 。每當陣列裝滿資料，就另外建立兩倍大的新陣列，將資料搬到新陣列，捨棄原陣列。搬移的總時間複雜度是 O(1 + 2 + 4 + 8 + ... + N) = O(2N - 1) = O(N) 。

C++可以直接使用 STL 的 vector 。

以 Golang 來說就是 Slice

```go
package main

import "fmt"

func main() {
 fmt.Println("長度為2的Slice")
 dynamicArray := make([]int, 2)
 fmt.Println(dynamicArray)
 fmt.Println(len(dynamicArray))
 fmt.Println(cap(dynamicArray))
 fmt.Println("新增資料後")
 dynamicArray = append(dynamicArray, 1)
 fmt.Println(dynamicArray)
 fmt.Println(len(dynamicArray))
 fmt.Println(cap(dynamicArray))
}

```

result

```
長度為2的Slice
[0 0]
2
2
新增資料
[0 0 1]
3
4
```

## Linked List

![](http://web.ntnu.edu.tw/~algo/Data3.png)

搜尋的時間複雜度是 O(N) 。知道正確位置，插入與刪除的時間複雜度是 O(1) ，否則必須先搜尋。無索引值，故不支援二元搜尋。

可以直接使用 STL 的 list 。

### Circular List

![](http://web.ntnu.edu.tw/~algo/Data5.png)

尾串到頭，頭尾循環，稱作 Circular List 。特色是開頭可以隨便選、隨便動。

### Singly Linked List

```
   head
    |
    v
+--------+   +--------+   +--------+
|        |   |        |   |        |
| node 0 |-->| node 1 |-->| node 2 |--> NULL
|        |   |        |   |        |
+--------+   +--------+   +--------+

```

只串單向，稱作 Singly Linked List 。雙向都串，稱作 Doubly Linked List ，特色是雙向都能搜尋。

Doubly Linked List 若用 XOR 實作，稱作 XOR Linked List 。

Doubly Linked List 若可以還原刪除動作，稱作 Dancing Links ，經常配合 Backtracking 一起使用。

### Unrolled Linked List

![](http://web.ntnu.edu.tw/~algo/Data7.png)

就是把Array放到List裡面

### Adjacency Lists

![](http://web.ntnu.edu.tw/~algo/Data8.png)

把List放到Array裡面，在Graph結構中會用到。

## Queue

![](http://web.ntnu.edu.tw/~algo/Data9.png)

Array 和 List 皆可實作。

插入、刪除需時 O(1) 。搜尋需時 O(N) 。

佇列有暫留的性質。

可以直接使用 STL 的 queue 。

### Circular Queue

![](https://cdn.programiz.com/sites/tutorial2program/files/circular-increment.png)

記憶體循環使用，稱作 Circular Queue 。

### Priority Queue

資料保持排序，可以隨時得到最小（大）值，稱作 [[Priority Queue (Heap)]] 。
資料保持排序，可以隨時得到最小值以及最大值，稱作 Double Ended Priority Queue 。

## Stack

Array 和 List 皆可實作。

插入、刪除需時 O(1) 。搜尋需時 O(N) 。

堆疊有反轉的性質、有括號對應的性質、有遞迴與疊代的性質。

可以直接使用 STL 的 stack 。

## Deque （ Double Ended Queue ）

![](https://cdn.programiz.com/sites/tutorial2program/files/deque.png)

兩頭皆能插入與刪除，稱作 Deque ，同時有著 Stack 和 Queue 的功效。

Array 和 Doubly Linked List 皆可實作。

可以直接使用 STL 的 deque 。
