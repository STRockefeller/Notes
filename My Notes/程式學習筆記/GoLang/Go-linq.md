# LinQ

我只能說，這真是一個大大的驚喜

github https://github.com/ahmetb/go-linq

document https://pkg.go.dev/github.com/ahmetb/go-linq

一個實現類似於.net linq的go套件，稍微試用了一下，基本上該有的功能都沒少，但是大量地使用`interface{}`，導致強型別的好處蕩然無存，下指令的過程中必須隨時留意目前的型別，另外就是`go`沒有簡潔的lambda expression 所以程式碼看起來會有點凌亂。



找了一個kata做測試

```go
package main

import (
	"fmt"

	. "github.com/ahmetb/go-linq/v3"
)

func HighestRank(nums []int) int {
	//nums.GroupBy(n => n);
	group := From(nums).GroupBy(
		func(i interface{}) interface{} {
			return i.(int)
		}, func(i interface{}) interface{} {
			return i.(int)
		})
	//group.Select(g => g.Count()).Max();
	max := group.Select(func(g interface{}) interface{} {
		return len(g.(Group).Group)
	}).Max().(int)

	//group.Where(g => g.Count() == max).Select(g => g.First()).Max();

	res := group.Where(func(g interface{}) bool {
		return len(g.(Group).Group) == max
	}).Select(func(g interface{}) interface{} {
		return g.(Group).Key
	}).Max()
	return res.(int)
}

func main() {
	fmt.Println(HighestRank([]int{12, 10, 8, 12, 7, 6, 4, 10, 12}))
}
```



可惜的是 codewars 似乎不接受這個套件的引用 (cannot find package) ，不過在本地或者playground都可以正常執行。

備註: 有些方法去github1s看比較好理解