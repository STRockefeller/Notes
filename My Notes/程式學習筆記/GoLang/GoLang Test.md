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



