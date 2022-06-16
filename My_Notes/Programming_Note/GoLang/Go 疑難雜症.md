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



## Only addressable objects can be assigned

![](https://i.imgur.com/RLpkiLe.png)

參考[StackOverFlow](https://stackoverflow.com/questions/32751537/why-do-i-get-a-cannot-assign-error-when-setting-value-to-a-struct-as-a-value-i)

[official docs](https://go.dev/ref/spec#Assignments)

簡單來說就是map裡面的物件的屬性不能直接assign，可以把整個value拿出來改完後再重新把整個value assign回去，或者把value改成指標

```go
package main

import "fmt"

func main() {
	testMap := make(map[int]AA)
	testMap[0] = AA{A: 2}
	testMap[0].a = 5 // ./prog.go:8:2: cannot assign to struct field testMap[0].a in map
	fmt.Println(testMap[0].a)
}

type AA struct {
	a int
}

```



同樣的情況在其他語言是否能行得通呢?

下面來試試



### C#(OK)

在C#試過是可以進行指派的

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        Dictionary<int, AA> testDic = new();
        testDic[0] = new();
        testDic[0].a = 5;
        Console.WriteLine(testDic[0].a);
    }
}
public class AA
{
    public int a;
}
```

### TypeScript(SKIP)

TypeScript的Map是使用`get()`和`set()`肯定沒問題，所以就沒試了



### Dart(NG)

dart 也無法直接指派，不過情況和go不太一樣

```dart
void main() {
  var testMap = <int,AA>{};
  testMap[0] = AA();
  testMap[0].a = 5; // The property 'a' can't be unconditionally accessed because the receiver can be 'null'.
  print(testMap[0].a); // The property 'a' can't be unconditionally accessed because the receiver can be 'null'.
}

class AA{
  int a = 0;
}
```

[參考文件](https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=unchecked_use_of_nullable_value#unchecked_use_of_nullable_value)

比較簡單的解法就是，讓他不再是nullable

![](https://i.imgur.com/uIlLegO.png)

```dart
void main() {
  var testMap = <int,AA>{};
  testMap[0] = AA();
  testMap[0]!.a = 5;
  print(testMap[0]!.a);
}

class AA{
  int a = 0;
}
```

or

```dart
void main() {
  var testMap = <int,AA>{};
  testMap[0] = AA();
  testMap[0]?.a = 5;
  print(testMap[0]?.a);
}

class AA{
  int a = 0;
}
```



### CPP(OK)

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <map>

using namespace std;

class AA
{
public:
    int a;
};

int main()
{
    map<int, AA> testMap;
    AA aa;
    testMap[0] = aa;
    testMap[0].a = 5;
    cout << testMap[0].a << endl;
    return 0;
}
```



## net/http 相關

夾帶文件發送請求時請注意，不能直接把文件當作io.Reader發送。會由於文件還沒被Close導致接收到Header不完整的Response。只能把內容放到其他物件中再發送請求。
