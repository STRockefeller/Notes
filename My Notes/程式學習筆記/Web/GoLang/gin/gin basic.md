# Gin Basic

Reference:

[github](https://github.com/gin-gonic/gin)

[ITHELP](https://ithelp.ithome.com.tw/users/20120647/ironman/3110)

## Installation



```powershell
go get github.com/gin-gonic/gin
```



```powershell
PS C:\Users\admin\Desktop\Go> go get github.com/gin-gonic/gin
go: downloading github.com/gin-gonic/gin v1.7.3
go: downloading github.com/gin-contrib/sse v0.1.0
go: downloading github.com/mattn/go-isatty v0.0.12
go: downloading github.com/go-playground/validator/v10 v10.4.1
go: downloading github.com/golang/protobuf v1.3.3
go: downloading github.com/ugorji/go v1.1.7
go: downloading gopkg.in/yaml.v2 v2.2.8
go: downloading github.com/json-iterator/go v1.1.9
go: downloading github.com/ugorji/go/codec v1.1.7
go: downloading golang.org/x/sys v0.0.0-20200116001909-b77594299b42
go: downloading github.com/go-playground/universal-translator v0.17.0
go: downloading github.com/leodido/go-urn v1.2.0
go: downloading golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9
go: downloading github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421
go: downloading github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742
go: downloading github.com/go-playground/locales v0.13.0
```

好像是全域的安裝，因為安裝完成後資料夾沒有多任何東西



## Getting Start

### import

```go
import (
    "github.com/gin-gonic/gin"
    "net/http"
)
```

然後報錯

```powershell
could not import github.com/gin-gonic/gin (cannot find package "github.com/gin-gonic/gin" in any of 
	C:\Program Files\Go\src\github.com\gin-gonic\gin (from $GOROOT)
	C\src\github.com\gin-gonic\gin (from $GOPATH)
	\Users\admin\go\src\github.com\gin-gonic\gin (from $GOPATH))
```



專案問題

設定專案module，這邊隨便以`example.com/ladida`做名稱

建立`go.mod`，並修改如下

```mod
module example.com/ladida

go 1.16
```

然後執行`go build`



或輸入

```powershell
go mod init example.com/ladida
```

然後執行`go build`



然後會看到剛剛的import gjn的底下出現波浪號(VSCode)

```go
import (
    "github.com/gin-gonic/gin"
    "net/http"
)
```

點Quick fix會再次執行go get，跑完多一個`go.sum`檔案、並且go.mod會多一行require，就OK了



執行這段程式測試看看(來自[ITHELP](https://ithelp.ithome.com.tw/articles/10244740))

```go
package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/test", test)
	router.Run(":80")
}

func test(c *gin.Context) {
	str := []byte("ok") 
	c.Data(http.StatusOK, "text/plain", str) 
}
```

```powershell
PS C:\Users\admin\Desktop\Go> go run hello.go
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /test                     --> main.test (3 handlers)
[GIN-debug] Listening and serving HTTP on :80
[GIN] 2021/08/03 - 15:35:37 | 200 |            0s |             ::1 | GET      "/test"
[GIN] 2021/08/03 - 15:35:37 | 404 |            0s |             ::1 | GET      "/favicon.ico"
```

開啟http://localhost/test 會看到"ok"



//待續