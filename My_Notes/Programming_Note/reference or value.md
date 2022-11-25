# Reference or Value

參考型別?值型別?

傳值?傳址?

常常忘記這邊整理起來，供以後快速查找

## 懶人包

### C

### CPP

### C #

### dart

1. All variables in dart store a reference to the value rather than containing the value.

2. Dart is only passed by value

### go

In Go, there is no such thing as passing by reference. Everything is passed by value.

### TypeScript

[你不可不知的 JavaScript 二三事#Day26：程式界的哈姆雷特 —— Pass by value, or Pass by reference？](https://ithelp.ithome.com.tw/articles/10209104)

## Sort By Types

### Array/List

#### C Array

**Pass By Reference**

```C
#include <stdio.h>
#include <stdlib.h>

void foo(int arr[3])
{
    arr[2] = 5;
}

int main()
{
    int arr[3] = {1, 2, 3};
    foo(arr);
    printf("%d\n",arr[2]); // 5

    return 0;
}
```

reassign

```c
#include <stdio.h>
#include <stdlib.h>

void foo(int arr[3])
{
    int temp[3] = {1, 2, 5};
    arr = temp;
}

int main()
{
    int arr[3] = {1, 2, 3};
    foo(arr);
    printf("%d\n", arr[2]); // 3

    return 0;
}
```

同dart

#### CPP Array

**Pass By Reference**

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

void foo(int arr[3])
{
    arr[2] = 5;
}

int main()
{
    int arr[3] = {1, 2, 3};
    foo(arr);
    cout << arr[2] << endl; // 5
    return 0;
}
```

reassign

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

void foo(int arr[3])
{
    int temp[3] = {1, 2, 5};
    arr = temp;
}

int main()
{
    int arr[3] = {1, 2, 3};
    foo(arr);
    cout << arr[2] << endl; // 3
    return 0;
}
```

同 dart

印出指標來看

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

void foo(int arr[3])
{
     cout << "&arr: " << &arr << ", &arr[0]: " << &arr[0] << endl; // &arr: 0x7fffd32249f8, &arr[0]: 0x7fffd3224a20
    int temp[3] = {1, 2, 5};
    arr = temp;
      cout << "&arr: " << &arr << ", &arr[0]: " << &arr[0] << endl; // &arr: 0x7fffd32249f8, &arr[0]: 0x7fffd32249ec
}

int main()
{
    int arr[3] = {1, 2, 3};
      cout << "&arr: " << &arr << ", &arr[0]: " << &arr[0] << endl; // &arr: 0x7fffd3224a20, &arr[0]: 0x7fffd3224a20
    foo(arr);
    cout << arr[2] << endl; // 3
    return 0;
}
```

#### CPP Vector

**Pass By Value**

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>

using namespace std;

void foo(vector<int> v)
{
    v[2] = 5;
}

int main()
{
    vector<int> v = {1,2,3};
    foo(v);
    cout << v[2] << endl; // 3
    return 0;
}
```

印出指標來看

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>

using namespace std;

void foo(vector<int> v)
{
    cout << "&v: " << &v << ", &v[0]: " << &v[0] << endl; // &v: 0x7ffe008864c8, &v[0]: 0x1dce2e0
    v[2] = 5;
}

int main()
{
    vector<int> v = {1, 2, 3};
    cout << "&v: " << &v << ", &v[0]: " << &v[0] << endl; // &v: 0x7ffe00886510, &v[0]: 0x1dcdeb0
    foo(v);
    cout << v[2] << endl; // 3
    return 0;
}
```

#### C# Array

**reference type**

`System.Array` 繼承了 `System.Object` 所以同為 reference type

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        int[] arr = { 1, 2, 3 };
        foo(arr);
        Console.WriteLine(arr[2]); // 5
    }
 
    private static void foo(int[] arr)
    {
        arr[2] = 5;
    }
}
```

reassign

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        int[] arr = { 1, 2, 3 };
        foo(arr);
        Console.WriteLine(arr[2]); // 3
    }

    private static void foo(int[] arr)
    {
        arr = new int[] { 1, 2, 5 };
    }
}
```

#### C# List

**reference type**

修改指定index

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        List<int> lst = new List<int>() { 1, 2, 3 };
        foo(lst);
        Console.WriteLine(lst[2]); // 5
    }
    private static void foo(List<int> lst)
    {
        lst[2] = 5;
    }
}
```

