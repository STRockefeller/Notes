# Cross Compile

## windows ➡ linux

build linux exe from windows https://stackoverflow.com/questions/49449190/golang-on-windows-how-to-build-for-linux

另外有一篇比較老的，實際使用沒有成功

```shell
env GOOS=linux go build -o filename
```

記得用bash跑，powershell會失敗

