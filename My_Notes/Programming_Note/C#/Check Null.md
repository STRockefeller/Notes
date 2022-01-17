# Check Null 

整理一下查看是否為null的方法

## General

== null

```C#
// 直接用==判斷
string str = null;
if(str==null)
    return false;
```

---

??

```C#
// 用法接近?:運算子，但專門針對null判別
string test()
{
    string str = null;
    return str ?? ""; // return str==null ? "":str
}
```

[MSDN](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/null-coalescing-operator)

---

C#8.0後支援 ??= 運算子可以對null狀態的物件賦予初始值

```C#
List<int> numbers = null;
int? a = null;

(numbers ??= new List<int>()).Add(5);
Console.WriteLine(string.Join(" ", numbers));  // output: 5

numbers.Add(a ??= 0);
Console.WriteLine(string.Join(" ", numbers));  // output: 5 0
Console.WriteLine(a);  // output: 0
```



## string

IsNullOrEmpty

```C#
string str = null;
if(string.IsNullOrEmpty(str))
    return false;
```

---



## IEnumerable

?.Any() or ?.Count()

```C#
List<string> strList = null;
bool? res = strList?.Any(); // ?.Any() 回傳bool?可能是true/false/null所以不能當一般的bool使用

if(res ?? false){} // ??運算子很適合在這個時候使用

// ?.Count() 同理
if ((strList?.Count() ?? 0) > 0) { } // 注意這邊要用()把??運算包起來，具體原因我也不清楚，或許是比較運算子的優先度比較高?
```



