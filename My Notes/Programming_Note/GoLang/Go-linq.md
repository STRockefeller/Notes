# LinQ

我只能說，這真是一個大大的驚喜

github https://github.com/ahmetb/go-linq

document https://pkg.go.dev/github.com/ahmetb/go-linq



經過一翻測試，大致上有一些理解，這邊會一邊以原本的linq作為比較依據分析一些心得

### 使用

比如我有一個struct

```C#
public struct User{
    public string ID;
    public string Name;
    public string Role;
}
```

```go
type User struct{
    ID string
    Name string
    Role string
}
```

想要從集合中找到 ID == "ABC" 的User並且回傳Name

```C#
List<User> users = new List<User>();
List<string> res = users.Where(user=>user.ID=="ABC").Select(user=>user.Name).ToList();
```

可以寫成

```go
var users []User
var res []string
From(users).Where(func(user interface{})bool{return user.(User).ID=="ABC"}).
Select(func(user interface{})interface{}{return user.(User).Name}).ToSlice()
```

當然如果每次都要寫那麼多`interface{}`然後一直轉型，那我寧可不要linq

所以官方還有提供一種類似於泛型的做法

```go
var users []User
var res []string
From(users).WhereT(func(user User)bool{return user.ID=="ABC"}).
SelectT(func(user User)string{return user.Name}).ToSlice()
```

雖然依然比不上極致簡化的lambda expression，但已經好很多了



那為何還有第一種寫法存在的必要?官方的註解這樣寫

> NOTE: Where has better performance than WhereT.





### 關於Query

不同於C#的linq都屬於`IEnumerable`的方法在Go-linq中所有的方法都在`Query`這種結構底下

拿`Where`來看，linq起於`IEnumerable`並終於`IEnumerable`

```C#
public static IEnumerable<TSource> Where<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate);
```

對於 go-linq來說，則是起於`Query`終於`Query`

```go
func (q Query) Where(predicate func(interface{}) bool) Query

func (q Query) WhereT(predicateFn interface{}) Query
```



先來看看`IEnumerable`

```C#
    public interface IEnumerable
    {
        IEnumerator GetEnumerator();
    }

	public interface IEnumerator
    {
        object Current { get; }
        bool MoveNext();
        void Reset();
    }
```

再來看看`Query`

```go
type Query struct {
	Iterate func() Iterator
}

type Iterator func() (item interface{}, ok bool)
```

微妙的有點像又不太一樣



對於使用上來說，C#的集合大多時做了IEnumerable所以可以直接linq，linq後的`IEnumerable<T>`，基本上也能直接拿來使用

go-linq沒辦法直接使用，必須先把集合變成`Query`(透過`From()`)運算結束後再把他們變回集合



### 缺陷

自己使用上感覺比較可惜的部分



#### lambda expression

linq會大量使用到方法的傳遞，總是把方法完整地寫出來反而會造成閱讀上的困難，在C#中這點巧妙地被委派的極致簡化型態lambda expression給克服，可惜的是golang目前沒有類似的作法，導致敘述看起來仍略顯冗長。



#### Query

上面有提到過，使用前後都要進行`Query`和集合型別的轉換並不是很方便

另外還有一個衍伸出來的缺點，就是行別判別。以C#來說，linq到中途也能查看方法的回傳型別，複雜的linq更是時常會透過這個手段檢查是不是與自己的設想相符。go-linq的方法搭多都是回傳`Query`。



#### 在Codewars 無法使用

codewars 似乎不接受這個套件的引用 (cannot find package) ，不過在本地或者playground都可以正常執行。





### 執行效率

使用BenchMark做了測試，先說結論，**效率很差**，在講究效率的系統中不要考慮使用linq



詳細

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

