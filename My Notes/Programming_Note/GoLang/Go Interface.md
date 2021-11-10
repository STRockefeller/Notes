# Interface





## Abstract

目前看來`go`的interface和傳統意義上的interface似是而非



舉個例子

一個形狀介面，包含計算面積和邊長的方法，在其他程式語言長這樣

`C#`

```C#
public interface IShape
{
    int GetArea();
    int GetPerimeter();
}
public class Square:IShape
{
    public int Length {get; set;}
    public int GetArea() => Length*Length;
    public int GetPerimeter() => Length*4;
}
```

`dart`

```dart
class Shape { 
   int GetArea(){
     return 0;
   }
  int GetPerimeter(){
    return 0;
  }
}  
class Square implements Shape { 
  late int Length;
  int GetArea(){
     return Length*Length;
   }
  int GetPerimeter(){
    return Length*4;
  }
} 
```



在`go`裡面大概像這樣

```go
type IShape interface {
	GetArea() int
	GetPerimeter() int
}
type Square struct {
	Length int
}

func (s Square) GetArea() int {
	return s.Length * s.Length
}
func (s Square) GetPerimeter() int {
	return s.Length * 4
}
```



看起來差不多，但是細節有許多不同，下面一一道來



## Implemented implicitly

隱性實作，換句話說就是沒有所謂**繼承**的關鍵字

只要實作了相同方法簽章的`struct`都視為實作了該介面

**特別注意**: `go compiler`並不會強制一定要實作介面中的所有方法(不會報錯)，但是未完全實作介面的`struct`無法符合該介面的要求

例如(承上例)

```go
//...

//Rectangle 只有實作 GetPerimeter() int，沒有實作GetArea() int
//所以無法作為IShape使用
type Rectangle struct {
	height, width int
}

func (r Rectangle) GetPerimeter() int {
	return (r.height + r.width) * 2
}

func main() {
	sq := Square{10}
	rec := Rectangle{10, 20}
	fmt.Println(isShape(sq)) //true
    
    // ./prog.go:34:21: cannot use rec (type Rectangle) as type IShape in argument to isShape:
	// Rectangle does not implement IShape (missing GetArea method)
	fmt.Println(isShape(rec)) //panic
}

func isShape(s IShape) bool {
	return true
}
```





## The Value of Interfaces

在`go`中，是允許宣告符合某一介面的物件的，zero value 是 `nil`

例如(承上例)

```go
//...

func main() {
	var shape IShape
	fmt.Printf("%T\r\n",shape) //<nil>
	fmt.Println(shape)         //<nil>
}
```

```go
func main() {
	var shape IShape
	shape = Square{10}
	fmt.Printf("%T\r\n", shape) // main.Square
	fmt.Println(shape)          // {10}
}
```

目前是還看不出這個設計的好處，拿同一個變數名稱實作不同的`struct`算好處嗎(?)



不知道為什麼也可以存指標

```go
func main() {
	var shape IShape            //寫成 var shape *IShape 反而會報錯，因為在go中並沒有指向interface的指標
	shape = &Square{10}
	fmt.Printf("%T\r\n", shape) // *main.Square
	fmt.Println(shape)          // &{10}
}
```

事實證明，以interface宣告的物件可以傳入**實作了該interface的struct**或**指向"interface的struct"的指標**

另外，如果方法是以指標的方式宣告，則只有傳入**指向"interface的struct"的指標**才可以正常呼叫





## Empty interface



### As an Object



```go
func main() {
	var a interface{}
	a = 123
	fmt.Println(a, reflect.TypeOf(a))
	a = "hi"
	fmt.Println(a, reflect.TypeOf(a))
	a = true
	fmt.Println(a, reflect.TypeOf(a))
}

/* result:
123 int
hi string
true bool
*/
```



### Type assertions



```go
package main

import "fmt"

func main() {
	var i interface{} = "hello"

	s := i.(string) 
	fmt.Println(s) // hello

	s, ok := i.(string)
	fmt.Println(s, ok) // hello true

	f, ok := i.(float64)
	fmt.Println(f, ok) // 0 false

	f = i.(float64) // panic
	fmt.Println(f)
}
```



```go
package main

import "fmt"

func do(i interface{}) {
	switch v := i.(type) {
	case int:
		fmt.Printf("Twice %v is %v\n", v, v*2)
	case string:
		fmt.Printf("%q is %v bytes long\n", v, len(v))
	default:
		fmt.Printf("I don't know about type %T!\n", v)
	}
}

func main() {
	do(21)
	do("hello")
	do(true)
}
```

