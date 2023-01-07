# Garbaga Collector

#c #cpp #garbage_collect

References:

[Garbage collection (computer science) - Wikipedia](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science))

https://stackoverflow.com/questions/47979203/how-to-free-memory-in-go

[記憶體回收的基本概念 | Microsoft Learn](https://learn.microsoft.com/zh-tw/dotnet/standard/garbage-collection/fundamentals)

[Golang 記憶體管理 GC 全面解析 - Alan 的筆記本](https://alanzhan.dev/post/2022-02-13-golang-memory-management/)

## Abstract

可以說是基礎，但會不會卻沒啥影響的東西。一直以來也都沒認真去面對它。心血來潮想了解一下底層的玩意兒，就順便把它記下來。

這篇筆記預計只會寫一些比較基礎的部分，各語言的GC機制有所不同，細節可能?或許?大概?會另外紀錄。



## Definition

> **garbage collection** (**GC**) is a form of automatic [memory management](https://en.wikipedia.org/wiki/Memory_management "Memory management"). The *garbage collector* attempts to reclaim memory which was allocated by the program, but is no longer referenced; such memory is called *[garbage](https://en.wikipedia.org/wiki/Garbage_(computer_science) "Garbage (computer science)")*.
> 
> wiki

簡單來說，GC會自動幫我們釋放掉不再被存取的記憶體位置。而不需要再手動執行`free()` `delete()` 之類的方法來釋放記憶體。實作方式有很多種，但效率顯然不會有手動執行來的好，但勝在方便，超方便，至少我現在回去寫c/cpp要手動釋放記憶體就覺得很麻煩。

如今大多數的程式語言都有預設支援GC機制，沒有支援的如c/cpp反而是少數(不過似乎也有套件可以做到，這個有待確認)



## Manually

先來回憶一下當初手動釋放記憶體有多麻煩吧。

在C語言中，我們會使用 `malloc()` 來配置記憶體、`free()` 來釋放記憶體。

```c
void *malloc(size_t size);

void free(void *ptr)
```

void pointer 我比較少用，這邊補一下[參考資料](https://medium.com/@racktar7743/c%E8%AA%9E%E8%A8%80-%E6%8C%87%E6%A8%99%E6%95%99%E5%AD%B8-%E4%BA%94-1-void-pointer-c1cb976712a3)。簡單來說就是我不知道這是什麼型別的指標。

使用起來會像是

```c
int *ptr =  (int *)malloc(sizeof(int));

free(ptr);
```



C++中則是使用`new()` 和`delete()`來完成

```cpp
string *ps = new string("hello");

delete ps;
```

`new()`方法會建立物件並且回傳該物件的指標，建立物件的流程會先呼叫`operator new()` 接著呼叫`constructor()` ，前者用於分配記憶體，後者應該不用多講了。

`delete`的順序則是倒過來，先呼叫`destructor`接著呼叫`operator delete`釋放記憶體



`operator new` 以及 `operator delete` 可以看做和前面的`malloc` 和 `free` 相同。

官方文件 new: https://cplusplus.com/reference/new/operator%20new/

delete: https://cplusplus.com/reference/new/operator%20delete/



可以直接呼叫，也可以在物件中override 他們。



再進階一點還有`allocator`以及`deallocator`，不過這邊就先點到為止，重點還是放在GC的部分。



## Fundamentals of memory

> As an application developer, you work only with virtual address space and never manipulate physical memory directly. The garbage collector allocates and frees virtual memory for you on the managed heap.
> 
> msdn

> | State     | Description                                                                                                                                                                |
> | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
> | Free      | The block of memory has no references to it and is available for allocation.                                                                                               |
> | Reserved  | The block of memory is available for your use and can't be used for any other allocation request. However, you can't store data to this memory block until it's committed. |
> | Committed | The block of memory is assigned to physical storage.                                                                                                                       |

## Memory Allocation

> When you initialize a new process, the runtime reserves a contiguous region of address space for the process. This reserved address space is called the managed heap. The managed heap maintains a pointer to the address where the next object in the heap will be allocated. Initially, this pointer is set to the managed heap's base address. All reference types are allocated on the managed heap. When an application creates the first reference type, memory is allocated for the type at the base address of the managed heap. When the application creates the next object, the garbage collector allocates memory for it in the address space immediately following the first object. As long as address space is available, the garbage collector continues to allocate space for new objects in this manner.
> 
> msdn

簡單來說當程式執行，一個新的process被建立，os會分配一段記憶體空間給這個新的process，稱為managed heap，這個process所需的記憶體都會從managed heap中進行分配。

> [![Heap Management](https://i.imgur.com/QZDuPaa.png)](https://alanzhan.dev/2022-02-13-heap-management.jpg)
> 
> 假設 heap 是目前的所擁有的 heap 記憶體，針對這個 heap 的管理主要會有三個角色跟次要輔助用的 Header：
> 
> - Allocator ： 記憶體的分配器，主要動態處理記憶體的分配請求，程式啟動時 Allocator 會在初始化的時候，預先向操作系統申請記憶體，接下來可能會先記憶體做一定的格式化。
> - Mutator ： Mutator 可以理解為我們的程式，Mutator 只要負責跟 Allocator 申請記憶體就好，他不需要顯式的去釋放(回收)記憶體。
> - Collector ： 垃圾回收器，回收記憶體空間，他會去掃描整的 heap 記憶體，哪些是活躍物件，那些是非活耀物件，當發現非活耀，就會回收記憶體。
> - Object Header ： 當記憶體分配出去時，同時會對這塊記憶體做標記，用來標記物件的， Collector 和 Allocator 會來同步物件 Metadata。

(from alanzhan.dev)

## Release Memory

> ## 常見記憶體回收策略
> 
> ### 引用計數
> 
> - 常見語言 ： Python 、 PHP 、 Swift
> - 特性 ： 對每一個物件維護一個引用計數，當引用該物件的物件被銷毀時，引用計數就減 1 ，當引用計數為 0 時，就回收該物件。
> - 優點 ： 物件可以很快的被回收，不會出現記憶體耗盡或者達到某個閥值才回收。
> - 缺點 ： 不能很好的處理循環引用，而且維護引用計數，也有一定的代價。
> 
> ### 標記清除
> 
> - 常見語言 ： golang
> - 特性 ： 從根變數開始遍歷檢查所有引用物件，引用物件被標計為「被引用」，沒有被標記的就進行回收。
> - 優點 ： 解決引用計數的缺點。
> - 缺點 ： 需要 STW (Stop the world)，即要暫停程式運行。
> 
> ### 分代收集
> 
> - 常見語言 ： Java 、 .Net(C#) 、 Nodejs (Javascript)
> - 按照生命週期進行劃分不同代空間，生命週期較長的放入老生代，短的放入新生代，新生代的回收頻率會高於老生代的頻率，通常會被分為三代。
>   - Young ： 或者被稱為 eden ，存放新創的物件，物件生命週期非常的短，幾乎用完就可以被回收。
>   - Tenured ：或者被稱為 old ， 在 Young 區多次回收後存活下來的物件，將被移轉到 Tenured 區。
>   - Perm ： 永久代，主要存加載類的資訊，生命周期較長，幾乎不會被回收。
> - 優點 ： 大部分的物件都是朝生夕死的，所以可以更高效的清除用完即丟的物件。
> - 缺點 ： 演算法較為複雜，執行的步驟較多。

(from alanzhan.dev)



更多關於 reference counting: [Reference counting - Wikipedia](https://en.wikipedia.org/wiki/Reference_counting)

更多關於 tracing garbage collection: [Tracing garbage collection - Wikipedia](https://en.wikipedia.org/wiki/Tracing_garbage_collection)

更多關於 generations: [Fundamentals of garbage collection | Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/standard/garbage-collection/fundamentals#generations)


