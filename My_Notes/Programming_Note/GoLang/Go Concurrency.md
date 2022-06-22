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



#### Check if the channel is closed

我們可以在讀取數值時順便確認channel是否已經關閉

```go
value, OK = <- ch // 當OK==false時代表通道已經被關閉了，此時value會得到zero value
```



#### channel 間傳遞資料

```go
chan1 <- <- chan2
```





#### Select

> The `select` statement lets a goroutine wait on multiple communication operations.
>
> A `select` blocks until one of its cases can run, then it executes that case. It chooses one at random if multiple are ready.

a tour of go example

```go
package main

import "fmt"

func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		select {
		case c <- x:
			x, y = y, x+y
		case <-quit:
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c)
		}
		quit <- 0
	}()
	fibonacci(c, quit)
}
```

result

```
0
1
1
2
3
5
8
13
21
34
quit
```



單看範例還是有點難懂，這邊說明一下目前觀察到的特點

* `select-case`是`channel`專用的語法，不會有`channel`以外的東西出現在這裡
* 不同於`switch-case`，`select-case`中的`case`不是"我在OO情況下要做XX事"而是"我先做OO事再接著做XX事"的感覺
* `select`會**隨機**挑選一個**做得到**的`case`進行(例入往channel放入東西，或是從非空的channel取出東西)
* `for`搭配`select`事很常見的用法，如上例



以下內容部分節錄自[AppleBoy的文章](https://blog.wu-boy.com/2019/11/four-tips-with-select-in-golang/)，補充一些關於Select的特點

##### Random Select

同一個 channel 在 select 會隨機選取，底下看個例子:

```go
package main

import "fmt"

func main() {
    ch := make(chan int, 1)

    ch <- 1
    select {
    case <-ch:
        fmt.Println("random 01")
    case <-ch:
        fmt.Println("random 02")
    }
}
```

執行後會發現有時候拿到 `random 01` 有時候拿到 `random 02`，這就是 select 的特性之一，case 是隨機選取，所以當 select 有兩個 channel 以上時，如果同時對全部 channel 送資料，則會隨機選取到不同的 Channel。而上面有提到另一個特性『假設沒有送 value 進去 Channel 就會造成 panic』，拿上面例子來改:

```go
func main() {
    ch := make(chan int, 1)

    select {
    case <-ch:
        fmt.Println("random 01")
    case <-ch:
        fmt.Println("random 02")
    }
}
```

執行後會發現變成 deadlock，造成 main 主程式爆炸，這時候可以直接用 `default` 方式解決此問題:

```go
func main() {
    ch := make(chan int, 1)

    select {
    case <-ch:
        fmt.Println("random 01")
    case <-ch:
        fmt.Println("random 02")
    default:
        fmt.Println("exit")
    }
}
```

主程式 main 就不會因為讀不到 channel value 造成整個程式 deadlock。



##### Timeout

用 select 讀取 channel 時，一定會實作超過一定時間後就做其他事情，而不是一直 blocking 在 select 內。底下是簡單的例子:

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    timeout := make(chan bool, 1)
    go func() {
        time.Sleep(2 * time.Second)
        timeout <- true
    }()
    ch := make(chan int)
    select {
    case <-ch:
    case <-timeout:
        fmt.Println("timeout 01")
    }
}
```

建立 timeout channel，讓其他地方可以透過 trigger timeout channel 達到讓 select 執行結束，也或者有另一個寫法是透握 `time.After` 機制

```go
    select {
    case <-ch:
    case <-timeout:
        fmt.Println("timeout 01")
    case <-time.After(time.Second * 1):
        fmt.Println("timeout 02")
    }
```

可以注意 `time.After` 是回傳 `chan time.Time`，所以執行 select 超過一秒時，就會輸出 **timeout 02**。



##### 檢查 channel 是否已滿

```go
package main

import (
    "fmt"
)

func main() {
    ch := make(chan int, 1)
    ch <- 1
    select {
    case ch <- 2:
        fmt.Println("channel value is", <-ch)
        fmt.Println("channel value is", <-ch)
    default:
        fmt.Println("channel blocking")
    }
}
```

Select 特性的一種利用方式

如果`ch`已滿，執行到`select`的時候會因為`ch`滿了所以無法再丟數值進去，轉而去執行`default`的內容



##### Select for loop



用於處理多個Channel的常見做法

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    i := 0
    ch := make(chan string, 0)
    defer func() {
        close(ch)
    }()

    go func() {
    LOOP:
        for {
            time.Sleep(1 * time.Second)
            fmt.Println(time.Now().Unix())
            i++

            select {
            case m := <-ch:
                println(m)
                break LOOP
            default:
            }
        }
    }()

    time.Sleep(time.Second * 4)
    ch <- "stop"
}
```

使用時要注意離開迴圈的時機點。

可以設定成符合特定條件(想做的都做完了/ERROR/TIMEOUT...等等)，利用`break`脫離loop或直接`return`



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



### Timeout

#### Don't do this

剛剛來的天才想法，但試了一下馬上發現行不通

大概像這樣，假如我想等一個go routine

```go
wg:=sync.WaitGroup{}
wg.Add(1)
// go routine
go func(){
    //...
    wg.Done()
}()

// timeout
go func(){
    time.Sleep(3000)
    wg.Done()
}()

wg.Wait()
```

實際執行的時候會發生negative wait group count 的 panic

#### Do this

上面[Select](#Select)筆記有提到過了，不過既然又碰到了那就補充一下另一個做法

參考[Timeout for WaitGroup.Wait()](https://stackoverflow.com/questions/32840687/timeout-for-waitgroup-wait)

```golang
// waitTimeout waits for the waitgroup for the specified max timeout.
// Returns true if waiting timed out.
func waitTimeout(wg *sync.WaitGroup, timeout time.Duration) bool {
    c := make(chan struct{})
    go func() {
        defer close(c)
        wg.Wait()
    }()
    select {
    case <-c:
        return false // completed normally
    case <-time.After(timeout):
        return true // timed out
    }
}
```

Using it:

```golang
if waitTimeout(&wg, time.Second) {
    fmt.Println("Timed out waiting for wait group")
} else {
    fmt.Println("Wait group finished")
}
```

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



## errgroup

實用套件補充一下。 [godoc](https://pkg.go.dev/golang.org/x/sync/errgroup)

基本上算是針對error handle 加強的go routine

方法只有兩個 Go 和 Wait 

顧名思義

Go 就是以Concurrency 的方式執行方法，這個方法必須要回傳error

Wait 就...wait ，另外會吐一個前面 Go() 的**第一個** error出來



### 是否中斷執行

這算是errgroup比較貼心的地方，根據物件建立的方式不同，可以決定是否在出現error的時候中斷執行

```go
type Group struct {
	// contains filtered or unexported fields
}
```

> A Group is a collection of goroutines working on subtasks that are part of the same overall task.
>
> A zero Group is valid and does not cancel on error.



簡單來說不想中斷執行的話就寫成

```go
var g errgroup.Group
```

```go
g := errgroup.Group{}
```

```go
g := new(errgroup.Group)
```



想中斷的話就用這個方法

```go
func WithContext(ctx context.Context) (*Group, context.Context)
```



注意，即便不中斷執行，Wait()方法還是只會吐第一個error回來



## 補充

### 在golang玩async/await

[這個repo](https://github.com/Ksloveyuan/channelx)有實作，看起來滿完整的，可惜沒有支援go 1.18後的generic。