reassign

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        List<int> lst = new List<int>() { 1, 2, 3 };
        foo(lst);
        Console.WriteLine(lst[2]); // 3
    }
    private static void foo(List<int> lst)
    {
        lst = new List<int>() { 1, 2, 5 };
    }
}
```

同dart

#### dart List

**reference type**

```dart
void main() {
  var arr = [1, 2, 3];
  foo(arr);
  print(arr[2]); // 5
}

void foo(List arr) {
  arr[2] = 5;
}

```

```dart
void main() {
  var arr = [1, 2, 3];
  var arr2 = arr;
  arr.clear();
  print(arr2); // []
}

```

reassign 就不會影響到其他的物件(因為已經指向其他位址了)

```dart
void main() {
  var arr = [1, 2, 3];
  var arr2 = arr;
  arr = [4, 5, 6];
  print(arr2); // [1, 2, 3]
}

```

dart 其他型別也是類似的情況，就不一一細說了

#### go Array

**pass by value**

```go
package main

import "fmt"

func main() {
 arr := [3]int{1, 2, 3}
 foo(arr)
 fmt.Println(arr[2]) // 3
}

func foo(arr [3]int) {
 arr[2] = 5
}

```

印出指標來看

```go
package main

import "fmt"

func main() {
 arr := [3]int{1, 2, 3}
 fmt.Printf("arr = %p, arr[0] = %p\n", &arr, &arr[0]) // arr = 0xc0000b8000, arr[0] = 0xc0000b8000
 foo(arr)
 fmt.Println(arr[2]) // 3
}

func foo(arr [3]int) {
 fmt.Printf("arr = %p, arr[0] = %p\n", &arr, &arr[0]) // arr = 0xc0000b8030, arr[0] = 0xc0000b8030
 arr[2] = 5
}

```

#### go Slice

**pass by value , but the value is len, cap and address**

基本上跟下面的typescript array相似

指定index修改

```go
package main

import "fmt"

func main() {
 slc := []int{1, 2, 3}
 foo(slc)
 fmt.Println(slc[2]) // 5
}

func foo(slc []int) {
 slc[2] = 5
}

```

reassign

```go
package main

import "fmt"

func main() {
 slc := []int{1, 2, 3}
 foo(slc)
 fmt.Println(slc[2]) // 3
}

func foo(slc []int) {
 slc = []int{1, 2, 5}
}

```

golang 我們就可以印出指標來驗證了

```go
package main

import "fmt"

func main() {
 slc := []int{1, 2, 3}
 fmt.Printf("slc = %p, slc[0] = %p\n", &slc, &slc[0]) //slc = 0xc00009c000, slc[0] = 0xc00009e000
 foo(slc)
 fmt.Println(slc[2]) // 3
}

func foo(slc []int) {
 fmt.Printf("slc = %p, slc[0] = %p\n", &slc, &slc[0]) // slc = 0xc00009c018, slc[0] = 0xc00009e000
 slc = []int{1, 2, 5}
 fmt.Printf("slc = %p, slc[0] = %p\n", &slc, &slc[0]) // slc = 0xc00009c018, slc[0] = 0xc00009e030
}

```

[Are slices passed by value?](https://stackoverflow.com/questions/39993688/are-slices-passed-by-value)

#### TypeScript Array

**pass by sharing?**

指定index修改

```typescript
function main():void{
  const arr:Array<number> = [1,2,3];
  foo(arr);
  console.log(arr[2]); // 5
}

