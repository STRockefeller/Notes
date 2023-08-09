# Composition

tags: #golang #composition

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

## 補充

又稍微玩了一下這東西，有些心得補在這裡。

### 繼承/實作關係

假如我有一個interface和他的實作

```go
type IPet interface{
	Play()
}

type Pet struct{
	Name string
}

func(Pet)Play(){}
```

這時我再寫一個struct，並組合`Pet`進去

```go
type Cat struct{
	Pet
}
```

此時的`Cat`對Go的編譯器而言也算是實作了`IPet` interface

但是如果我把`Pet`欄位命名

```go
type Cat struct{
	Pet Pet
}
```

此時`Cat`就不再是`IPet`的實作了

### 方法的沿用

呈上例，並稍微回溯一下

```go
type IPet interface{
	Play()
}

type Pet struct{
	Name string
}

func(Pet)Play(){}

type Cat struct{
	Pet
}
```

根據前面的筆記內容，可以知道，如果要調用`Cat`裡面的`Pet`欄位的屬性或方法，可以使用略稱

```go
cat := Cat{}
name := cat.Name
cat.Play()
```

如果不縮寫的話會長這樣

```go
cat := Cat{}
name := cat.Pet.Name
cat.Pet.Play()
```

實際上我們在調用`Cat.Play()`的時候，編譯器會先找`Cat`結構有沒有定義`Play()`方法，沒有的話就會確認底下的未命名結構有沒有定義該方法

所以如果給`Cat`定義`Play()`方法後，`Cat.Play()`就會找到`Cat`的方法，進而造成了類似於override的行為，但其實`Cat.Pet.Play()`方法並沒有被覆蓋掉。

```go
type IPet interface{
	Play()
}

type Pet struct{
	Name string
}

func(Pet)Play(){} // 依然可以用cat.Pet.Play()呼叫他

type Cat struct{
	Pet
}

func(Cat)Play(){} // cat.Play() 會找到他
```

再回溯一下，假如`Cat`本身沒有實作`Play()`方法，但是組合了另一個含有`Play()`方法的結構，此時編譯器會顯示錯誤

```go
type IPet interface {
	Play()
}

type Pet struct {
	Name string
}

func (Pet) Play() {}

type Pet2 struct{}

func (Pet2) Play() {}

type Cat struct {
	Pet
	Pet2
}

// 此時 cat.Play()會顯示錯誤 ambiguous selector cat.Play
```

這種情況下如果`Cat`自己有`Play()`方法，那就會優先使用自己的方法而不會出錯，或者幫其中一個Field命名，也可以避免這個錯誤

### 擴充方法

算是一種應用方式

比如說如果我對`time`的`Add()`方法不滿意我可以改寫他

```go
import (
	"time"
)

type MyTime struct {
	time.Time
}

func (mt MyTime) Add(d time.Duration) {
    mt.Time.Add(d) // 可以call原方法，有點像其他語言的 base.Method()
	// ...
}
```
