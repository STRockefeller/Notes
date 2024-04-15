# Zap

tags: #golang #log

[zap package - go.uber.org/zap - Go Packages](https://pkg.go.dev/go.uber.org/zap)

log套件

直接紀錄使用方法

## 初始化

方式有很多種，詳細看官方文件

NewXXX 系列

```go
logger, err := zap.NewDevelopment()
if err != nil {
    log.Fatal(err)
}
```

透過Config

```go
cfg := zap.NewDevelopmentConfig()
cfg.DisableStacktrace = true

logger, err := cfg.Build()
if err != nil {
    return err
}
```

## 註冊到全域

```go
zap.ReplaceGlobals(logger)
```

之後就可以用`zap.L()`來呼叫這個logger

## Print

印出log，可以選層級

```go
logger.Info("")
```

搭配結構化的呈現

```go
logger.Warn("file not found",zap.String("file name",file.Name),zap.Error(err))
```

搭配gorm，要丟到ctx裡面

參考`"gitlab.kenda.com.tw/kenda/commons/v2/utils/context"`的WithLogger方法
