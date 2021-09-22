# Composition

Reference:

[ITHELP](https://ithelp.ithome.com.tw/articles/10217359)



## Abstract

因為`Go`並不是典型的OOP語言，沒有`繼承`這個概念，所以特別拿這個主題出來講一下



關於`組合`和`繼承`之間的優劣，更多的是牽扯到設計模式，這篇筆記不會多提，有機會另外紀錄。

目前大部分的觀點認為多數情況下**耦合度較低**的`組合`會優於`繼承`

對我來說的話目前較熟悉`繼承`的做法，剛好趁此機會熟悉`組合`的思維邏輯



## Example

寵物

```go
type Pet struct {
	Name string
}
```



貓是寵物(組合)

```go
type Cat struct {
	Pet *Pet
}
```



貓會打滾(方法)

```go
func (cat Cat) Roll() {
	fmt.Println("打滾中~")
}
```



公主是貓會打滾，並且有個寵物名

```go
func main() {
	princess := Cat{&Pet{"公主"}}
	fmt.Println(princess.Pet.Name) //公主
	princess.Roll() //打滾中~
}
```



## Embedding

組合的簡化寫法，拿上例修改

在`Cat`宣告`Pet`屬性的時候可以不用給變數名稱

```go
type Cat struct {
	*Pet
}
```

這個時候呼叫他的寵物名字就變成`Cat.Name`

```go
func main() {
	princess := Cat{&Pet{"公主"}}
	fmt.Println(princess.Name) //公主
	princess.Roll() //打滾中~
}
```



### Embedding Method

向前面的貓咪打滾方法這種並沒有用到自身物件的方法，也可以用內嵌的方式簡化

```go
func (*Cat) Roll() {
	fmt.Println("打滾中~")
}
```





## Method Composition

修改最初的例子，給寵物加上陪他玩的method

```go
package main

import "fmt"

type Pet struct {
	Name string
}
type Cat struct {
	*Pet
}

func (*Cat) Roll() {
	fmt.Println("打滾中~")
}

func (*Pet) Play() {
	fmt.Println("和寵物玩")
}

func main() {
	princess := Cat{&Pet{"公主"}}
	fmt.Println(princess.Pet.Name) //公主
	princess.Roll() //打滾中~
	princess.Play() //和寵物玩
}
```



這時如果想讓`Cat` override(譬喻而已，`Go`沒有這種東西) `Pet.Play()` method，就只要再次宣告方法就可以了

```go
package main

import "fmt"

type Pet struct {
	Name string
}
type Cat struct {
	*Pet
}

func (*Cat) Roll() {
	fmt.Println("打滾中~")
}

func (*Pet) Play() {
	fmt.Println("和寵物玩")
}

func (*Cat) Play() {
	fmt.Println("和貓咪玩")
}

func main() {
	princess := Cat{&Pet{"公主"}}
	fmt.Println(princess.Pet.Name) //公主
	princess.Roll() //打滾中~
	princess.Play() //和貓咪玩
}

```



