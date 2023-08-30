# String Buffer

tags: #c_sharp #dart #golang #string_buffer #string_builder

## Motivation

In languages like Go, Dart, and C#, strings are usually immutable, which means that whenever you modify a string, a new copy is created. This can be inefficient, especially when dealing with frequent modifications. String buffers provide a solution to this problem.

## How String Buffers Work

String buffers are like containers that hold the characters of a string. They allocate memory dynamically and grow as needed. Instead of creating new strings, they modify the content directly, reducing memory consumption and improving performance.

## Example

### Go

```go
package main

import (
	"bytes"
	"fmt"
)

func main() {
	var buffer bytes.Buffer
	buffer.WriteString("Hello, ")
	buffer.WriteString("Gopher!")
	fmt.Println(buffer.String())
}
```

### Dart

```dart
void main() {
  StringBuffer buffer = StringBuffer();
  buffer.write('Hello, ');
  buffer.write('Dart!');
  print(buffer.toString());
}
```

### C\#

```csharp
using System;
using System.Text;

class Program {
    static void Main(string[] args) {
        StringBuilder buffer = new StringBuilder();
        buffer.Append("Hello, ");
        buffer.Append("C#!");
        Console.WriteLine(buffer.ToString());
    }
}
```

## Benchmark (golang)

```go
func concatWithString(n int) string {
	result := ""
	for i := 0; i < n; i++ {
		result += "abcdefg12345"
	}
	return result
}

func concatWithBuffer(n int) string {
	var buffer bytes.Buffer
	for i := 0; i < n; i++ {
		buffer.WriteString("abcdefg12345")
	}
	return buffer.String()
}

const n = 10000

func BenchmarkStringConcatenation(b *testing.B) {
	for i := 0; i < b.N; i++ {
		_ = concatWithString(n)
	}
}

func BenchmarkBufferConcatenation(b *testing.B) {
	for i := 0; i < b.N; i++ {
		_ = concatWithBuffer(n)
	}
}
```

where n = 10000

![image](https://i.imgur.com/v8Krspl.png)

where n = 100

![image](https://i.imgur.com/Rz51he3.png)

where n = 10

![image](https://i.imgur.com/NmDu6wK.png)

where n = 3

![image](https://i.imgur.com/TxgGrYc.png)

## Benefits

- Efficient string manipulation.
- Reduces memory overhead.
- Improves performance when building strings.

## Limitations

- May not be suitable for all string manipulation scenarios.
- Requires understanding of the API for effective use.
