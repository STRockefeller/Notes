# Generic



## Abstract

一直有傳說新版本的go可能會支援泛型，但至少現在還沒看到

這邊主要討論泛型的替代方案



## Interface

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



## Empty interface

BJ4

```go
func (T interface{})DoSomething{}
```



## reflect

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

