# Interface





## Abstract

目前看來`go`的interface和傳統意義上的interface似是而非



舉個例子

一個形狀介面，包含計算面積和邊長的方法，在其他程式語言長這樣

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
     return 0;
   }
  int GetPerimeter(){
    return 0;
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



## 隱性實作



## 作為Object



