# 專案檢查流程



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
