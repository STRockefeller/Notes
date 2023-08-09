# Context

tags: #golang #context

<https://pkg.go.dev/context>

<https://draveness.me/golang/docs/part3-runtime/ch06-concurrency/golang-context/>

原本有考慮寫在concurrency裡面。不過仔細研究了下感覺能寫的東西應該不少，所以還是另記一篇。

題外話，這東西算是官方套件。

## Abstract

`context.Context` 目前(1.19)的定義如下

```go
type Context interface {
	Deadline() (deadline time.Time, ok bool)
	Done() <-chan struct{}
	Err() error
	Value(key any) any
}
```

只要實作完這四個method，你就是官方認證的context了，夠簡單吧。

從這四個方法就能簡單判斷context的功能了。

首先，它可以被定義一個壽命，或者說任務執行的時間限制(timeout 或 deadline)。

其次，當context結束(cancel 或 timeout)之後，可以從 Done() 吐出來的channel接到資訊。

再次，當context結束之後，可以從Err()看到異常結束的原因。

最後，他還能夾帶一些資訊，以key-value的形式儲存。

## Benifits

我們可以透過把同樣的context傳到各個goroutine裡面，來節省不必要的運算，例如任務完成或發生timeout時，所有的routine都可以從`Done()`接收到資訊，並及時停止動作。

## TODO or Background

預設的context有兩種，追本溯源來看都是一樣的

```go
// Background returns a non-nil, empty Context. It is never canceled, has no
// values, and has no deadline. It is typically used by the main function,
// initialization, and tests, and as the top-level Context for incoming
// requests.
func Background() Context {
	return background
}
```

```go
// TODO returns a non-nil, empty Context. Code should use context.TODO when
// it's unclear which Context to use or it is not yet available (because the
// surrounding function has not yet been extended to accept a Context
// parameter).
func TODO() Context {
	return todo
}
```

```go
var (
	background = new(emptyCtx)
	todo       = new(emptyCtx)
)
```

使用時機則是根據方法註解來決定。不過我看大多數的場合下用Background都不會有太大的問題。

## Cancel

稍微在同步的情況下寫了個示例

```go
func main() {
	ctx := context.Background()
	child, cancel := context.WithCancel(ctx)
	coc, _ := context.WithCancel(child)
	f := func(ctx context.Context) {
		select {
		case <-ctx.Done():
			fmt.Println("done")
		default:
			fmt.Println("end")
		}
		cancel()
	}
	f(child) // end
	f(child) // done
	f(ctx)   // end
	f(coc)   // done
}

```

可以看到當一個context結束時，包含自己本身以及其衍生的context都會一起結束。

timeout 和 deadline 也是類似的機制，就不多提了

## WithValue

透過context來傳值，老實說目前用下來感覺只有少數情況下適合使用，平常不會拿這個來傳值找自己麻煩。

* 儲存http request的header
* 存ID之類的東西來識別context的來歷
* 存logger