function foo(arr:Array<number>):void{
  arr[2] = 5;
}

main();
```

reassign

```typescript
function main():void{
  const arr:Array<number> = [1,2,3];
  foo(arr);
  console.log(arr[2]); // 3
}

function foo(arr:Array<number>):void{
  arr = [1,2,5];
}

main();
```

我是理解成
$$
假如 在main裡面 arr(0x0001)\rightarrow[1,2,3](0x1001)\\
在foo裡面 arr(0x0002)\rightarrow[1,2,3](0x1001)\\
所以case1修改foo的arr[2]會影響到main的arr\\
case2中因為做了reassign所以 arr(0x0002)\rightarrow[1,2,5](0x1002) 指向了一個新的位址，故不會影響main的arr
$$

補充:將array value取出後修改。

```typescript
function main():void{
  const arr = [{num:1},{num:2},{num:3}];
  console.log(arr[1].num); // 2

  let a = arr[1];
  a.num = 10;
  console.log(arr[1].num); // 10
}

main();
```

```typescript
function main():void{
  const arr = [1,2,3];
  console.log(arr[1]); // 2

  let a = arr[1];
  a = 10;
  console.log(arr[1]); // 2
}

main();
```

詳請可以參考下方class的特性說明。

### Map/Set

#### C Map

copy a new map

```c
#include <stdio.h>
#include <stdlib.h>
#include <map>

void foo(std::map<int, int> m)
{
    m[1] = 200;
}

int main()
{
    std::map<int, int> m = {
        {1, 100}};
    foo(m);
    printf("%d\n", m[1]); // 100

    return 0;
}
```

c 和 cpp 都使引用同來源的map，詳細可以看下面cpp的結果

#### CPP Map

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <map>

using namespace std;

void foo(map<int, int> m)
{
    cout << "&m: " << &m << ", &m[1]: " << &m[1] << endl; // &m: 0x7fffd39417d8, &m[1]: 0x1402314
    m[1] = 200;
    cout << "&m: " << &m << ", &m[1]: " << &m[1] << endl; // &m: 0x7fffd39417d8, &m[1]: 0x1402314
}

int main()
{
    map<int, int> m = {
        {1, 100}};
    cout << "&m: " << &m << ", &m[1]: " << &m[1] << endl; // &m: 0x7fffd3941848, &m[1]: 0x1401ed4
    foo(m);
    cout << m[1] << endl; // 100
    return 0;
}
```

#### CPP Set

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <set>

using namespace std;

void foo(set<int> s)
{
    cout << "&s: " << &s << endl; // &s: 0x7ffd25127dd0
    s.insert(4);
    cout << "&s: " << &s << endl; // &s: 0x7ffd25127dd0
}

int main()
{
    set<int> s{1, 2, 3};

    cout << "&s: " << &s << endl; // &s: 0x7ffd25127e38
    foo(s);
    cout << s.count(4) << endl; // 0
    return 0;
}
```

#### C# Dictionary

**reference type**

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        Dictionary<int, int> d = new Dictionary<int, int>(){
            {1,100}
        };
        foo(d);
        Console.WriteLine(d[1]); // 200
    }

    private static void foo(Dictionary<int, int> d)
    {
        d[1] = 200;
    }
}
```

reassign

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        Dictionary<int, int> d = new Dictionary<int, int>(){
            {1,100}
        };
        foo(d);
        Console.WriteLine(d[1]); // 100
    }

    private static void foo(Dictionary<int, int> d)
    {
        d = new Dictionary<int, int>(){
            {1,200}
        };
    }
}
```

#### C# HashSet

**reference type**

```C#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        HashSet<int> h = new HashSet<int>() { 1, 2, 3 };
        foo(h);
        Console.WriteLine(h.Contains(4)); // true
    }

    private static void foo(HashSet<int> h)
    {
        h.Add(4);
    }
}
```

reassign

```c#
using System.Collections.Generic;
using System;

