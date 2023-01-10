# CodeWars:Number of integer partitions:20210909:Go

#problem_solve #codewars/4kyu #golang

[Reference](https://www.codewars.com/kata/546d5028ddbcbd4b8d001254)

## Question

An integer partition of n is a weakly decreasing list of positive integers which sum to n.

For example, there are 7 integer partitions of 5:

[5], [4,1], [3,2], [3,1,1], [2,2,1], [2,1,1,1], [1,1,1,1,1].

Write a function named partitions which returns the number of integer partitions of n. The function should be able to find the number of integer partitions of n for n as least as large as 100.

## My Solution

4 kyu 簡單粗暴的題目。

先來看範例

[5] 拆5

[4,1] 最右邊的1不能拆，所以拆4

[3,2] 拆2

[3,1,1]

...

整理出 weakly decreasing的規則:

1. 一次只拆1出來，例如5->4,1 3->2,1
2. 右側的數字可以拆就先拆，不行就往左找到可以拆的為止
3. 拆出來的數字往右補，但不會讓左方的數字比右方大，例如 3,1->2,2 3,2->2,2,1
4. 拆出來的數字1可以看成捕到最右方

題目要求回傳的是數量而非拆出來的ARRAY，所以不一定需要真的拆開他們。

```go
func Partitions(n int) int {
	count := 1
	partitions := []int{n}
	for len(partitions) != n {
		for i := len(partitions) - 1; i >= 0; i-- {
			switch partitions[i] {
			case 1:
				continue
			case 2:
				partitions[i] = 1
				partitions = append(partitions, 1)
				count++
			default:
				if i == len(partitions)-1 {
					partitions[i]--
					partitions = append(partitions, 1)
					count++
				} else {
					partitions[i]--
					partitions[i+1]++
					count++
				}
			}
		}
	}
	return count
}
```

然後發現`Partitions(10)`只回傳了17，和正確的42相差甚遠

原因是分析階段就理解錯誤了，或者說被5這個範例誤導了

以10為例，我的程式會這樣拆

```
10
9 1
8 2
8 1 1
7 2 1
7 1 1 1
6 2 1 1
6 1 1 1 1
5 2 1 1 1 
5 1 1 1 1 1
4 2 1 1 1 1
4 1 1 1 1 1 1
3 2 1 1 1 1 1
3 1 1 1 1 1 1 1
2 2 1 1 1 1 1 1
2 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 1 1
```

可以看到明顯漏了很多，例如拆成兩個數字的話，`[7 3]` `[6 4]`等也都符合條件

剛才列的第二條**右側的數字可以拆就先拆，不行就往左找到可以拆的為止**，明顯不符合實際情形

應該是**由左到右，可以拆(數字比隔壁大)就拆，拆掉的數字往右傳**

改完之後

```go
func Partitions(n int) int {
	count := 1
	partitions := []int{n}
	for len(partitions) != n {
		func() {
			for i := 0; i < len(partitions); i++ {
				switch {
				case i == len(partitions)-1:
					if partitions[i] == 1 {
						return
					}
					partitions[i]--
					partitions = append(partitions, 1)
					count++
					return
				case partitions[i] > partitions[i+1]:
					switch partitions[i] - partitions[i+1] {
					case 1:
						partitions[i]--
						partitions = append(partitions, 1)
						count++
						return
					default:
						partitions[i]--
						partitions[i+1]++
						count++
						return
					}
				}
			}
		}()
	}
	return count
}
```

`Partitions(10)`回傳了15，差更多了

```
10
9 1
8 2
7 3
6 4
5 5
5 4 1
4 4 1 1
4 3 2 1
3 3 2 1 1
3 2 2 1 1 1
2 2 2 1 1 1 1
2 2 1 1 1 1 1 1
2 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 1 1
```

有些之前有考慮到的狀況反而沒有找到，另外從5 4 1開始和預期的也不太一樣，本來以為會是5 4 1 ->5 3 2 ->4 4 2 -> 4 3 3

---

試著改用遞迴的想法去分析

以5為例

1. 首先[5]--->第一種

2. 再來左邊遞減考慮第一位為4的情況，只有[4 1]一種

3. 第一位為3，右邊總和要為2，把2拿去拆

   3.1. [2]-->第一種

   3.2. [1 1]-->第二種

4. 第一位為2，右邊總和是3，拆3

   4.1. [3]-->第一種，但是因為3>2，所以不符合條件

   4.2. [2 1]-->第二種

   4.3. [1 1 1]-->第三種

5. 第一位為1，後略，最後符合的只有[1 1 1 1 1]

我的方法需要的引數有:

1. 上限數，用來判斷超過前面的數則不計算次數
2. 總和數，要拿來拆的數
3. 總次數

```go
func Partitions(n int) int {
	var count int
	partitionRecursive(n, n, &count)
	return count
}

func partitionRecursive(limit, sum int, count *int) {
	for i := sum; i >= 1; i-- {
		if i > limit {
			continue
		}
		switch i {
		case sum:
			*count++
		case 1:
			*count++
		default:
			partitionRecursive(i, sum-i, count)
		}
	}
}
```

這次終於成功通關了，第二次測試跑了7590ms應該算是勉強沒超過時間吧。一次次的遞迴裡面又有迴圈造成時間複雜度激增。或許可以試試用go routine的方式呼叫遞迴，只要注意鎖好count應該可以讓執行時間縮短一些吧。

自己測試執行時間

50-->1.9963ms

100-->1.58935s

150-->太慢等不下去

使用 go routine 後

```go
var lock sync.Mutex

func Partitions2(n int) int {
	var count int
	wg := sync.WaitGroup{}
	wg.Add(1)
	go partitionRecursiveAsync(n, n, &count, &wg)
	wg.Wait()
	return count
}

func partitionRecursiveAsync(limit, sum int, count *int, wg *sync.WaitGroup) {
	defer wg.Done()
	for i := sum; i >= 1; i-- {
		if i > limit {
			continue
		}
		switch i {
		case sum:
			lock.Lock()
			*count++
			lock.Unlock()
		case 1:
			lock.Lock()
			*count++
			lock.Unlock()
		default:
			wg.Add(1)
			go partitionRecursiveAsync(i, sum-i, count, wg)
		}
	}
}
```

結果

50-->46.97ms

100-->等不下去

結果反而變得更慢了

這邊註明一下，執行時若附帶`-race`指令會顯示

```
race: limit on 8128 simultaneously alive goroutines is exceeded, dying
```

但結果是正確的，也就是說並沒有race的情形發生，並且她同時有超過八千個routines在執行。

**だけど**執行數度反而變慢了，原因應該在於每個go routine的執行時間都很短，但是數量太多，反而因為go routine本身的處理佔用了大量的時間。

## Better Solutions

## Solution 1

```go
package kata

func Partitions(n int) int {
  table := make([][]int, n+1)
  for i := 0; i <= n; i++ {
    table[i] = make([]int, n+1)
  }

  for i := 0; i <= n - 1; i++ {
    table[0][i] = 1
  }

  for i := 1; i <= n; i++ {
    for j := 1; j <= n-1; j++ {
      if i-j < 0 {
        table[i][j] = table[i][j-1]
        continue
      }
      table[i][j]=table[i][j-1]+table[i-j][j];
    }

  }


  return table[n][n-1] + 1
}
```

測試執行數度，輸入100執行了999.4us約為我的1000倍以上...

最初的迴圈用於初始化，會生成n個長度為n的[0,0,0,0...]slice並組成slice(就是`[][]int`)

第二個迴圈會把`table[0][1]`到`table[0][n-1]`都填入1

後面就看不懂了..

## Solution 2

```go
package kata

func p (sum, max int) int {
  if (sum == max) {
    return 1 + p(sum, max - 1)
  }
  if (max == 0 || sum < 0) {
    return 0
  }
  if (sum == 0 || max == 1) {
    return 1
  }
  
  return p(sum, max - 1) + p(sum - max, max)
}

func Partitions(n int) int {
  return p(n, n)
}
```

使用遞迴寫法的同志

執行時間

50-->997.6us

100--->965ms

比我的快了一些但是沒有第一個那麼誇張
