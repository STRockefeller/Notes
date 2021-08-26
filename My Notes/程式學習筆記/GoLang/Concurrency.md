# Go Concurrency

Reference:



## Review with Questions

* 試著簡短說明Concurrency。 [Ans](#What is Concurrency?)
* 如何讓其他的go routines回傳訊息到main function?  [Ans](#Channel)



## Abstract

終於到重點了，`Go`對我來說最大的特色莫過於他身為Concurrent Language這一點。

筆記的內容中我會試著拿`Go`和過去我較熟悉的非同步寫法做比較(主要是`C#`和`Dart`)



## What is Concurrency?

先來說文解字。

Concurrency 通常會被拿來和 Parallelism 做比較，以下節錄自[StackOverFlow](https://stackoverflow.com/questions/1050222/what-is-the-difference-between-concurrency-and-parallelism)，是我覺得比較精闢的解釋

> **Concurrency** is when two or more tasks can start, run, and complete in overlapping time **periods**. It doesn't necessarily mean they'll ever both be running **at the same instant**. For example, *multitasking* on a single-core machine.
>
> **Parallelism** is when tasks *literally* run at the same time, e.g., on a multicore processor.



以下說明一下我理解的部分，或許不是很準確，有錯再來修正。

* Concurrency和單執行緒/多執行緒並沒有關係，以`Go`來說，可以透過`runtime.GOMAXPROCS(n)`選擇使用的核心數，但即便選擇數量為1，同樣可以執行concurrent function。`go routine`會去分配執行時間，概念應該和`Dart`那種單執行緒的非同步做法類似(?)



## How to Use?

很簡單`go func()`即可



例如

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	go testAsync()
	fmt.Print("main:")
	fmt.Println(time.Now())
}

func testAsync() {
	fmt.Print("test:")
	fmt.Println(time.Now())
}
```

結果

```
PS C:\Users\admin\Desktop\Go> go run hello.go
main:test:2021-08-02 10:30:06.8633153 +0800 CST m=+0.010488101
2021-08-02 10:30:06.8633153 +0800 CST m=+0.010488101
```

(結果跟我想的有一點不一樣...不過這樣反而可以恨清楚的看到兩個function交錯執行的樣子)



**注意:在`Go`中，Concurrent function 和一般的function是一樣的，區別只在於呼叫的時候使用`go`，並不會有`Future`或是`Task`這種回傳型別**



**注意: `main()`執行結束後其他`func`就不會繼續執行了**

例如

```go\
package main

import (
	"fmt"
)

func main() {
	go testAsync()
}

func testAsync() {
	fmt.Println("Hello World!")
}
```

執行結果不會顯示任何內容

原因是`main()`先一步結束了

若改成

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	go testAsync()
	time.Sleep(time.Millisecond * 10)
}

func testAsync() {
	fmt.Println("Hello World!")
}
```

讓`main()`稍微等一下，就能跑出結果了

```
PS C:\Users\admin\Desktop\Go> go run hello.go
Hello World!
```



## Return Value

在測試Concurrency的時候發現，如果要傳入資料給`concurrent function`，只要按照一般的方式就可以順利進行，例如修改上例

```go
func main() {
	go testAsync("Hello World!")
	time.Sleep(time.Millisecond * 10)
}

func testAsync(str string) {
	fmt.Println(str)
}
```

但是如果要傳回`main()`就沒那麼簡單了，像是以下的寫法就**行不通**

```go
func main() {
	str:= go testAsync() // Compiler 報錯
	time.Sleep(time.Millisecond * 10)
}

func testAsync() string {
    return "Hello World!"
}
```

但是`go`好像又沒有`await`可以用，那該怎辦?

這時就輪到另一個`Go`的特色型別`Channel`出場了

### Channel

Channel 還可以**根據Buffer的有無**和**單/雙向**再做一些細分



####  Without Buffer

先考慮比較單純沒有Buffer的情況

首先Channel在`Go`裡面寫成`chan`通常會在後方寫上對應型別，例如`chan int`

使用`make()`初始化

使用箭頭`<-`將值放入Channel或從Channel取出

例如修改上例

```go
func main() {
	chs := make(chan string)
	go testAsync(chs)
	time.Sleep(time.Millisecond * 10)
	fmt.Print(<-chs) //Hello World
}

func testAsync(chs chan string) {
	chs <- "Hello World"
}
```



檢查一下值是不是真的被從Channel拿出去了

```go
func main() {
	chs := make(chan string)
	go testAsync(chs)
	time.Sleep(time.Millisecond * 10)
	fmt.Println(<-chs) //Hello World

	str := <-chs //fatal error
	fmt.Println(str)
}

func testAsync(chs chan string) {
	chs <- "Hello World"
}
```

```pow
PS C:\Users\admin\Desktop\Go> go run hello.go
Hello World
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [chan receive]:
main.main()
        C:/Users/admin/Desktop/Go/hello.go:14 +0x125
exit status 2
```



#### With Buffer

在初始化Channel的時候，給`make()`第二個參數可以決定緩衝區的大小

例如宣告`chs := make(chan string, 2)`則`chs`可以存入兩個`string`

```go
func main() {
	chs := make(chan string, 2)
	go testAsync(chs)
	time.Sleep(time.Millisecond * 10)
	fmt.Println(<-chs) //Hello World

	str := <-chs
	fmt.Println(str) //the second string
}

func testAsync(chs chan string) {
	chs <- "Hello World"
	chs <- "the second string"
}
```



更進階一點的測試，試著讓放入和取出同時進行

```go
func main() {
	channel := make(chan int, 10)
	go channelTestAsync(channel)
	for i := 0; i < 10; i++ {
		channel <- i
		fmt.Println("set ", i)
		time.Sleep(time.Millisecond * 100)
	}
	time.Sleep(time.Second * 1)
}

func channelTestAsync(channel chan int) {
	for true {
		fmt.Println("get ", <-channel)
		time.Sleep(time.Millisecond * 100)
	}
}
```

結果

```powershell
PS C:\Users\admin\Desktop\Go> go run hello.go
get  0
set  0
set  1
get  1
get  2
set  2
set  3
get  3
get  4
set  4
get  5
set  5
set  6
get  6
set  7
get  7
get  8
set  8
get  9
set  9
```

???怎麼有時候是先get?

還是說其實順序是`channel <- i`-->`fmt.Println("get ", <-channel)`-->`fmt.Println("set ", i)`



繼續測試，看上面的結果，雖然給了Channel緩衝區10但重頭到尾都是放一個取一個，這次不給他緩衝區試試

改`channel := make(chan int)`，結果和上次一樣。



接著讓放入的速度加快

```go
func main() {
	channel := make(chan int)
	go channelTestAsync(channel)
	for i := 0; i < 10; i++ {
		channel <- i
		fmt.Println("set ", i)
		time.Sleep(time.Millisecond * 10)
	}
	time.Sleep(time.Second * 1)
}

func channelTestAsync(channel chan int) {
	for true {
		fmt.Println("get ", <-channel)
		time.Sleep(time.Millisecond * 100)
	}
}
```

結果和先前是一樣的，這有點出乎我的意料，原本以為會因為channel的緩衝區不足而跳錯誤。

-->緩衝區不足的情況下，只要有人持續取出，**放入者就會等待取出後才再次放入**

若無人取出但又持續放入，則會發生**放入者一直在等待取出**的panic(注意**不是**緩衝區被塞爆所導致的)

把取出的部分刪除只留下放入

```go
func main() {
	channel := make(chan int)
	for i := 0; i < 10; i++ {
		channel <- i
		fmt.Println("set ", i)
		time.Sleep(time.Millisecond * 10)
	}
	time.Sleep(time.Second * 1)
}
```

結果

```powershell
PS C:\Users\admin\Desktop\Go> go run hello.go
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [chan send]:
main.main()
        C:/Users/admin/Desktop/Go/hello.go:12 +0x73
exit status 2
```





給剛剛的測試程式加更多的緩衝區

```go
func main() {
	channel := make(chan int, 10)
	go channelTestAsync(channel)
	for i := 0; i < 10; i++ {
		channel <- i
		fmt.Println("set ", i)
		time.Sleep(time.Millisecond * 10)
	}
	time.Sleep(time.Second * 1)
}

func channelTestAsync(channel chan int) {
	for true {
		fmt.Println("get ", <-channel)
		time.Sleep(time.Millisecond * 100)
	}
}
```

這次應該要可以看出放入速度加快的樣子了

```powershell
PS C:\Users\admin\Desktop\Go> go run hello.go
set  0
get  0
set  1
set  2
set  3
set  4
set  5
set  6
set  7
set  8
set  9
get  1
get  2
get  3
get  4
get  5
get  6
get  7
get  8
get  9
```

這次和預想的差不多



改個條件，變成取出比放入快，先猜會和最初一樣快的結果相同

結果和猜想的一樣，**目前看起來只要放入和取出的動作都在進行，`Go`在執行的時候就會有類似"搓合"的動作，沒有緩衝區可以利用的話，快的一邊會等待慢的那一邊，而不會報錯。**



#### Close Channel

Channel也可以使用 for range 取出 但要注意對channel 進行Close動作

例如

```go
package main

import (
	"fmt"
)

func main() {
	ch := make(chan int)
	go func() {
		for i := range ch {
			fmt.Println(i)
		}
		fmt.Println("Done")
	}()
	for i := 0; i < 10; i++ {
		ch <- i
	}
}
```

執行結果

```
0
1
2
3
4
5
6
7
8
9
```

可以注意到 goroutine的`fmt.Println("Done")`並沒有被執行

因為for loop還在等待channel被放入新的物件再將其取出。(此時main執行續跑完所以程式結束)

如果我們強迫main等待goroutine

```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	ch := make(chan int)
	wg := sync.WaitGroup{}
	wg.Add(1)
	go func() {defer wg.Done()
		for i := range ch {
			fmt.Println(i)
		}
		fmt.Println("Done")
	}()
	for i := 0; i < 10; i++ {
		ch <- i
	}
	wg.Wait()
}
```

執行結果

```powershell
0
1
2
3
4
5
6
7
8
9
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [semacquire]:
sync.runtime_Semacquire(0xc00009af58)
	/usr/local/go-faketime/src/runtime/sema.go:56 +0x25
sync.(*WaitGroup).Wait(0x60)
	/usr/local/go-faketime/src/sync/waitgroup.go:130 +0x71
main.main()
	/tmp/sandbox3150108899/prog.go:21 +0xd5

goroutine 18 [chan receive]:
main.main.func1()
	/tmp/sandbox3150108899/prog.go:13 +0xb7
created by main.main
	/tmp/sandbox3150108899/prog.go:12 +0x9f

```

使用`close()`方法將用完的channel關閉，取出方才不會一直等在那邊，go routine 也可以正常結束了

```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	ch := make(chan int)
	wg := sync.WaitGroup{}
	wg.Add(1)
	go func() {defer wg.Done()
		for i := range ch {
			fmt.Println(i)
		}
		fmt.Println("Done")
	}()
	for i := 0; i < 10; i++ {
		ch <- i
	}
	close(ch)
	wg.Wait()
}
```

執行結果

```
0
1
2
3
4
5
6
7
8
9
Done
```







## Sync

很多時候主執行緒等待非同步方法完成才能繼續進行下去，所以`C#` `Dart` 在使用非同步的時候才會大量使用`await`關鍵字

`Go`並沒有`await`但是卻有類似作用的東西，就是`sync.WaitGroup`



### sync.WaitGroup

顧名思義，這是等待**多個**go routines的作法，比起`await`更類似於`Dart`的`Future.wait()`或者`C#`的`Task.WhenAll()`

使用時我們會先宣告一個`sync.WaitGroup`物件(我看網路上很多人的寫法會把這個變數命名為`wg`可能是go的編寫慣例吧)

```go
func main() {
	wg := sync.WaitGroup{}
	fmt.Printf("%T", wg) // sync.WaitGroup
	fmt.Println("\r\n", wg) //{{} [0 0 0]}
}
```

接著將要等待的內容加進去，並且把`wg`物件傳入要等待的go routines

```go
func main() {
	wg := sync.WaitGroup{}
	fmt.Println("初始化")
	fmt.Println(wg) //{{} [0 0 0]}
	wg.Add(2)
	fmt.Println("Add(2)之後")
	fmt.Println(wg) //{{} [0 2 0]}
	go waitMeAsync(&wg)
	go waitMeAsync2(&wg)
	fmt.Println("傳入go routines之後")
	fmt.Println(wg) //{{} [0 2 0]}
	wg.Wait()
	fmt.Println("wait之後")
	fmt.Println(wg) //{{} [0 0 0]}
}

func waitMeAsync(wg *sync.WaitGroup) {
	time.Sleep(time.Millisecond * 100)
	wg.Done()
}

func waitMeAsync2(wg *sync.WaitGroup) {
	time.Sleep(time.Millisecond * 200)
	wg.Done()
}
```

以下說明節錄自[ITHELP](https://ithelp.ithome.com.tw/articles/10242268)

> WaitGroup拿`計數器(Counter)`來當作任務數量，若counter `< 0`會發生`panic`。
>
> - WaitGroup.**Add(n)**：計數器`+n`
> - WaitGroup.**Done()**：任務完成，從計數器中`減去1`，可搭配`defer`使用
> - WaitGroup.**Wait()**：阻塞(Block)住，直到計數器`歸0`
>
> 如果計數器大於線程數就會發生`死結(Deadlock)`。



### Race Condition

想起首次聽到這個詞的時候我還在學RS Flip-Flop...

狀況演示，程式碼來自[ITHELP](https://ithelp.ithome.com.tw/articles/10242268)

```go
var count = 0

func main() {
	for i := 0; i < 10000; i++ {
		go race()
	}
	time.Sleep(time.Millisecond * 100)
	fmt.Println(count) //9616 每次執行都不一樣但都不到1000
}

func race() {
	count++
}
```



簡單來說就是非同步程式同時使用同一個物件會導致的意外情況，以前在寫`C#`的時候也有遇到過幾次，在`Go`的作法也是一樣的==>**鎖起來**就好

不過在把它鎖起來之前，我先來試試其他作法

使用剛學到的`sync.WaitGroup`

```go
var count = 0

func main() {
	wg := sync.WaitGroup{}
	for i := 0; i < 10000; i++ {
		wg.Add(1)
		go race(&wg)
	}
	//time.Sleep(time.Millisecond * 100)
	wg.Wait()
	fmt.Println(count) //9306
}

func race(wg *sync.WaitGroup) {
	defer wg.Done()
	count++
}
```

這個做法是可以確保`race()`執行了1000次，但仍無法改變race情況的發生。畢竟原本的100ms也夠執行1000次了。



### sync.Mutex

Mutex 是 Mutual exclusion 的縮寫

在`C#`中，一般會宣告一個物件，專門拿來鎖住

```C#
private readonly object lockObj = new object();
public async Task DoSomething()
{
    Lock(lockobj)
    {
        //...
    }
}
```

在`Go`的做法也差不多，不過物件不能隨便宣告，必須使用`sync.Mutex`型別

拿上例做修改

```go
var count = 0
var lock sync.Mutex

func main() {
	wg := sync.WaitGroup{}
	for i := 0; i < 10000; i++ {
		wg.Add(1)
		go race(&wg)
	}
	wg.Wait()
	fmt.Println(count) //1000
}

func race(wg *sync.WaitGroup) {
	defer wg.Done()
	lock.Lock()
	count++
	lock.Unlock()
}
```

## Panic

程式出錯的情況在`Go`裡面稱為Panic，不論是`main func`還是`Concurrent func`只要出錯了都會結束程式。