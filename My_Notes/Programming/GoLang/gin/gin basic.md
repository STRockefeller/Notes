# gin

tags: #golang #golang/gin #api

待整理

使用 session 時

跳錯誤`Key "github.com/gin-contrib/sessions" does not exist`

![](https://i.imgur.com/F7mZgsF.png)

使因為沒有使用middleware

參考這個[issue](https://github.com/gin-contrib/sessions/issues/40)

```go
	router := gin.Default()
	store := cookie.NewStore([]byte("mysession"))
	router.Use(sessions.Sessions("mysession", store))
```

即可。
