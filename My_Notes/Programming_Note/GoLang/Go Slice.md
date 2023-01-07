# Slice

#golang

Reference:
[ITHELP](https://ithelp.ithome.com.tw/articles/10237400)

[tutorialspoint](https://www.tutorialspoint.com/go/go_slice.htm)

[medim](https://riteeksrivastava.medium.com/how-slices-internally-work-in-golang-a47fcb5d42ce)

## Abstract

`Slice`算是`Go`特有的型別，因此特別寫一篇筆記紀錄之

因為免不了比較，所以順便把`Go`的`Array`一起介紹了。

## Array

> Arrays in golang are a value type, means whenever you assign an array to a new variable then the copy of the original array is assigned to the new variable.

強調`Go`的`Array`是value type，其實就是變相比較`Slice`是reference  type (和`C#`的`List`一樣)

其他基本上沒甚麼特別的，快速帶過

宣告方法是`var variable_name [SIZE] variable_type`，`go`一樣會賦予初始值

```go
func main() {
	var intArray [5] int
	fmt.Println(intArray) //[0 0 0 0 0]
}
```

`Print`方法可以直些顯示陣列倒是滿方便的。

給初始值

```go
func main() {
	intArray := [5]int{1, 2, 3, 4, 5}
	fmt.Println(intArray) //[1 2 3 4 5]
}
```

也可以分行

```go
func main() {
	intArray := [5]int{
		1,
		2,
		3,
		4,
		5}
	fmt.Println(intArray) //[1 2 3 4 5]
}
```

有給初始值的情況下，可以讓`Go`幫你判斷`Array`大小

```go
func main() {
	intArray := [...]int{1, 2, 3, 4, 5}
	fmt.Println(intArray) //[1 2 3 4 5]
}
```

多維陣列的宣告方式 `var variable_name [SIZE1][SIZE2]...[SIZEN] variable_type`

```go
func main() {
	var arr [5][5] int
	fmt.Println(arr) //[[0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0] [0 0 0 0 0]]
}
```

## Slice

`Slice`算是size比較有彈性的`Array`，我暫時找不到適合類比`Slice`的結構

在空間上`Slice`有一個預設容量和最大容量，也就是說在這段區間內`Slice`的大小是可變的

另外`Slice`還自帶指標，某些情況下是滿方便的。

以下`Slice`的屬性

1. 長度 `len` ，就是現在的長度
2. 容量 `cap` ，最大能容納的長度
3. 指針 `ptr`

### Declare

`Slice`的宣告方式

```go
var numbers []int /* a slice of unspecified size */
numbers := []int{0,0,0,0,0}
numbers = make([]int,5,5) /* a slice of length 5 and capacity 5*/
```

其中第一種作法`numbers`的初始值會是`nil`一般來說**不推薦**使用

直接從範例看吧

以下`Slice`我使用這個function做分析

```go
func testSlice(target []int) {
	fmt.Println("-----------------------------------------")
	fmt.Println(target)
	fmt.Print("length:")
	fmt.Println(len(target))
	fmt.Print("capacity:")
	fmt.Println(cap(target))
	fmt.Print("length==0?")
	fmt.Println(len(target) == 0)
	fmt.Print("target==nil?")
	fmt.Println(target == nil)
	fmt.Println("-----------------------------------------")
}
```

**首先宣告`Slice`並給予長度**

```go
	a := make([]int, 10)
	testSlice(a)
```

結果

```powershell
[0 0 0 0 0 0 0 0 0 0]
length:10
capacity:10
length==0?false
target==nil?false
```

除了`len`以外`cap`也一併被設定成10了

**設定 `len`:5、`cap`:10**

```go
	b := make([]int, 5, 10)
	testSlice(b)
```

結果

```powershell
[0 0 0 0 0]
length:5
capacity:10
length==0?false
target==nil?false
```

和預料一樣沒什麼特別的

**初始化一個空白的`Slice`**

```go
	var c = []int{} 
	testSlice(c)
```

結果

```powershell
[]
length:0
capacity:0
length==0?true
target==nil?false
```

和預料一樣沒什麼特別的

**宣告但沒有初始化**

```go
	var d []int
	testSlice(d)
```

結果

```powershell
[]
length:0
capacity:0
length==0?true
target==nil?true
```

這個時候變數還是`nil`

**宣告並直接賦值**

```go
	e := []int{1,2,3} 
	testSlice(e)
```

結果

```pow
[1 2 3]
length:3
capacity:3
length==0?false
target==nil?false
```

和預料一樣沒什麼特別的

### Sub Slicing

直接看tutorialspoint的範例

```go
package main

import "fmt"

func main() {
   /* create a slice */
   numbers := []int{0,1,2,3,4,5,6,7,8}   
   printSlice(numbers)
   
   /* print the original slice */
   fmt.Println("numbers ==", numbers)
   
   /* print the sub slice starting from index 1(included) to index 4(excluded)*/
   fmt.Println("numbers[1:4] ==", numbers[1:4])
   
   /* missing lower bound implies 0*/
   fmt.Println("numbers[:3] ==", numbers[:3])
   
   /* missing upper bound implies len(s)*/
   fmt.Println("numbers[4:] ==", numbers[4:])
   
   numbers1 := make([]int,0,5)
   printSlice(numbers1)
   
   /* print the sub slice starting from index 0(included) to index 2(excluded) */
   number2 := numbers[:2]
   printSlice(number2)
   
   /* print the sub slice starting from index 2(included) to index 5(excluded) */
   number3 := numbers[2:5]
   printSlice(number3)
   
}
func printSlice(x []int){
   fmt.Printf("len = %d cap = %d slice = %v\n", len(x), cap(x),x)
}
```

結果

```powershell
len = 9 cap = 9 slice = [0 1 2 3 4 5 6 7 8]
numbers == [0 1 2 3 4 5 6 7 8]
numbers[1:4] == [1 2 3]
numbers[:3] == [0 1 2]
numbers[4:] == [4 5 6 7 8]
len = 0 cap = 5 slice = []
len = 2 cap = 9  slice = [0 1]
len = 3 cap = 7 slice = [2 3 4]
```

這個做法在`Array`也適用

**重點**

1. `numbers[1:4]` 會取得從`numbers[1]`到`numbers[3]`的內容

2. 上下限的默認值分別是`0`以及`len()`，例如

   ```go
   //len(sl)==10
   sl[:5] //等同於sl[0:5]
   sl[5:] //等同於sl[5:10]
   sl[:] //等同於sl[0:10]
   ```

### Reference Type

前面有提過了，`slice`屬於參考型別，這邊把一些比較容易忽略的地方重點提點一下

下面是[a tour of go的範例](https://tour.golang.org/moretypes/11)，充分展現了參考型別的特性

```go
package main

import "fmt"

func main() {
	s := []int{2, 3, 5, 7, 11, 13}
	printSlice(s) //len=6 cap=6 [2 3 5 7 11 13]

	// Slice the slice to give it zero length.
	s = s[:0]
	printSlice(s) //len=0 cap=6 []

	// Extend its length.
	s = s[:4]
	printSlice(s) //len=4 cap=6 [2 3 5 7]

	// Drop its first two values.
	s = s[2:]
	printSlice(s) //len=2 cap=4 [5 7]
}

func printSlice(s []int) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
```

第二步中我們把`s`變為長度為0的`slice`，但原`slice`的數值並沒有消失，只要將`s`擴大依然可以看到原來的數值

另外參考型別的`slice`即便傳入`defer func`中，執行階段也會以最新的`slice`執行(因為是傳址)

```go
func main() {
	arr := [3]int{1, 2, 3}
	sl := []int{1, 2, 3}

	fmt.Println("original arr=", arr)
	fmt.Println("original sl=", sl)

	defer fmt.Println("defer arr=", arr)
	defer fmt.Println("defer sl=", sl)

	arr[0] = 5
	sl[0] = 5

	fmt.Println("new arr=", arr)
	fmt.Println("new sl=", sl)
}
```

執行結果

```
original arr= [1 2 3]
original sl= [1 2 3]
new arr= [5 2 3]
new sl= [5 2 3]
defer sl= [5 2 3]
defer arr= [1 2 3]
```

### Append

`append()`方法可以擴增`Slice`的內容

有趣的是`append()`是可以將`Slice`擴充到超過`cap`設定的size的，

但是這麼做似乎容易出現一些奇奇怪怪的問題，所以一般還是會建議在宣告`Slice`的時候就給他足夠的`cap`

```go
func main() {
	s := []int{1, 2, 3}
	testSlice(s)
	s = append(s, 4)
	testSlice(s)
	s = append(s, 5, 6)
	testSlice(s)
}
```

```powershell
-----------------------------------------
[1 2 3]
length:3
capacity:3
length==0?false
target==nil?false
-----------------------------------------
-----------------------------------------
[1 2 3 4]
length:4
capacity:6
length==0?false
target==nil?false
-----------------------------------------
-----------------------------------------
[1 2 3 4 5 6]
length:6
capacity:6
length==0?false
target==nil?false
-----------------------------------------
```

幾次嘗試之後發現規則是只要`append`之後超出範圍，就會幫你把`cap`翻倍。
