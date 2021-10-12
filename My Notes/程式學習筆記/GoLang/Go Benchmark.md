# Benchmark

實際上是go test的延伸，但還是分開來記錄比較合適。

參考:

https://sc0vu.medium.com/%E9%AB%98%E6%95%88%E8%83%BD-golang-%E7%A8%8B%E5%BC%8F-%E6%95%88%E8%83%BD%E6%AF%94%E8%BC%83-f84bb4fc390a

https://blog.wu-boy.com/2018/06/how-to-write-benchmark-in-go/



## How to use

**重點**

* 寫在測試檔案中(end with "test.go")

* import "testing" 

* 方法名稱為Benchmark開頭

* 傳入參數為 `*testing.B`

* 要測的東西寫在for迴圈中，初始化設定不想計算時間可以用`ResetTimer()`

  ```go
  unc BenchmarkLinq100(b *testing.B) {
  	s := getSlice(100)
  	b.ResetTimer()
  	for n := 0; n < b.N; n++ {
  		LinqTest(s)
  	}
  }
  ```

  





## Example

拿我測試 go-linq 效率的程式作為範例



main.go

```go
package main

import (
	linq "github.com/ahmetb/go-linq/v3"
)

func main() {
}

func LinqTest(s []int) int64 {
	return linq.From(s).Where(func(i interface{}) bool { return i.(int)%2 == 0 }).SumInts()
}

func LinqGenericTest(s []int) int64 {
	return linq.From(s).WhereT(func(i int) bool { return i%2 == 0 }).SumInts()
}

func ForLoopTest(s []int) int {
	var res int
	for _, i := range s {
		if i%2 == 0 {
			res += i
		}
	}
	return res
}
```



main_test.go 測試結果寫在上面了

```go
package main

import "testing"

func getSlice(limit int) []int {
	res := []int{}
	for i := 0; i < limit; i++ {
		res = append(res, i)
	}
	return res
}

// BenchmarkLinq100-8   	  342582	      3318 ns/op	    1000 B/op	     106 allocs/op
func BenchmarkLinq100(b *testing.B) {
	s := getSlice(100)
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		LinqTest(s)
	}
}

// BenchmarkLinq10000-8   	    3634	    310103 ns/op	   80201 B/op	   10006 allocs/op
func BenchmarkLinq10000(b *testing.B) {
	s := getSlice(10000)
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		LinqTest(s)
	}
}

// BenchmarkLinqGeneric100-8   	   43477	     27112 ns/op	    9296 B/op	     416 allocs/op
func BenchmarkLinqGeneric100(b *testing.B) {
	s := getSlice(100)
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		LinqGenericTest(s)
	}
}

// BenchmarkLinqGeneric10000-8   	     457	   2603440 ns/op	  880507 B/op	   40016 allocs/op
func BenchmarkLinqGeneric10000(b *testing.B) {
	s := getSlice(10000)
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		LinqGenericTest(s)
	}
}

// BenchmarkForLoop100-8   	23087000	        51.3 ns/op	       0 B/op	       0 allocs/op
func BenchmarkForLoop100(b *testing.B) {
	s := getSlice(100)
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		ForLoopTest(s)
	}
}

// BenchmarkForLoop10000-8   	  260864	      4554 ns/op	       0 B/op	       0 allocs/op
func BenchmarkForLoop10000(b *testing.B) {
	s := getSlice(10000)
	b.ResetTimer()
	for n := 0; n < b.N; n++ {
		ForLoopTest(s)
	}
}
```



結果比較

```powershell
PS D:\Rockefeller\Projects_Test\go_test_mcom_warehouse_query> go test -benchmem -run=^$ -bench .
goos: windows
goarch: amd64
pkg: ladidadida
BenchmarkLinq100-8                333081              3289 ns/op      1000 B/op
    106 allocs/op
BenchmarkLinq10000-8                3746            309461 ns/op     80200 B/op
  10006 allocs/op
BenchmarkLinqGeneric100-8          44326             26684 ns/op      9296 B/op
    416 allocs/op
BenchmarkLinqGeneric10000-8          462           2595004 ns/op    880500 B/op
  40016 allocs/op
BenchmarkForLoop100-8           22447192                51.3 ns/op
      0 B/op           0 allocs/op
BenchmarkForLoop10000-8           249924              4494 ns/op         0 B/op
      0 allocs/op
PASS
ok      ladidadida      7.926s
```

