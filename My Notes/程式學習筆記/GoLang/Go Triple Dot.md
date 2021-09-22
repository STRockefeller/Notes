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



