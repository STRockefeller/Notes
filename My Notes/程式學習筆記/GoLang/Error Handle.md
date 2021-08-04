# Error Handle

Reference:

[ITHELP](https://ithelp.ithome.com.tw/articles/10219879)



## Abstract

`Go`並**不是**使用`try`- `catch`這套來處理例外的，所以特別拿出來說明

> Go語言的錯誤處理則是屬於函式型，在程式設計上有以下特點:
>
> - 一個可能造成錯誤的函式，必須回傳一個錯誤型別。如果函式呼叫成功，就回傳 nil，反之回傳錯誤。
> - 在函式呼叫後，需要檢查錯誤，如果不是 nil，就必須進行錯誤處理。



## Example

節錄自[ITHELP](https://ithelp.ithome.com.tw/articles/10219879)

```go
// 定義一個除法函式
func div(dividend, divisor int) (int, error) {
    // 當除數為 0 時回傳錯誤
	if divisor == 0 {
		return 0, errors.New("Can't divided by zero")
	}
    // 執行成功時，錯誤為nil
	return dividend / divisor, nil
}

func main() {
    // 呼叫函式同時回傳結果與錯誤
	value, error := div(1, 0)
    // 檢查錯誤
	if error == nil {
		fmt.Println(value)
	} else {
		fmt.Println(error)
	}
}
```



下面列一些`Go`的其他有助於例外處理的關鍵字



## defer

這個在其他筆記有提過，這邊不詳講了

簡單來說就是把動作延後執行

遇到`panic`則在`panic`之前執行



## panic

會直接中斷程式執行，類似於`C#`的`throw exception`

可以自己呼叫，有時系統出錯也會丟panic出來

> 但是如果在 panic 之前就 defer 的程式碼，會在崩潰前執行：
>
> ```go
> func main() {
> 	defer fmt.Println("defer hello")
> 	panic("crash")
> 	fmt.Println("hello,world")
> }
> ```
>
> 執行結果：
>
> ```bash
> defer hello
> panic: crash
> ```



## recover

搭配`defer`使用，可以避免`panic`造成程式執行中斷。

節錄自[ITHELP](https://ithelp.ithome.com.tw/articles/10219879)

```go
func main() {
	defer func() {
		err := recover()
		fmt.Println(err)
	}()

	panic("crash")

	fmt.Println("hello,world")
}

/* 執行結果：
crash
*/
```

**注意**:

*  `panic`後方的程式碼**不會**被執行
* `recover`後方的程式碼**會**被執行



可以利用這些特性模擬出`try`-`catch`動作

節錄自[ITHELP](https://ithelp.ithome.com.tw/articles/10219879)

```go
// 定義一個接受函式參數的函式，在發生錯誤時會捕捉錯誤防止崩潰
func try(action func()) {
	defer func() {
		err := recover()
		fmt.Println(err)
	}()

    // 執行方法
	action()
}

func main() {
	// 嘗試執行可能出錯的函式
	try(func() {
		panic("crash")
	})

    // 即使 try 裡面函式出錯依然可以往下執行
	fmt.Println("hello,world")
}

/* 執行結果：
crash
hello,world
*/
```

要寫catch就寫道`defer func`裡面，也可以傳入`func`

改完大概像這樣

```go
package main

import "fmt"

// 定義一個接受函式參數的函式，在發生錯誤時會捕捉錯誤防止崩潰
func try(action, catch func()) {
	defer func() {
		err := recover()
		fmt.Println(err)
		catch()
	}()

	// 執行方法
	action()
}

func main() {
	// 嘗試執行可能出錯的函式
	try(func() {
		panic("crash")
	}, func() {
		fmt.Println("Catch Exception ~~")
	})

	// 即使 try 裡面函式出錯依然可以往下執行
	fmt.Println("hello,world")
}

/* 執行結果：
crash
Catch Exception ~~
hello,world
*/
```

不過這樣做也是有缺點:

* catch的動作不能和err關聯，畢竟err是在try function裡面宣告的。
* 不想處理catch的時候還是要傳入空方法