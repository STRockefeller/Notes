# 疑難雜症



## Debug 路徑問題 

`go run` `go build`等指令可以正常作用

debug時顯示錯誤如下

```powershell
Build Error: go build -o d:\Rockefeller\Projects_Test\GormTest0824\__debug_bin.exe -gcflags all=-N -l d:\Rockefeller\Projects_Test\GormTest0824
cannot find package "d:\\Rockefeller\\Projects_Test\\GormTest0824" in any of:
	C:\Program Files\Go\src\d:\Rockefeller\Projects_Test\GormTest0824 (from $GOROOT)
	C:\Users\rockefel\go\src\d:\Rockefeller\Projects_Test\GormTest0824 (from $GOPATH) (exit status 1)
```

原因不明

解決方法(擇一)

1.

把自動生成的`launch.json`中`"program"`值修改如下

```json
"program": "${workspaceFolder}/main.go"
```

或絕對路徑也行

2.

執行`go mod init`生成`go.mod`file



## cannot find package "io/fs"

執行go install時發生的

```powershell
PS C:\Users\rockefel> go install github.com/fzipp/gocyclo/cmd/gocyclo
go\src\github.com\fzipp\gocyclo\analyze.go:12:2: cannot find package "io/fs" in any of:
        C:\Program Files\Go\src\io\fs (from $GOROOT)
        C:\Users\rockefel\go\src\io\fs (from $GOPATH)
```

根據[github issue](https://github.com/spf13/viper/issues/1161)看來應該是v1.15特有的問題，後續更新被修正掉了，至於v1.15有沒有替代的解決方案，目前是沒有找到。



