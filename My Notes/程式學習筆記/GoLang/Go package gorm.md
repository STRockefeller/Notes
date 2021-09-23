# Gorm

Reference:

https://gorm.io/docs/index.html

[ITHELP](https://ithelp.ithome.com.tw/articles/10245308)



## Install

```
go get -u gorm.io/gorm
```



根據使用的SQL

**SQLITE**

```powershell
go get -u gorm.io/driver/sqlite
```

(安裝sqlite driver 失敗顯示`exec: "gcc": executable file not found in %PATH%`的話參考[這篇](https://hoohoo.top/blog/golang-fix-gccexec-gcc-executable-file-not-found-in-path/)安裝`tmd-gcc`)



**MySQL**

```powershell
go get -u gorm.io/driver/mysql
```



**PostrgreSQL**

```powershell
go get -u gorm.io/driver/postgres
```



## Getting Start

官方的CRUD範例

```go
package main

import (
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

type Product struct {
	gorm.Model
	Code  string
	Price uint
}

func main() {
	db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}

	// Migrate the schema
	db.AutoMigrate(&Product{})

	// Create
	db.Create(&Product{Code: "D42", Price: 100})

	// Read
	var product Product
	db.First(&product, 1)                 // find product with integer primary key
	db.First(&product, "code = ?", "D42") // find product with code D42

	// Update - update product's price to 200
	db.Model(&product).Update("Price", 200)
	// Update - update multiple fields
	db.Model(&product).Updates(Product{Price: 200, Code: "F42"}) // non-zero fields
	db.Model(&product).Updates(map[string]interface{}{"Price": 200, "Code": "F42"})

	// Delete - delete product
	db.Delete(&product, 1)
}
```

詳細接著說明



## Connect to DB

[Reference](https://gorm.io/docs/connecting_to_the_database.html)

官方範例如下

```go
db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
```

使用現有sqlite db的做法，不過就算沒有也會自動建立



來看看`gorm.Open()`方法簽章

```go
func gorm.Open(dialector gorm.Dialector, opts ...gorm.Option) (db *gorm.DB, err error)
```

回傳的`*gorm.DB`物件就是接下來資料庫操作會用到的物件。

此外比較值得討論的是第一個argument `gorm.Dialector`

Gorm Guides是以sqlite為例，根據import的`gorm.io/driver/`不同`sqlite.Open()` 也可以是 `mysql.Open()` / `postgres.New()`等等，一般來說這些方法都需要傳入DB的Connection String

例如

mysql

```go
	db, err := gorm.Open(mysql.Open(addr), &gorm.Config{})
	if err != nil {
		fmt.Println("connection to mysql failed:", err)
		return
	}  
```

postgresql

```go
	db, err := gorm.Open(postgres.New(
		postgres.Config{
			DriverName: "postgres",
			DSN: fmt.Sprintf(
				"host=%s port=%d user=%s dbname=%s password=%s sslmode=disable",
				cfg.Address,
				cfg.Port,
				cfg.UserName,
				cfg.Database,
				cfg.Password,
			),
		},
	), &gorm.Config{
		Logger: newLogger(),
		NamingStrategy: schema.NamingStrategy{
			TablePrefix:   o.TablePrefix(),
			SingularTable: true,
		},
	})
```







## Declaring Models

[Reference](https://gorm.io/docs/models.html)

Models are normal structs with basic Go types, pointers/alias of them or custom types implementing [Scanner](https://pkg.go.dev/database/sql/?tab=doc#Scanner) and [Valuer](https://pkg.go.dev/database/sql/driver#Valuer) interfaces

GORM prefer convention over configuration, by default, GORM uses `ID` as primary key, pluralize struct name to `snake_cases` as table name, `snake_case` as column name, and uses `CreatedAt`, `UpdatedAt` to track creating/updating time

If you follow the conventions adopted by GORM, you’ll need to write very little configuration/code, If convention doesn’t match your requirements, [GORM allows you to configure them](https://gorm.io/docs/conventions.html)

example

```go
type User struct {
    //gorm為model的tag標籤，v2版的auto_increment要放在type裡面，v1版是放獨立定義
	ID        int64     `gorm:"type:bigint(20) NOT NULL auto_increment;primary_key;" json:"id,omitempty"`
	Username  string    `gorm:"type:varchar(20) NOT NULL;" json:"username,omitempty"`
	Password  string    `gorm:"type:varchar(100) NOT NULL;" json:"password,omitempty"`
	Status    int32     `gorm:"type:int(5);" json:"status,omitempty"`
	CreatedAt time.Time `gorm:"type:timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" json:"created_at,omitempty"`
	UpdatedAt time.Time `gorm:"type:timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" json:"updated_at,omitempty"`
}
```

BTW Gorm Guides最開始範例用的struct也有定義primary key和`CreateAt` `UpdateAt`等等方法

```go
type Product struct {
	gorm.Model
	Code  string
	Price uint
}
```

其中的`gorm.Model`

```go
type Model struct {
    ID        uint `gorm:"primarykey"`
    CreatedAt time.Time
    UpdatedAt time.Time
    DeletedAt DeletedAt `gorm:"index"`
}
```

也就是說，只要Combine `gorm.Model` 就算是符合了最基本gorm的model要求



## Create

```go
user := User{Name: "Jinzhu", Age: 18, Birthday: time.Now()}

result := db.Create(&user) // pass pointer of data to Create

user.ID             // returns inserted data's primary key
result.Error        // returns error
result.RowsAffected // returns inserted records count
```

**注意:**`func (*gorm.DB).Create(value interface{}) (tx *gorm.DB)`方法引數**傳址**

承上例，如果只想將`user`的`Name`和`Birthday`存入資料庫可以寫成如下

```go
db.Select("Name", "Age").Create(&user)
// INSERT INTO `users` (`name`,`age`) VALUES ("jinzhu", 18)
```

反過來也可以指定那些屬性不想傳入

```go
db.Omit("Name", "Age", "CreatedAt").Create(&user)
// INSERT INTO `users` (`birthday`,`updated_at`) VALUES ("2020-01-01 00:00:00.000", "2020-07-04 11:05:21.775")
```



### Batch Insert

可以透過Slice批量建立資料

```go
var users = []User{{Name: "jinzhu1"}, {Name: "jinzhu2"}, {Name: "jinzhu3"}}
db.Create(&users)
```

也可以指定大小

```go
var users = []User{{Name: "jinzhu_1"}, ...., {Name: "jinzhu_10000"}}

// batch size 100
db.CreateInBatches(users, 100)
```





## Search

### Search Zero Value

> **NOTE** When querying with struct, GORM will only query with non-zero fields, that means if your field’s value is `0`, `''`, `false` or other [zero values](https://tour.golang.org/basics/12), it won’t be used to build query conditions, for example:

```
db.Where(&User{Name: "jinzhu", Age: 0}).Find(&users)
// SELECT * FROM users WHERE name = "jinzhu";
```

To include zero values in the query conditions, you can use a map, which will include all key-values as query conditions, for example:

```
db.Where(map[string]interface{}{"Name": "jinzhu", "Age": 0}).Find(&users)
// SELECT * FROM users WHERE name = "jinzhu" AND age = 0;
```

For more details, see [Specify Struct search fields](https://gorm.io/docs/query.html#specify_search_fields).

## Error Handle

可以發現`Gorm`套件的方法幾乎都沒有error的回傳，也就是說不論`Gorm`套件的方法是否有正確執行，程式都會繼續下去。

如果需要查看執行是否有誤，則必須使用`gorm.DB`的`Error`屬性。例如

```go
	if err := dm.db.Create(&NewBatch).Error; err != nil {
		return err
	}
```

