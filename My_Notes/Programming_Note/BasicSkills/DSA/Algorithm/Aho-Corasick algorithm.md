# Aho Corasick algorithm

[wiki](https://en.wikipedia.org/wiki/Aho%E2%80%93Corasick_algorithm)



## Abstract

與KMP同為字串比對演算法，主要是用來處理KMP在多個字串間搜尋時間複雜度會明顯提升的問題。

閱讀這篇筆記之前，請先熟讀 trie 和 KMP 的筆記。

這個演算法大致可以看成在trie的搜尋中加入KMP 的 LPS table 的概念

假設我有個字串"ABCDABD"在trie裡面

![](https://i.imgur.com/RVaV5wg.png)

在KMP筆記裡面我們曾經算過他的LPS table : [0000120]，代表查詢失敗後要從哪個位置繼續

把這個作法帶到trie裡面，用箭頭標出重試的位置。

![](https://i.imgur.com/BdYmdty.png)

