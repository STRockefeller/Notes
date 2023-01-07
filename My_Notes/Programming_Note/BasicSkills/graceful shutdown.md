# Graceful Shutdown

#unix_signal #c_sharp #golang 

## Abstract

讓程式依照我們預想的方式關閉。



例如，我現在有個rest server，他會接收client的request並做對應的處理。

現在當我強制關閉這個server時，就會有許多操作執行到一半被中斷。進而導致一些無法被預期的狀況。

因此會需要透過graceful shutdown來讓程式以預期的方式關閉避免這些問題，例如可以先停止繼續接收新的request，並且將目前已接收的request都處理完畢後，再關閉server。



## Unix Signal

了解下來發現大多數的實作方式都是抓Unix Signal再做處理

以下是來自[wiki](https://zh.wikipedia.org/zh-tw/Unix%E4%BF%A1%E5%8F%B7#SIGINT)的表格，雖然看完還是不太能區分箇中差異就是了。

|   訊號    | 可移植代號 |    預設行為     |                             描述                             |
| :-------: | :--------: | :-------------: | :----------------------------------------------------------: |
|  SIGABRT  |     6      | 終止 (核心轉儲) |                         行程終止訊號                         |
|  SIGALRM  |     14     |      終止       |                          計時器告警                          |
|  SIGBUS   |   不適用   | 終止 (核心轉儲) |                   存取記憶體物件未定義區域                   |
|  SIGCHLD  |   不適用   |      忽略       |                    子行程終止、暫停、繼續                    |
|  SIGCONT  |   不適用   |      繼續       |                   如果被暫停，重新繼續執行                   |
|  SIGFPE   |     8      | 終止 (核心轉儲) |                        錯誤的算術運算                        |
|  SIGHUP   |     1      |      終止       |                             掛起                             |
|  SIGILL   |     4      | 終止 (核心轉儲) |                          非法的指令                          |
|  SIGINT   |     2      |      終止       |                         終端中斷訊號                         |
|  SIGKILL  |     9      |      終止       |                殺死 (無法被擷取或忽略的訊號)                 |
|  SIGPIPE  |     13     |      終止       |                 寫入一個沒有連接另一端的管道                 |
|  SIGPOLL  |   不適用   |      終止       |                          可輪詢事件                          |
|  SIGPROF  |   不適用   |      終止       |                      效能調優定時器逾時                      |
|  SIGQUIT  |     3      | 終止 (核心轉儲) |                         終端登出訊號                         |
|  SIGSEGV  |     11     | 終止 (核心轉儲) |                       非法的記憶體參照                       |
|  SIGSTOP  |   不適用   |      暫停       |              暫停執行（無法被擷取或忽略的訊號）              |
|  SIGSYS   |   不適用   | 終止 (核心轉儲) |                        錯誤的系統呼叫                        |
|  SIGTERM  |     15     |      終止       |                           終止訊號                           |
|  SIGTRAP  |     5      | 終止 (核心轉儲) |                        追蹤/斷點陷阱                         |
|  SIGTSTP  |   不適用   |      暫停       |                         終端中止訊號                         |
|  SIGTTIN  |   不適用   |      暫停       |                        後台行程嘗試讀                        |
|  SIGTTOU  |   不適用   |      暫停       |                        後台行程嘗試寫                        |
|  SIGUSR1  |   不適用   |      終止       |                       使用者自訂訊號1                        |
|  SIGUSR2  |   不適用   |      終止       |                       使用者自訂訊號2                        |
|  SIGURG   |   不適用   |      忽略       | [Out-of-band data](https://zh.wikipedia.org/w/index.php?title=Out-of-band_data&action=edit&redlink=1) is available at a socket |
| SIGVTALRM |   不適用   |      終止       |                        虛擬定時器逾時                        |
|  SIGXCPU  |   不適用   | 終止 (核心轉儲) |                       超出CPU時間限制                        |
|  SIGXFSZ  |   不適用   | 終止 (核心轉儲) |                       超出檔案大小限制                       |
| SIGWINCH  |   不適用   |      忽略       |                      終端窗口大小已變化                      |

總之我們抓的不外乎是`sigint` `sigterm` 這類的中止訊號。



## Golang realization

[reference](https://ithelp.ithome.com.tw/articles/10220965)

用graceful shutdown作為key world基本上查到的大多是golang的文章，我也不曉得為啥。

總之先來試試用golang實作



```go
package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	fmt.Println("process start")
	ticker := time.NewTicker(time.Second * 1)
	go func() {
		for t := range ticker.C {
			fmt.Println("ticker:", t)
		}
		fmt.Println("routine fin")
	}()
	<-gracefulShutdown()
	fmt.Println("progress shutdown...")
	ticker.Stop()
	time.Sleep(time.Second * 2)
}

func gracefulShutdown() (sig chan os.Signal) {
	sig = make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT)
	return
}

```



```text
process start
ticker: 2022-06-30 09:32:37.3040847 +0800 CST m=+1.015848601
ticker: 2022-06-30 09:32:38.3050401 +0800 CST m=+2.016823801
ticker: 2022-06-30 09:32:39.2997204 +0800 CST m=+3.011523801
progress shutdown...
```



心得:

1. `syscall.SIGINT` 在windows系統也可以順利擷取到，for windows 專用的 `os.Interrupt` 感覺就用不上了。
2. kill 類的無法被截取，所以不用寫進`Notidy`了，static check 也會提醒。
3. 順便拿來測試一下Ticker，得知Ticker的Stop只是停止發送資訊到channel而已，並不會關閉(註解也有寫)，所以像這種寫法就會造成一個死掉的goroutine卡在那邊。(`fmt.Println("routine fin")`永遠不會被執行到)



另外

```go
package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	fmt.Println("process start")
	<-gracefulShutdown()
	fmt.Println("progress shutdown...")
	loop()
}

func loop() {
	main()
}

func gracefulShutdown() (sig chan os.Signal) {
	sig = make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT)
	return
}

```

寫成這樣會關不掉，很歡樂(?



## C# realization

[reference](https://medium.com/@rainer_8955/gracefully-shutdown-c-apps-2e9711215f6d)

```C#
public static partial class Program
{
    public static async Task Main()
    {
        Console.WriteLine("Process Start");

        TaskCompletionSource tcs = new TaskCompletionSource();
        Timer timer = new Timer(Callback, null, 0, 1000);
        Console.CancelKeyPress += (sender, e) =>
        {
            e.Cancel = true;
            Console.WriteLine("SIGINT");
            tcs.SetResult();
        };
        await tcs.Task;
        Console.WriteLine("Process shutdown");
    }

    private static void Callback(Object? sender)
    {
        Console.WriteLine("callback:" + DateTime.Now.ToString());
    }
}
```



```
PS D:\Rockefeller\Projects_Test\graceful shutdown\C#> dotnet run
Process Start
callback:2022/6/30 上午 10:17:33
callback:2022/6/30 上午 10:17:34
callback:2022/6/30 上午 10:17:35
callback:2022/6/30 上午 10:17:36
SIGINT
Process shutdown
```



C#這邊則是透過訂閱<kbd>Ctrl</kbd>+<kbd>C</kbd>按鍵事件完成Task，並在`await`等到Task結果的時候執行特定的動作。



不過Interrupt可以透過按鍵來觸發，其他就必須從其他地方著手了，用起來沒有golang簡單。