public class Program
{
    public static void Main()
    {
        HashSet<int> h = new HashSet<int>() { 1, 2, 3 };
        foo(h);
        Console.WriteLine(h.Contains(4)); // false
    }

    private static void foo(HashSet<int> h)
    {
        h = new HashSet<int>() { 1, 2, 3, 4 };
    }
}
```

#### dart Map

**reference type**

```dart
void main() {
  var m = <int, int>{1: 100};
  foo(m);
  print(m[1]); // 200
}

void foo(Map<int, int> m) {
  m[1] = 200;
}

```

reassign

```dart
void main() {
  var m = <int, int>{1: 100};
  foo(m);
  print(m[1]); // 100
}

void foo(Map<int, int> m) {
  m = <int, int>{1: 200};
}

```

#### dart Set

**reference type**

```dart
void main() {
  var s = <int>{1, 2, 3};
  foo(s);
  print(s.contains(4)); // true
}

void foo(Set<int> s) {
  s.add(4);
}

```

#### go Map

**reference type**

```go
package main

import "fmt"

func main() {
 m := make(map[int]int)
 m[1] = 100

 fmt.Printf("m = %p\n", &m) // m = 0xc00000e028
 foo(m)
 fmt.Println(m[1]) // 200
}

func foo(m map[int]int) {
 fmt.Printf("m = %p\n", &m) // m = 0xc00000e038
 m[1] = 200
}

```

reassign

```go
package main

import "fmt"

func main() {
 m := make(map[int]int)
 m[1] = 100

 fmt.Printf("m = %p\n", &m) // m = 0xc00000e028
 foo(m)
 fmt.Println(m[1]) // 100
}

func foo(m map[int]int) {
 fmt.Printf("m = %p\n", &m) // m = 0xc00000e038
 m = map[int]int{1: 200}
 fmt.Printf("m = %p\n", &m) // m = 0xc00000e038
}

```

#### TypeScript Map

**pass by sharing**

```typescript
function main():void{
  const m = new Map<number, number>([
    [1,100]
  ]);
  foo(m);
  console.log(m[1]) // 200
}

function foo(m:Map<number, number>):void{
  m[1] = 200;
}

main();
```

> 順帶一提，ts的map還是用get set 去存取比較合適

```typescript
function main(): void {
  const m = new Map<number, number>([
    [1, 100]
  ]);
  foo(m);
  console.log(m.get(1)) // 200
}

function foo(m: Map<number, number>): void {
  m.set(1, 200);
}

main();
```

reassign

```typescript
function main(): void {
  const m = new Map<number, number>([
    [1, 100]
  ]);
  foo(m);
  console.log(m.get(1)) // 100
}

function foo(m: Map<number, number>): void {
  m = new Map<number, number>([
    [1,200]
  ]);
}

main();
```

#### TypeScript Set

**pass by sharing**

```typescript
function main(): void {
  const s = new Set<number>([1, 2, 3]);
  foo(s);
  console.log(s.has(4)) // true
}

function foo(s: Set<number>): void {
  s.add(4);
}

main();
```

### Class/Struct

#### C Struct

**pass by value**

```C
#include <stdio.h>
#include <stdlib.h>

struct person
{
    char *name;
    int age;
};

void foo(struct person p)
{
    p.name = "Ted";
}

int main()
{
    struct person p = {
        .name = "John",
        .age = 18};
    foo(p);
    printf("%s\n", p.name); // John

    return 0;
}
```

#### CPP Struct

同C

```CPP
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <set>

using namespace std;

struct Person
{
    string name;
    int age;
};
void foo(Person p)
{
    cout << "&p: " << &p << endl; // &p: 0x7ffc5f217518
    p.name = "Ted";
    cout << "&p: " << &p << endl; // &p: 0x7ffc5f217518
}

