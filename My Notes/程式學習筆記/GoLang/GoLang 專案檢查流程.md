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
```

