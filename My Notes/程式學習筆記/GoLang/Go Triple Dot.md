# ...

Reference:

[ITHELP](https://ithelp.ithome.com.tw/articles/10243319)



## Abstract

這東西有滿多不同用法的，特此紀錄



## Auto-Size Array

在Slice筆記有提到過，自動給Array合適的大小

```go
func main() {
	arr := [...]int{1, 2, 3, 4, 5}
	fmt.Println(arr) //[1 2 3 4 5]
}
```



## 把輸入的多個參數變成Slice

```go
func main() {
	printNums(1, 2, 3, 4, 5)
}
func printNums(nums ...int) {
	fmt.Printf("the type of nums is %T\r\n", nums) //the type of nums is []int
	for _, num := range nums {
		fmt.Print(num, " ") //1 2 3 4 5
	}
}
```



## 把Slice拆成多個值

跟上面相反的作法，比如說上例若想直接傳入Slice但又不想改function

```go
func main() {
	arr := []int{1, 2, 3, 4, 5}
	printNums(arr) //cannot use arr (variable of type []int) as int value in argument to print
}
func printNums(nums ...int) {
	fmt.Printf("the type of nums is %T\r\n", nums) //the type of nums is []int
	for _, num := range nums {
		fmt.Print(num, " ") //1 2 3 4 5
	}
}
```

會因為型別不同不能這樣寫。



這時又輪到`...`出場了

改成下面這樣就可以正常運作了

```go
func main() {
	arr := []int{1, 2, 3, 4, 5}
	printNums(arr...)
}
func printNums(nums ...int) {
	fmt.Printf("the type of nums is %T\r\n", nums) //the type of nums is []int
	for _, num := range nums {
		fmt.Print(num, " ") //1 2 3 4 5
	}
}
```





## 拿來實現overload或optional parameters

算是一個比較常見的使用方法

方法簽章中使用`...`關鍵字就可以達成"不限制傳入參數個數"，進而做到類似overload或optional parameter的作法

某種程度上彌補了golang的缺憾(也違背了golang的宗旨)



舉個簡單的例子

假如說想要實現如下方法

```C#
public int Add(int a,int b)=>a+b;
public int Add(int a)=>a+1;
```

可以寫成

```go
func Add(a int,b ...[]int)int{
    if len(b)==1{
        return a+b[0]
    }else{
        return a
    }
}
```



很明顯的還是有缺點，就是使用方法的時候就算傳入一百個整數IDE也不會報錯

---

舉個複雜點的例子，如果我的optional參數無法簡單的組成一個slice

例如傳入一個`List`或`Slice`，以及一個optional `Struct`，回傳對應的內容物。*雖然很意義不明但一時想不到更適合的例子*

實作全部省略成`//...`

```C#
public int ReturnNumber(List<int> numList)=>numList[0];
public int ReturnNumber(List<int> numList,ReturnNumberOption opt)
{
    //...
}
public struct ReturnNumberOption
{
    public bool isFirst;
    public bool isLast;
    public bool isMax;
    public bool isMin;
    public int fromIndex;
}
```

寫成

```go
func ReturnNumber(numList []int,optFuncs ...ReturnNumberOption)int{
    var opt ReturnNumberOptionDetail
    for _,optFunc := range optFuncs{
        optFunc(&opt)
    }
    // 處理完後opt就相當於上例的opt了
    //...
}
type ReturnNumberOption func(*ReturnNumberOptionDetail)
type ReturnNumberOptionDetail{
    isFirst bool
    isLast bool
    //...
}
func IsFirst() ReturnNumberOption{
    return func(opt *ReturnNumberOptionDetail){
        opt.isFirst=true
    }
}
func IsLast() ReturnNumberOption{
    return func(opt *ReturnNumberOptionDetail){
        opt.isLast=true
    }
}
//...
```



有點複雜所以多解釋一點

主軸就是方法的傳遞

例子中的第二的參數是`func(*ReturnNumberOptionDetail)`的`slice`，代表可以傳入多個"參數為`*ReturnNumberOptionDetail`的function"

例如使用的時候可以

```go
var numList []int
ReturnNumber(numList,func(opt *ReturnNumberOptionDetail){opt.isFirst=true})
```

當然我們不希望每次使用的時候都寫一個完整的function在參數欄位

因此，後面設定一些配套方法來簡化這個傳入，簡化後只要寫成

```go
ReturnNumber(numList,IsFirst())
```

就可以了



另一點要注意的是，`ReturnNumber`方法接收到的是一個function slice

如果以C#來看的話是一個委派的集合，類似於

```C#
public int ReturnNumber(List<int> numList,List<Action<ReturnNumberOption>> optFuncs)
```

> 正確來說這邊的`ReturnNumberOption`應該使用class而非struct，因為Action裡面不能使用`ref`關鍵字，所以value type的struct並不合適，又或者自定義委派就可以使用`ref`關鍵字了。[參考](https://stackoverflow.com/questions/2462814/func-delegate-with-ref-variable)



所以方法的一開始要把接收到的function slice轉換成所需要的struct才能正常使用



> 題外話:以我個人而言，把全部的參數用struct包起來也挺不錯的，至少夠直觀
