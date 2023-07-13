# Floyd Cycle Detection

#algorithms #two_pointers #cycle_detection

## References

[Floyd判圈算法 - 維基百科，自由的百科全書](https://zh.wikipedia.org/zh-tw/Floyd%E5%88%A4%E5%9C%88%E7%AE%97%E6%B3%95)

[菜鳥工程師 肉豬: Floyd Cycle Detection Algorithm 龜兔賽跑算法](https://matthung0807.blogspot.com/2020/04/floyd-cycle-detection-algorithm-floyd.html)

[medium](https://medium.com/@orionssl/%E6%8E%A2%E7%B4%A2-floyd-cycle-detection-algorithm-934cdd05beb9)

[刷題模式: 快慢指針（Fast-slow Pointers） - HackMD](https://hackmd.io/@Hsins/fast-slow-pointers)

## Abstract

會對它感興趣主要是應位在leetcode看到有人用這個解法來解happy number，而且試了一下發現它竟然比我用hash set解題來的快。

這個算法就像他的名字一樣，適用於需要檢查是否有循環的情境。

作法很簡單，就只是單純的建立快慢指針，然後看他們是否會相遇而已。

> **Floyd判圈算法**(**Floyd Cycle Detection Algorithm**)，又稱**龜兔賽跑算法**(**Tortoise and Hare Algorithm**)，是一個可以在[有限狀態機](https://zh.wikipedia.org/wiki/%E6%9C%89%E9%99%90%E7%8A%B6%E6%80%81%E6%9C%BA "有限狀態機")、[迭代函數](https://zh.wikipedia.org/wiki/%E8%BF%AD%E4%BB%A3%E5%87%BD%E6%95%B0 "迭代函數")或者[鍊表](https://zh.wikipedia.org/wiki/%E9%93%BE%E8%A1%A8 "鍊表")上判斷是否存在[環](https://zh.wikipedia.org/wiki/%E7%92%B0_(%E5%9C%96%E8%AB%96) "環 (圖論)")，求出該環的起點與長度的算法
>
> 如果有限狀態機、迭代函數或者鍊表上存在環，那麼在某個環上以不同速度前進的2個[指針](https://zh.wikipedia.org/wiki/%E6%8C%87%E9%92%88_(%E4%BF%A1%E6%81%AF%E5%AD%A6) "指針 (信息學)")必定會在某個時刻相遇。同時顯然地，如果從同一個起點(即使這個起點不在某個環上)同時開始以不同速度前進的2個指針最終相遇，那麼可以判定存在一個環，且可以求出2者相遇處所在的環的起點與長度。

## cycle detection

快慢指針若相遇則有cycle，反之(快指針走到底)則無

## cycle length

其中一個指針於相遇點停下(一定在cycle 中)，另一個指針走一圈算距離。

## cycle start

其中一個指針停在相遇點，另一個指針回到起點，此時兩指針的距離會是cycle 長度的整數倍。兩指針一起以相同的速度往下走，再次相遇的點即為cycle 的起點。
