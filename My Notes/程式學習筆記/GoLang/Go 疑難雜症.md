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

