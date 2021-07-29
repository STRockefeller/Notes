# Go Language Basic

Reference:

[ITHelp](https://ithelp.ithome.com.tw/users/20125192/ironman/3155)

[A Tour of Go](https://tour.golang.org/list)

[TutorialsPoint](https://www.tutorialspoint.com/go/index.htm)

## Review with Questions

* 若要宣告一個跨package的整數並賦予初始值，可以怎麼做? [Ans](#Declare variables)
* 假如我有一個`struct`紀錄立方體的三個邊長，若要寫一個`method`來獲取立方體的表面積可以怎麼做? [Ans](#Methods)



## Abstract

新入坑`GoLang`，這篇筆記會從最基礎的部份邊學邊紀錄

筆記篇幅太大不好閱讀，這篇主要談基本架構，以及一些和其他語言比較相近的部分

其他雖然很基本但比較有`go`特色的內容會另外撰寫筆記。

另外找到了一個不錯的[Cheat Sheet](https://devhints.io/go)很適合快速複習

## Installation

其實也就只是安裝之後修改環境變數，並沒有甚麼特別的。



[官網](https://golang.org/dl/)下載安裝包，這篇筆記以win10作業系統為主，下載的是當下(2021/7)最新的版本:1.16.6

加入Path環境變數`%GOPATH%`或者是安裝路徑上的`\Go\bin\`



這次使用`Power Shell`來加入環境變數試試

查看環境變數的指令

```powershell
Get-ChildItem env:
```

這次只會改`Path`

查看Path

```powershell
$env:Path
```

這個變數可以直接修改，所以要加入新的環境變數就直接

```powershell
PS C:\Users\admin> $env:path+=";C:\Program Files\Go\bin"
```

然後**重新開機**，順利的話就完成安裝啦。

下達`go`指令測試

```powershell
PS C:\Users\admin> go
Go is a tool for managing Go source code.

Usage:

        go <command> [arguments]

The commands are:

        bug         start a bug report
        build       compile packages and dependencies
        clean       remove object files and cached files
        doc         show documentation for package or symbol
        env         print Go environment information
        fix         update packages to use new APIs
        fmt         gofmt (reformat) package sources
        generate    generate Go files by processing source
        get         add dependencies to current module and install them
        install     compile and install packages and dependencies
        list        list packages or modules
        mod         module maintenance
        run         compile and run Go program
        test        test packages
        tool        run specified go tool
        version     print Go version
        vet         report likely mistakes in packages

Use "go help <command>" for more information about a command.

Additional help topics:

        buildconstraint build constraints
        buildmode       build modes
        c               calling between Go and C
        cache           build and test caching
        environment     environment variables
        filetype        file types
        go.mod          the go.mod file
        gopath          GOPATH environment variable
        gopath-get      legacy GOPATH go get
        goproxy         module proxy protocol
        importpath      import path syntax
        modules         modules, module versions, and more
        module-get      module-aware go get
        module-auth     module authentication using go.sum
        packages        package lists and patterns
        private         configuration for downloading non-public code
        testflag        testing flags
        testfunc        testing functions
        vcs             controlling version control with GOVCS

Use "go help <topic>" for more information about that topic.
```



## Getting Start



粗略了解了一下發現`Go`並不完全是物件導向語言，並且我很難找到目前學過的哪個語言可以和`Go`類比

筆記中我會盡量以我的方式去說明`Go`的結構，可能不完全正確，有錯的話就等以後熟悉了再回來修正。



### Program Structure

`project`-->`package`-->`.go file`

先從最下層的`.go file`說起好了

`.go file`就是我們寫Code的檔案，開頭要先說明這個程式碼屬於哪一個`package`，接著`import`外部內容，才開始寫code

以下是官方的Hello world範例

```go
package main //說明這支程式屬於 main package

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

一般來說，專案中都會有名為"main"的`package`，這個`package`可以被`go run`指令執行，並且程式進入點為`main()`

比如說上面那支程式就可以直接執行

```pow
PS C:\Users\admin\Desktop\Go> go run hello.go
Hello, World!
```

程式中的變數或方法透過命名來決定其作用域

大寫開頭的變數或方法可以在專案中其他的`Package`呼叫，如果把整個`package`看做一個`class`則類似於`public`的概念

小寫開頭的變數或方法只能在同`package`中使用，類似於`private`

在同package中的程式碼可以看做在同一個檔案下，但是外部資源的引用每次都要寫，有點像`partial class`



#### Comments

和C家族的完全一樣`//` 以及 `/* */`



#### Line Separator

和`python`一樣不需要在行尾輸入任何符號，只要<kbd>Enter</kbd>進入下一行Compiler就可以知道該怎麼做了

不過我試過加了`;`也是可以正常運作的



#### Naming

首先`Go`是一種**大小寫敏感**的語言，另外[前面](#Program Structure)有提到過在`Go`中變數或方法開頭的大小寫會影響到這個變數或方法**可以被存取到的範圍**

另外變數的開頭可以用大小寫英文字母或`_`，但是`_`開頭的變數在`Go`中是否有習慣的用途目前還不得而知。

命名當中也**無法**使用一些奇奇怪怪的特殊字元

下表為`Go`的關鍵字，不能用做命名

| break    | default     | func   | interface | select |
| -------- | ----------- | ------ | --------- | ------ |
| case     | defer       | Go     | map       | Struct |
| chan     | else        | Goto   | package   | Switch |
| const    | fallthrough | if     | range     | Type   |
| continue | for         | import | return    | Var    |



### Data Types

#### Boolean

值為`true` 和 `false`，我試過沒辦法像`C`一樣使用`1`和`0`替代

#### Numeric

**Integer** 

* `uint`

  非負整數，可以透過`uint8` `uint16` `uint32` `uint64`指定大小，沒指定就同`uint64`

* `int`

  整數，一樣可以指定大小

* `byte`

  就是`uint8`

* `rune`

  就是`int32`

* `uintptr`

  儲存整數指標

整數常量的部分和C類似

```go
212         /* Legal */
215u        /* Legal */
0xFeeL      /* Legal */
078         /* Illegal: 8 is not an octal digit */
032UU       /* Illegal: cannot repeat a suffix */

85         /* decimal */
0213       /* octal */
0x4b       /* hexadecimal */
30         /* int */
30u        /* unsigned int */
30l        /* long */
30ul       /* unsigned long */
```

開頭`0`代表8進制

開頭`0x`代表16進制

結尾`u`代表unsigned

結尾`L`代表long

**Floating**

* `float`

  可以分成`float32` 和 `float64`

* `complex`

  儲存複數(?)，目前還不是很清楚，以後用到再補充，分為`complex64`和`complex128`

#### String

`Go`是沒有`char`的

**引號的區別**

```
" "內可跳脫字元如\t \n

` ` 內則保留原始字串  注意不是'
```

**跳脫字元**

基本上和C家族差不多

| Escape sequence | Meaning                                  |
| --------------- | ---------------------------------------- |
| \\              | \ character                              |
| \'              | ' character                              |
| \"              | " character                              |
| \?              | ? character                              |
| \a              | Alert or bell                            |
| \b              | Backspace                                |
| \f              | Form feed                                |
| \n              | Newline                                  |
| \r              | Carriage return                          |
| \t              | Horizontal tab                           |
| \v              | Vertical tab                             |
| \ooo            | Octal number of one to three digits      |
| \xhh . . .      | Hexadecimal number of one or more digits |



**格式化輸入輸出**

可以在`fmt.Printf()`或`fmt.Scanf()`使用



下方的範例來自[ITHELP](https://ithelp.ithome.com.tw/articles/10235988)

```go
%d: digit   (10進位的數字)
%c: char    (字元)
%s: string  (字串)
%v: value   (值)
%+v 見下方
%#v 見下方
```

```go
type Name struct {
	A string
	B bool
	C int
}
func main()  {
	fmt.Printf("%v	\n", Name{})
	fmt.Printf("%+v	\n", Name{})
	fmt.Printf("%#v	\n", Name{})
}
// { false 0}	
// {A: B:false C:0}	
// main.Name{A:"", B:false, C:0}	
```





#### Derived

* Pointer types
*  Array types
* Structure types
* Union types
* Function types
* Slice types
* Interface types
* Map types
* Channel 

#### Declare variables



> Note that it is a good programming practice to define constants in CAPITALS.



直接看範例

```go
var  i, j, k int;
var  c, ch byte;
var  f, salary float32;
d :=  42;
```

簡單來說宣告方式分兩種

1. 格式就是`var`+變數名稱+變數型別(+`=`+初始值)

   **宣告全域變數**只能使用這個方法

   可以像C或C++一樣同時宣告多個變數

   用這種方式宣告的變數**會有型別預設的初始值**

   譬如

   ```go
   func main() {
   	var i int
   	fmt.Println(i) //0
   }
   ```

2. 變數名稱+`:=`+初始值

   這種方式宣告的變數會自動套用相應的型別

   譬如

   ```go
   func main() {
   	d := 3.1415926
   	fmt.Printf("%T", d) //float64
   }
   ```

   這種宣告方式又稱為Short variable declarations，通常用於生命週期較短的變數

   如果該變數已經宣告過則`:=`會變為指派的作用

   例如

   ```go
   func main() {
   	d := 3.1415926
   	d, i := 0.5, 10
   	fmt.Printf("d=%f and i=%d", d, i) //d=0.500000 and i=10
   }
   ```

   

### Operators

#### Arithmetic Operators

| Operator | Description                                                  | Example         |
| -------- | ------------------------------------------------------------ | --------------- |
| +        | Adds two operands                                            | A + B gives 30  |
| -        | Subtracts second operand from the first                      | A - B gives -10 |
| *        | Multiplies both operands                                     | A * B gives 200 |
| /        | Divides the numerator by the denominator.                    | B / A gives 2   |
| %        | Modulus operator; gives the remainder after an integer division. | B % A gives 0   |
| ++       | Increment operator. It increases the integer value by one.   | A++ gives 11    |
| --       | Decrement operator. It decreases the integer value by one.   | A-- gives 9     |

#### Relational Operators

| Operator | Description                                                  | Example               |
| -------- | ------------------------------------------------------------ | --------------------- |
| ==       | It checks if the values of two operands are equal or not; if yes, the condition becomes true. | (A == B) is not true. |
| !=       | It checks if the values of two operands are equal or not; if the values are not equal, then the condition becomes true. | (A != B) is true.     |
| >        | It checks if the value of left operand is greater than the value of right operand; if yes, the condition becomes true. | (A > B) is not true.  |
| <        | It checks if the value of left operand is less than the value of the right operand; if yes, the condition becomes true. | (A < B) is true.      |
| >=       | It checks if the value of the left operand is greater than or equal to the value of the right operand; if yes, the condition becomes true. | (A >= B) is not true. |
| <=       | It checks if the value of left operand is less than or equal to the value of right operand; if yes, the condition becomes true. | (A <= B) is true.     |

#### Logical Operators

Example假設"A為1且B為0" 或 "A為true且B為false"

| Operator | Description                                                  | Example             |
| -------- | ------------------------------------------------------------ | ------------------- |
| &&       | Called Logical AND operator. If both the operands are non-zero, then condition becomes true. | (A && B) is false.  |
| \|\|     | Called Logical OR Operator. If any of the two operands is non-zero, then condition becomes true. | (A \|\| B) is true. |
| !        | Called Logical NOT Operator. Use to reverses the logical state of its operand. If a condition is true then Logical NOT operator will make false. | !(A && B) is true.  |

#### Bitwise Operators

| p    | q    | p & q | p \| q | p ^ q |
| ---- | ---- | ----- | ------ | ----- |
| 0    | 0    | 0     | 0      | 0     |
| 0    | 1    | 0     | 1      | 1     |
| 1    | 1    | 1     | 1      | 0     |
| 1    | 0    | 0     | 1      | 1     |

| Operator |                         Description                          |                  Example                  |
| :------: | :----------------------------------------------------------: | :---------------------------------------: |
|    &     | Binary AND Operator copies a bit to the result if it exists in both operands. | (A & B) will give 12, which is 0000 1100  |
|    \|    | Binary OR Operator copies a bit if it exists in either operand. | (A \| B) will give 61, which is 0011 1101 |
|    ^     | Binary XOR Operator copies the bit if it is set in one operand but not both. | (A ^ B) will give 49, which is 0011 0001  |
|    <<    | Binary Left Shift Operator. The left operands value is moved left by the number of bits specified by the right operand. |  A << 2 will give 240 which is 1111 0000  |
|    >>    | Binary Right Shift Operator. The left operands value is moved right by the number of bits specified by the right operand. |  A >> 2 will give 15 which is 0000 1111   |

#### Assignment Operators

| Operator | Description                                                  | Example                                     |
| -------- | ------------------------------------------------------------ | ------------------------------------------- |
| =        | Simple assignment operator, Assigns values from right side operands to left side operand | C = A + B will assign value of A + B into C |
| +=       | Add AND assignment operator, It adds right operand to the left operand and assign the result to left operand | C += A is equivalent to C = C + A           |
| -=       | Subtract AND assignment operator, It subtracts right operand from the left operand and assign the result to left operand | C -= A is equivalent to C = C - A           |
| *=       | Multiply AND assignment operator, It multiplies right operand with the left operand and assign the result to left operand | C *= A is equivalent to C = C * A           |
| /=       | Divide AND assignment operator, It divides left operand with the right operand and assign the result to left operand | C /= A is equivalent to C = C / A           |
| %=       | Modulus AND assignment operator, It takes modulus using two operands and assign the result to left operand | C %= A is equivalent to C = C % A           |
| <<=      | Left shift AND assignment operator                           | C <<= 2 is same as C = C << 2               |
| >>=      | Right shift AND assignment operator                          | C >>= 2 is same as C = C >> 2               |
| &=       | Bitwise AND assignment operator                              | C &= 2 is same as C = C & 2                 |
| ^=       | bitwise exclusive OR and assignment operator                 | C ^= 2 is same as C = C ^ 2                 |
| \|=      | bitwise inclusive OR and assignment operator                 | C \|= 2 is same as C = C \| 2               |

#### Miscellaneous Operators

用在指標的，和C跟C++一樣

| Operator | Description                        | Example                                      |
| -------- | ---------------------------------- | -------------------------------------------- |
| &        | Returns the address of a variable. | &a; provides actual address of the variable. |
| *        | Pointer to a variable.             | *a; provides pointer to a variable.          |



#### Operators Precedence in Go



| Category       | Operator                          | Associativity |
| -------------- | --------------------------------- | ------------- |
| Postfix        | () [] -> . ++ - -                 | Left to right |
| Unary          | + - ! ~ ++ - - (type)* & sizeof   | Right to left |
| Multiplicative | * / %                             | Left to right |
| Additive       | + -                               | Left to right |
| Shift          | << >>                             | Left to right |
| Relational     | < <= > >=                         | Left to right |
| Equality       | == !=                             | Left to right |
| Bitwise AND    | &                                 | Left to right |
| Bitwise XOR    | ^                                 | Left to right |
| Bitwise OR     | \|                                | Left to right |
| Logical AND    | &&                                | Left to right |
| Logical OR     | \|\|                              | Left to right |
| Assignment     | = += -= *= /= %=>>= <<= &= ^= \|= | Right to left |
| Comma          | ,                                 | Left to right |



### Decision Making

#### if

`if` `else if` `else`的用法和C家族一模一樣，就略過不提了

條件的小括號可加可不加

#### switch

基本上和C家族一樣不過不需要`break`

條件的小括號一樣可加可不加

#### select

類似於 `switch`但又有點不一樣

或者說感覺更像連續的`if`

直接看範例比較快

```go
package main

import "fmt"

func main() {
   var c1, c2, c3 chan int
   var i1, i2 int
   select {
      case i1 = <-c1:
         fmt.Printf("received ", i1, " from c1\n")
      case c2 <- i2:
         fmt.Printf("sent ", i2, " to c2\n")
      case i3, ok := (<-c3):  // same as: i3, ok := <-c3
         if ok {
            fmt.Printf("received ", i3, " from c3\n")
         } else {
            fmt.Printf("c3 is closed\n")
         }
      default:
         fmt.Printf("no communication\n")
   }    
}   
```

關於甚麼是`chan int` 甚麼是`<-`，先留到Channel筆記再詳談，不然這篇筆記的篇幅太大了

### Loop

#### for

`Go`沒有`while`，`while`的功能被整合到`for`裡面了

```go
for [condition |  ( init; condition; increment ) | Range] {
   statement(s);
}
```

範例

```go
package main

import "fmt"

func main() {
   var b int = 15
   var a int
   numbers := [6]int{1, 2, 3, 5} 

   /* for loop execution */
   for a := 0; a < 10; a++ {
      fmt.Printf("value of a: %d\n", a)
   }
   for a < b {
      a++
      fmt.Printf("value of a: %d\n", a)
   }
   for i,x:= range numbers {
      fmt.Printf("value of x = %d at %d\n", x,i)
   }   
}
```



另外 `break` `continue` `goto`和C家族一樣，就不多提了

### Functions

注意一下格式就好了，沒甚麼特別的

```go
func function_name( [parameter list] ) [return_types]
{
   body of the function
}
```



### Methods

類似物件導向的`method`

```go
func (variable_name variable_data_type) function_name() [return_type]{
   /* function body*/
}
```

`variable_name`被稱為receiver，就是執行方法的那個物件(雖然go好像沒有物件的說法)

範例

```go
package main

import (
   "fmt" 
   "math" 
)

/* define a circle */
type Circle struct {
   x,y,radius float64
}

/* define a method for circle */
func(circle Circle) area() float64 {
   return math.Pi * circle.radius * circle.radius
}

func main(){
   circle := Circle{x:0, y:0, radius:5}
   fmt.Printf("Circle area: %f", circle.area()) //Circle area: 78.539816
}
```

在我看來好像把 Circle放在一般function的argument位置也沒有差別就是了