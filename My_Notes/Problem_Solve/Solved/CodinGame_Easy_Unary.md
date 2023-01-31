# Codingame:Unary:20211229:Typescript

#problem_solve #codingame/easy #typescript

[Reference](https://www.codingame.com/ide/puzzle/chuck-norris)

## Question

### The Goal

Binary with 0 and 1 is good, but binary with only 0, or almost, is even better!

Write a program that takes an incoming message as input and displays as output the message encoded using this method.

### Rules

Here is the encoding principle:

- The input message consists of ASCII characters (7-bit)

- The encoded output message consists of blocks of 0

- A block is separated from another block by a space

- Two consecutive blocks are used to produce a series of same value bits (only

  1

  or

  0

  values):

  \- First block: it is always 0 or 00. If it is 0, then the series contains 1, if not, it contains 0
  \- Second block: the number of 0 in this block is the number of bits in the series

### Example

Let’s take a simple example with a message which consists of only one character: Capital C. C in binary is represented as 1000011, so with this method, this gives:

- 0 0 (the first series consists of only a single 1)
- 00 0000 (the second series consists of four 0)
- 0 00 (the third consists of two 1)

So C is coded as: 0 0 00 0000 0 00

Second example, we want to encode the message CC (i.e. the 14 bits 10000111000011) :

- 0 0 (one single 1)
- 00 0000 (four 0)
- 0 000 (three 1)
- 00 0000 (four 0)
- 0 00 (two 1)

So CC is coded as: 0 0 00 0000 0 000 00 0000 0 00

### Game Input

Input

**Line 1:** the message consisting of N ASCII characters (without carriage return)

Output

The encoded message

Constraints

0 < N < 100

Example

Input

```
C
```

Output

```
0 0 00 0000 0 00
```

## Initialization

Go 初始狀態

```go
package main

import "fmt"
import "os"
import "bufio"

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Buffer(make([]byte, 1000000), 1000000)

    scanner.Scan()
    MESSAGE := scanner.Text()
    _ = MESSAGE // to avoid unused error
    
    // fmt.Fprintln(os.Stderr, "Debug messages...")
    fmt.Println("answer")// Write answer to stdout
}
```

C#

```C#
using System;
using System.Linq;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
class Solution
{
    static void Main(string[] args)
    {
        string MESSAGE = Console.ReadLine();

        // Write an answer using Console.WriteLine()
        // To debug: Console.Error.WriteLine("Debug messages...");

        Console.WriteLine("answer");
    }
}
```

Dart

```dart
import 'dart:io';
import 'dart:math';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s == null ? '' : s;
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    String MESSAGE = readLineSync();

    // Write an answer using print()
    // To debug: stderr.writeln('Debug messages...');

    print('answer');
}
```

TypeScript

```typescript
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

const MESSAGE: string = readline();

// Write an answer using console.log()
// To debug: console.error('Debug messages...');

console.log('answer');

```

## My Solution

題目看完後覺得還挺簡單的，就拿來練習熟悉度比較低的語言吧。

題目會給一個string，我需要把裡面逐個字元轉換成ascii再轉換成binary再根據題目的規則轉換成'0'和' '組成的字串

比較要注意的地方是，根據範例:

1. 在字串長度大於一時，從ascii轉成binary時要逐字轉

2. 從binary要套用規則時，要合併在一起轉

```typescript
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

 const MESSAGE: string = readline();

 // Write an answer using console.log()
 // To debug: console.error('Debug messages...');
 
 var binaryArr: string[] = [];
 var res: string = "";
 [...MESSAGE].forEach(c => binaryArr.push((c.charCodeAt(0) >>> 0).toString(2)));
 // join string array
 res = BinaryToZeroBlocks(binaryArr.join(""))
 
 
 console.log(res);
 
 function BinaryToZeroBlocks(b: string): string {
     return BinaryToZeroBlocksLoop(b, "");
 }

 function BinaryToZeroBlocksLoop(b: string, res: string): string {
     var bArr = [...b];
     res += TurnZero(bArr);
     bArr = SkipUntil(bArr, '1');
 
     res += TurnOne(bArr);
     bArr = SkipUntil(bArr, '0');
     if (bArr.length === 0) {
         return res;
     }
     return BinaryToZeroBlocksLoop(bArr.join(""), res);
 }
 
 function TurnUnary(bArr: string[], target: string): string {
     var symbol: string = target == '1' ? '0 ' : '00 ';
     var res: string = "";
     var count = 0;
     for (const elem of bArr) {
         if (elem === target) {
             count++;
         } else {
             if (count != 0) {
                 res += symbol;
                 for (var i = 0; i < count; i++) {
                     res += '0';
                 }
                 res += ' ';
             }
             break;
         }
         if (count === bArr.length) {
             res += symbol;
             for (var i = 0; i < count; i++) {
                 res += '0';
             }
         }
     }
     return res;
 }
 
 function TurnOne(bArr: string[]): string {
     return TurnUnary(bArr, '1');
 }
 
 function TurnZero(bArr: string[]): string {
     return TurnUnary(bArr, '0');
 }
 
 function SkipUntil(bArr: string[], target: string): string[] {
     var result: string[] = [];
     var flag: boolean = false;
     for (const b of bArr) {
         if (flag) {
             result.push(b);
         } else {
             if (b === target) {
                 flag = true;
                 result.push(b)
             }
         }
     }
     return result
 }

function readline(): string {
    throw new Error("Function not implemented.");
}

```

結果測試對兩個錯兩個

輸入 "C" 和 "CC" 是對的

輸入 "%" 和長字串是錯的

'%'的錯誤如下

```bash
Standard Output Stream:
0 0 00 00 0 0 00 0 0 0
Failure
Found:    0 0 00 00 0 0 00 0 0 0
Expected: 00 0 0 0 00 00 0 0 00 0 0 0
```

到這邊我才發現我可能對題目有點誤解

查ascii table `%`==>37

37  ==Binary==> 100101

在套用規則 輸出: `0 0 00 00 0 0 00 0 0 0`

~~很好，我沒錯，錯的是題目~~

重新看一次題目注意到了這行

> The input message consists of ASCII characters (7-bit)

後面的7-bit因為不曉得是甚麼意思所以就忽略掉了，現在看看覺得問題很可能出在這裡。

我`%`的binary輸出有6個bits，試著在前面補0湊到7個

0100101

套規則

```
00 0 0 0 00 00 0 0 00 0 0 0
```

結果和Expected一樣

很好，看來找到關鍵了

現在回頭看"C"和"CC"為甚麼可以過

C ==ASCII==> 67 ==binary==> 1000011

一開始就是7-bit所以沒有問題

加入一些leading zero

```typescript
 const MESSAGE: string = readline();
 
 var binaryArr: string[] = [];
 var res: string = "";
 [...MESSAGE].forEach(c => binaryArr.push(CharToBinary(c)));
 res = BinaryToZeroBlocks(binaryArr.join(""))
 
 
 console.log(res);
 
 function BinaryToZeroBlocks(b: string): string {
     return BinaryToZeroBlocksLoop(b, "");
 }

 function CharToBinary(c:string):string{
     var res = (c.charCodeAt(0) >>> 0).toString(2);
     while(res.length<7){
         res = "0"+res;
     }
     return res;
 }

 function BinaryToZeroBlocksLoop(b: string, res: string): string {
     var bArr = [...b];
     res += TurnZero(bArr);
     bArr = SkipUntil(bArr, '1');
 
     res += TurnOne(bArr);
     bArr = SkipUntil(bArr, '0');
     if (bArr.length === 0) {
         return res;
     }
     return BinaryToZeroBlocksLoop(bArr.join(""), res);
 }
 
 function TurnUnary(bArr: string[], target: string): string {
     var symbol: string = target == '1' ? '0 ' : '00 ';
     var res: string = "";
     var count = 0;
     for (const elem of bArr) {
         if (elem === target) {
             count++;
         } else {
             if (count != 0) {
                 res += symbol;
                 for (var i = 0; i < count; i++) {
                     res += '0';
                 }
                 res += ' ';
             }
             break;
         }
         if (count === bArr.length) {
             res += symbol;
             for (var i = 0; i < count; i++) {
                 res += '0';
             }
         }
     }
     return res;
 }
 
 function TurnOne(bArr: string[]): string {
     return TurnUnary(bArr, '1');
 }
 
 function TurnZero(bArr: string[]): string {
     return TurnUnary(bArr, '0');
 }
 
 function SkipUntil(bArr: string[], target: string): string[] {
     var result: string[] = [];
     var flag: boolean = false;
     for (const b of bArr) {
         if (flag) {
             result.push(b);
         } else {
             if (b === target) {
                 flag = true;
                 result.push(b);
             }
         }
     }
     return result;
 }

```

就可以順利通過了

## Better Solutions
