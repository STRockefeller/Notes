# Go Test



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





## 其他工具

https://medium.com/@arshamshirvani/lint-your-golang-code-like-a-pro-668dc6637b39

有一部分無法使用，一部分在v1.15版有安裝問題



### **Gocyclo** 

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



### interfacer

無法正常使用，安裝失敗

```powershell
PS D:\Rockefeller\Projects\mcom> go install github.com/mvdan/interfacer/cmd/interfacer
go: finding module for package github.com/mvdan/interfacer/cmd/interfacer
module github.com/mvdan/interfacer@latest found (v0.0.0-20180901003855-c20040233aed), but does not contain package github.com/mvdan/interfacer/cmd/interfacer
```





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
