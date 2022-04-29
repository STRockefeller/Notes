# Validator

[official doc](https://pkg.go.dev/github.com/go-playground/validator)



## Sample

直接上範例

```go
package main

import (
	"fmt"

	"github.com/go-playground/validator/v10"
)

// User contains user information
type User struct {
	FirstName      string     `validate:"required"`
	LastName       string     `validate:"required"`
	Age            uint8      `validate:"gte=0,lte=130"`
	Email          string     `validate:"required,email"`
	FavouriteColor string     `validate:"iscolor"`                // alias for 'hexcolor|rgb|rgba|hsl|hsla'
	Addresses      []*Address `validate:"required,dive,required"` // a person can have a home and cottage...
}

// Address houses a users address information
type Address struct {
	Street string `validate:"required"`
	City   string `validate:"required"`
	Planet string `validate:"required"`
	Phone  string `validate:"required"`
}

// use a single instance of Validate, it caches struct info
var validate *validator.Validate

func main() {

	validate = validator.New()

	var user User
	err := validate.Struct(user)
	fmt.Println(err)
}

```

輸出

```powershell
PS D:\Rockefeller\Projects_Test\test_validator> go run .
Key: 'User.FirstName' Error:Field validation for 'FirstName' failed on the 'required' tag
Key: 'User.LastName' Error:Field validation for 'LastName' failed on the 'required' tag
Key: 'User.Email' Error:Field validation for 'Email' failed on the 'required' tag
Key: 'User.FavouriteColor' Error:Field validation for 'FavouriteColor' failed on the 'iscolor' tag
Key: 'User.Addresses' Error:Field validation for 'Addresses' failed on the 'required' tag
```



## Fields must be exposed

![](https://i.imgur.com/q1Yr4fa.png)

### case 1

```go
package main

import (
	"fmt"

	"github.com/go-playground/validator/v10"
)

// User contains user information
type User struct {
	Name string `validate:"required"`
}

// use a single instance of Validate, it caches struct info
var validate *validator.Validate

func main() {

	validate = validator.New()

	var user User
	err := validate.Struct(user)
	fmt.Println(err)
}

```

output

```powershell
PS D:\Rockefeller\Projects_Test\test_validator> go run .
Key: 'User.Name' Error:Field validation for 'Name' failed on the 'required' tag
```





### case 2

```go
package main

import (
	"fmt"

	"github.com/go-playground/validator/v10"
)

// User contains user information
type User struct {
	name string `validate:"required"`
}

// use a single instance of Validate, it caches struct info
var validate *validator.Validate

func main() {

	validate = validator.New()

	var user User
	err := validate.Struct(user)
	fmt.Println(err)
}

```

output

```powershell
PS D:\Rockefeller\Projects_Test\test_validator> go run .
<nil>
```

