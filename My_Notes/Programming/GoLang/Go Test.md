# Go Test

tags: #golang #test/unit_test #test/coverage #static_check #lint

## 專案檢查流程

```powershell
//單元測試 設定次數可以避免使用catche進行測試
go test ./... -count 1
//檢查註解
golint ./...
//移除不需要的mod
go mod tidy
//其他檢查
go vet ./...
go tool vet ./...
//格式化
go fmt
```

補充: `golint` 現已棄用，用static check替代(或者用 [[Go glangci-lint]] 大禮包也行)

檢查race

```go
go test ./... -race
go vet ./... -race
```

覺得每次下差不多的指令有點麻煩，所以把它寫成powershell script了

## 覆蓋率測試

這個就很有趣了

### 基礎版

```powershell
go test [測試目標] -cover
```

可以看到測試程式的覆蓋率，但也僅此而已，無法得知具體沒覆蓋到的地方在哪裡。

### 進階版

先建立測試結果輸出的文件

```powershell
go test [測試目標] -coverprofile=[生成檔案]
```

網路上查到的檔案路徑部分沒有用引號標起來`-cover=file.out`，但我這樣寫會判讀錯誤，所以還是標一下比較好`cover="file.out"`

接著我們可以透過`go tool cover`查看剛才測試的覆蓋情形

```powershell
go tool cover -func=[剛才生成的檔案]

//或者用網頁檢視(推薦)
go tool cover -html=[剛才生成的檔案]
```

