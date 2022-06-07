# Generic



## Abstract

~~一直有傳說新版本的go可能會支援泛型，但至少現在還沒看到~~

1.18版本之後已經正式支援泛型了



```go
func Index[T comparable](s []T, x T) int
```



### Type

#### Constraints

官方的 https://pkg.go.dev/golang.org/x/exp/constraints

也可以自訂

例如

```go
type myType interface {
	string|int
}
```



#### Interface

注意不能跟Constraints混用

```go
type IDog interface{
    Bark()
}

type DogOrInterger{
    int|Dog // 這裡會出錯
}
```





### Generic Methods

https://stackoverflow.com/questions/71132124/how-to-solve-interface-method-must-have-no-type-parameters

method **不能** 直接使用泛型，這點真的很不方便，希望以後能支援



要改成先在interface定好，然後再使用例如

```go
type Linqable[T LinqableType] interface {
	Contains(T) bool
}

type Linq[T LinqableType] struct{}

func (Linq[T]) Contains() bool {
	return true
}

func test() {
	linq := Linq[int]{}
	linq.Contains()
}
```





### Substitutions

這邊主要討論泛型的替代方案 (for go vetsion < 1.18)



#### Interface

把想要加入泛型清單的東西都用type宣告，然後繼承某個interface。

```go
interface MyGenericType{
    func Type(){}
}
type MyInt int
func (m *MyInt)Type(){}
type MyString string
func (m *MyString)Type(){}

func (T MyGenericType)DoSomething{}
```



#### Empty interface

BJ4

```go
func (T interface{})DoSomething{}
```



#### reflect

這是在go-linq看到的

```go
func (q Query) ToSlice(v interface{}) {
	res := reflect.ValueOf(v)
	slice := reflect.Indirect(res)

	cap := slice.Cap()
	res.Elem().Set(slice.Slice(0, cap)) // make len(slice)==cap(slice) from now on

	next := q.Iterate()
	index := 0
	for item, ok := next(); ok; item, ok = next() {
		if index >= cap {
			slice, cap = grow(slice)
		}
		slice.Index(index).Set(reflect.ValueOf(item))
		index++
	}

	// reslice the len(res)==cap(res) actual res size
	res.Elem().Set(slice.Slice(0, index))
}
```

