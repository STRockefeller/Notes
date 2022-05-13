# golangci-lint

https://betterprogramming.pub/how-to-improve-code-quality-with-an-automatic-check-in-go-d18a5eb85f09

https://github.com/golangci/golangci-lint

https://golangci-lint.run/usage/linters/



## Installation

參考https://golangci-lint.run/usage/install/



```shell
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.43.0
```



確認是否正確安裝

```powershell
PS D:\Rockefeller\Projects\mcom> golangci-lint.exe --version
golangci-lint has version 1.43.0 built from 861262b7 on 2021-11-03T11:57:46Z
```



也可以用go get來安裝，不過並不推薦

```shell
# Go 1.16+
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0

# Go version < 1.16
go get -u github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0
```



## Quick Start

下 `golanci-lint run`

執行起來像是這樣

```powershell
PS D:\Rockefeller\Projects\****> golangci-lint.exe run      
impl\***\********.go:24:23: Error return value of `Hello**********` is not checked (errcheck)
        defer Hello**********()
                             ^
impl\***\********_test.go:54:15: Error return value of `************` is not checked (errcheck)
                        ***********()
                                   ^
```



至於他做了什麼可以看[這裡](https://golangci-lint.run/usage/linters/)



## Advance 

套餐不喜歡的話也可以換成自助餐，[表格](https://golangci-lint.run/usage/linters/)有提到的工具都可以使用



建立 .golangci.yaml 在專案的跟目錄，執行時就會根據上面的設定執行，例如

```yaml
linters:
  disable-all: true
  enable:
    - golint
    - errcheck
issues:
  exclude-use-default: false
```



想移除某種檢查: [參考](https://golangci-lint.run/usage/false-positives/)