測試覆蓋率時想忽略部份內容(例如自動生成的內容) 可以參考[這篇](https://stackoverflow.com/questions/50065448/how-to-ignore-generated-files-from-go-test-coverage)

## 進進進階版

golang提倡把測試和實作寫在同一個package，照做可以免去很多麻煩。其中最大的麻煩就是測試覆蓋率的計算，預設是僅包含本身的package。

但若真的想分開寫，也不是沒有辦法。

透過 `go help testflag` 可以看到

```bash
        -coverpkg pattern1,pattern2,pattern3
            Apply coverage analysis in each test to packages matching the patterns.
            The default is for each test to analyze only the package being tested.
            See 'go help packages' for a description of package patterns.
            Sets -cover.
```

循線追查`go help packages`可以看到

```bash
There are four reserved names for paths that should not be used
for packages to be built with the go tool:

- "main" denotes the top-level package in a stand-alone executable.

- "all" expands to all packages found in all the GOPATH
trees. For example, 'go list all' lists all the packages on the local
system. When using modules, "all" expands to all packages in
the main module and their dependencies, including dependencies
needed by tests of any of those.

- "std" is like all but expands to just the packages in the standard
Go library.

- "cmd" expands to the Go repository's commands and their
internal libraries.

Import paths beginning with "cmd/" only match source code in
the Go repository.

An import path is a pattern if it includes one or more "..." wildcards,
each of which can match any string, including the empty string and
strings containing slashes. Such a pattern expands to all package
directories found in the GOPATH trees with names matching the
patterns.

To make common patterns more convenient, there are two special cases.
First, /... at the end of the pattern can match an empty string,
so that net/... matches both net and packages in its subdirectories, like net/http.
Second, any slash-separated pattern element containing a wildcard never
participates in a match of the "vendor" element in the path of a vendored
package, so that ./... does not match packages in subdirectories of
./vendor or ./mycode/vendor, but ./vendor/... and ./mycode/vendor/... do.
Note, however, that a directory named vendor that itself contains code
is not a vendored package: cmd/vendor would be a command named vendor,
and the pattern cmd/... matches it.
See golang.org/s/go15vendor for more about vendoring.
```

我試過如果用`all` `std` 這類包山包海的，會讓測試變得很慢。

所以比較常用的還是清楚的指出想側的位置。

又為了方便vscode測試。通常可以設定成專案目錄(用module name)

例如

`-coverpkg github.com.tw/STRockefeller/Project`

[reference](https://www.ory.sh/golang-go-code-coverage-accurate/#the-golang-code-classlanguage-textgo-test--coverpkgcode-flag)

## 其他工具

<https://medium.com/@arshamshirvani/lint-your-golang-code-like-a-pro-668dc6637b39>

有一部分無法使用，一部分在v1.15版有安裝問題

### Gocyclo

查詢還複雜度

```powershell
PS D:\Rockefeller\Projects\mcom> gocyclo.exe .\record.go 
14 impl (*DataManager).CreateWorkOrders .\impl\production.go:77:1
13 impl parseUpdatesCondition .\impl\production.go:123:1
6 impl (*DataManager).ListWorkOrders .\impl\production.go:297:1
5 impl (*DataManager).UpdateWorkOrders .\impl\production.go:182:1
5 impl parseWorkOrderInsertData .\impl\production.go:21:1
4 impl getWorkOrderUnit .\impl\production.go:222:1
3 impl (*DataManager).getReservedSequence .\impl\production.go:60:1
```

不過好像只能選擇單一檔案==>待驗證

### interfacer(Deprecated)

無法正常使用，安裝失敗

```powershell
PS D:\Rockefeller\Projects\mcom> go install github.com/mvdan/interfacer/cmd/interfacer
go: finding module for package github.com/mvdan/interfacer/cmd/interfacer
module github.com/mvdan/interfacer@latest found (v0.0.0-20180901003855-c20040233aed), but does not contain package github.com/mvdan/interfacer/cmd/interfacer
```

---

更新後續

升級golang至1.18版本之後有安裝成功，但是...

執行中偵測到generic就爆掉了。

![](https://i.imgur.com/fwGIn7c.png)

去查了一下，發現它已經四年多沒更新了，難怪沒支援新的語法。

### staticcheck

靜態檢查

```powershell
PS D:\Rockefeller\Projects\mcom> staticcheck.exe ./...
cmd\jennifer\main.go:218:52: cutset contains duplicate characters (SA1024)
cmd\mockgenerator\main.go:79:65: cutset contains duplicate characters (SA1024)
```

### gotype

無法正常使用

像是被拒絕訪問

```powershell
PS D:\Rockefeller\Projects\mcom> gotype.exe ./...
open ...: Access is denied.
```

或者沒有任何輸出

```powershell
PS D:\Rockefeller\Projects\mcom\cmd\jennifer> gotype.exe .\main.go
PS D:\Rockefeller\Projects\mcom\cmd\jennifer> cd ../
PS D:\Rockefeller\Projects\mcom\cmd> cd .\mockgenerator\
PS D:\Rockefeller\Projects\mcom\cmd\mockgenerator> gotype.exe .\main.go
PS D:\Rockefeller\Projects\mcom\cmd\mockgenerator> 
```

### goconst

可以找到很多重複使用的常量，但大多數的情況看起來並不是合設置const variable

### suite

也可以做到 setup 和 tear down。
想寫的東西有點多所以另外記錄一篇 [[Go package suite]]

## Setup and Tear Down

references:

[殘體字文章](https://www.jianshu.com/p/d0261602dad5)

[在 Go 語言測試使用 Setup 及 Teardown - 小惡魔 - AppleBOY](https://blog.wu-boy.com/2022/07/setup-and-teardown-with-unit-testing-in-golang/)

[How can I do test setup using the testing package in Go - Stack Overflow](https://stackoverflow.com/questions/23729790/how-can-i-do-test-setup-using-the-testing-package-in-go)

簡單說就是分別加在`TestMain`中`m.Run()`的前後。

透過defer可以寫的再優雅一點，如下

```go
func setUpAll() func() {
    log.Printf("setUpAll")
    return func() {
        log.Printf("tearDownAll")
    }
}

func TestMain(m *testing.M) {
    tearDownAll := setUpAll()

    var code int
    defer func() {
        tearDownAll()
        os.Exit(code)
    }()

    // do something : if err occurs, set code = 1 and return
    code = m.Run()
}
```
