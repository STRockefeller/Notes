# Trie

#data_structure

[wiki](https://en.wikipedia.org/wiki/Trie)

[演算法筆記](https://web.ntnu.edu.tw/~algo/String.html)

[Leetcode 筆記－208. Implement Trie (Prefix Tree) | 什麼是字首樹？](https://englishandcoding.pixnet.net/blog/post/29962012-leetcode-筆記－208.-implement-trie-(prefix-tree)-|-什麼)

## Abstract

衍生自 [[Tree]]。

又稱 digital tree, prefix tree 用於快速尋找字串

特色就是: 用空間換取時間...嗯用超大的空間換取超快的時間

借用演算法筆記的圖

![](https://i.imgur.com/2r5Qw3m.png)

假如允許的字元有5種，每個節點就是長度為`5`的array，大小寫字母的話就是長度為`26*2`的array，再加上數字的話就是`26*2+10`

，ASCII就是128...

顯而易見的，空間占用量會非常可觀。相對的新增以及查詢的時間複雜度都是O(length of string)。可以說是相當快。

稍微提一下細節，如果不考慮Aho–Corasick等演算法的話。trie中每個字都是從root找起，作為一個字結尾的點會特別註記。

----

## Implement

實作的部分在LeetCode208的解題筆記中。