int main()
{
    Person p = {
        .name = "John",
        .age = 18};
    cout << "&p: " << &p << endl; // &p: 0x7ffc5f2175b0
    foo(p);
    cout << p.name << endl; // John
    return 0;
}
```

#### CPP Class

同struct

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <set>

using namespace std;

class Person
{
public:
    string name;
    int age;
    Person(string name, int age)
    {
        this->name = name;
        this->age = age;
    }
};
void foo(Person p)
{
    cout << "&p: " << &p << endl; // &p: 0x7fffbc177000
    p.name = "Ted";
    cout << "&p: " << &p << endl; // &p: 0x7fffbc177000
}

int main()
{
    Person p = Person("John", 18);
    cout << "&p: " << &p << endl; // &p: 0x7fffbc177060
    foo(p);
    cout << p.name << endl; // John
    return 0;
}
```

#### C# Struct

**value type**

```C#
using System.Collections.Generic;
using System;

internal struct Person
{
    internal string name;
    internal int age;
    internal Person(string name, int age)
    {
        this.name = name;
        this.age = age;
    }
}
public class Program
{
    public static void Main()
    {
        Person p = new Person("John", 18);
        foo(p);
        Console.WriteLine(p.name); // John
    }

    private static void foo(Person p)
    {
        p.name = "Ted";
    }
}
```

#### C# Class

**reference type**

```C#
using System;

internal class Person
{
    internal string name;
    internal int age;
    internal Person(string name, int age)
    {
        this.name = name;
        this.age = age;
    }
}
public class Program
{
    public static void Main()
    {
        Person p = new Person("John", 18);
        foo(p);
        Console.WriteLine(p.name); // Ted
    }

    private static void foo(Person p)
    {
        p.name = "Ted";
    }
}
```

reassign

```C#
using System;

internal class Person
{
    internal string name;
    internal int age;
    internal Person(string name, int age)
    {
        this.name = name;
        this.age = age;
    }
}
public class Program
{
    public static void Main()
    {
        Person p = new Person("John", 18);
        foo(p);
        Console.WriteLine(p.name); // John
    }

    private static void foo(Person p)
    {
         p = new Person("Ted", 18);
    }
}
```

#### dart Class

**reference type**

```dart
void main() {
  Person p = new Person("John", 18);
  foo(p);
  print(p.name); // Ted
}

class Person {
  late String name;
  late int age;
  Person(String name, int age) {
    this.name = name;
    this.age = age;
  }
}

void foo(Person p) {
  p.name = "Ted";
}

```

reassign

```dart
void main() {
  Person p = new Person("John", 18);
  foo(p);
  print(p.name); // John
}

class Person {
  late String name;
  late int age;
  Person(String name, int age) {
    this.name = name;
    this.age = age;
  }
}

void foo(Person p) {
  p = new Person("Ted", 18);
}

```

#### go Struct

**pass by value**

```go
package main

import "fmt"

func main() {
 p := Person{
  name: "John",
  age:  18,
 }

 fmt.Printf("p = %p\n", &p) // p = 0xc00000c030
 foo(p)
 fmt.Println(p.name) // John
}

func foo(p Person) {
 fmt.Printf("p = %p\n", &p) // p = 0xc00000c048
 p.name = "Ted"
 fmt.Printf("p = %p\n", &p) // p = 0xc00000c048
}

type Person struct {
 name string
 age  int
}

```

#### TypeScript Class

**pass by sharing**

```typescript
class Person {
  name: string;
  age: number;
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

function main(): void {
  const p = new Person('John', 18);
  foo(p);
  console.log(p.name) // Ted
}

function foo(p: Person): void {
  p.name = 'Ted';
}

main();
```

reassign

```typescript
class Person {
  name: string;
  age: number;
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}

function main(): void {
  const p = new Person('John', 18);
  foo(p);
  console.log(p.name) // John
}

function foo(p: Person): void {
  p = new Person('Ted', 18);
}

main();
```
