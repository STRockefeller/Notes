# Zap

log套件

直接紀錄使用方法



初始化

```go
logger, err := zap.NewDevelopment()
if err != nil {
	log.Fatal(err)
}
```

建構式不一定要用`NewDevelopment` 還有其他選擇，差別可以看官方文件



印出log，可以選層級

```go
logger.Info("")
```



搭配gorm，要丟到ctx裡面

參考`"gitlab.kenda.com.tw/kenda/commons/v2/utils/context"`的WithLogger方法

