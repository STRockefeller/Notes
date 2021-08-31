# Codewars:Ease the StockBroker:20210830:Go

[Reference](https://www.codewars.com/kata/54de3257f565801d96001200)



## Question

Clients place orders to a stockbroker as strings. The order can be simple or multiple or empty.

Type of a simple order: Quote/white-space/Quantity/white-space/Price/white-space/Status

where Quote is formed of non-whitespace character, Quantity is an int, Price a double (with mandatory decimal point "." ), Status is represented by the letter B (buy) or the letter S (sell).

#### Example:

```
"GOOG 300 542.0 B"
```

A multiple order is the concatenation of simple orders with a comma between each.

#### Example:

```
"ZNGA 1300 2.66 B, CLH15.NYM 50 56.32 B, OWW 1000 11.623 B, OGG 20 580.1 B"
```

or

```
"ZNGA 1300 2.66 B,CLH15.NYM 50 56.32 B,OWW 1000 11.623 B,OGG 20 580.1 B"
```

To ease the stockbroker your task is to produce a string of type

`"Buy: b Sell: s"` where b and s are 'double' formatted with no decimal, b representing the total price of bought stocks and s the total price of sold stocks.

#### Example:

```
"Buy: 294990 Sell: 0"
```

Unfortunately sometimes clients make mistakes. When you find mistakes in orders, you must pinpoint these badly formed orders and produce a string of type:

```
"Buy: b Sell: s; Badly formed nb: badly-formed 1st simple order ;badly-formed nth simple order ;"
```

where nb is the number of badly formed simple orders, b representing the total price of bought stocks with correct simple order and s the total price of sold stocks with correct simple order.

#### Examples:

```
"Buy: 263 Sell: 11802; Badly formed 2: CLH16.NYM 50 56 S ;OWW 1000 11 S ;"
"Buy: 100 Sell: 56041; Badly formed 1: ZNGA 1300 2.66 ;"
```

#### Notes:

- If the order is empty, Buy is 0 and Sell is 0 hence the return is: "Buy: 0 Sell: 0".
- Due to Codewars whitespace differences will not always show up in test results.
- With Golang (and maybe others) you can use a format with "%.0f" for "Buy" and "Sell".

## My Solution

首先來分析一下題目

* 正常的輸入像是`"GOOG 300 542.0 B"` 按照順序可以拆成`Quote:string`/`Quantity:int`/`Price:float`/`Status:string`
* 如果輸入全部正確，則回傳買賣金額的總和，如`"Buy: 294990 Sell: 0"`
* 如果輸入有誤，則是回傳正確部分的買賣金額總和+"Badly formed "+錯誤的數量+(錯誤的敘述+";")*n



思路:

* 首先先以`','`split輸入字串
* 接著以`' '`split上個步驟拆出來的字串
* 判斷是否有誤，有誤的話將字串組回來並且記錄錯誤次數加一，正確的部分進行金額加總



解答

```go
func BalanceStatement(lst string) string {
	totalBuy, totalSell := 0.0, 0.0
	errorCount := 0
	var errorStrings []string
	orders := strings.Split(lst, ",")
	if len(orders)==1 && len(strings.Split(orders[0]," "))<2{
		return "Buy: 0 Sell: 0"
	}

	for _, order := range orders {
		order = strings.TrimLeft(order, " ")
		words := strings.Split(order, " ")
		if len(words) != 4 {
			errorCount++
			errorStrings = append(errorStrings, order)
			continue
		}
		quantity, err1 := strconv.Atoi(words[1])
		price, err2 := strconv.ParseFloat(words[2], 64)
		status := words[3]

		if err1 != nil || err2 != nil || !strings.Contains(words[2], ".") {
			errorCount++
			errorStrings = append(errorStrings, order)
		} else {
			switch status {
			case "B":
				totalBuy += price * float64(quantity)
			case "S":
				totalSell += price * float64(quantity)
			default:
				errorCount++
				errorStrings = append(errorStrings, order)
			}
		}
	}

	res := fmt.Sprintf("Buy: %.0f Sell: %.0f", totalBuy, totalSell)
	if errorCount != 0 {
		res += fmt.Sprintf("; Badly formed %d: ", errorCount)
		for _, str := range errorStrings {
			res += fmt.Sprintf("%s ;", str)
		}
	}
	return res
}
```

有兩個地方是寫完之後才修改的

1. 價格的浮點數判斷，如果填寫整數屬於badly formed，所以多了小數點的判別

   ```go
   !strings.Contains(words[2], ".")
   ```

2. 空白輸入不應該被認為是badly formed，所以多了獨立判斷

   ```go
   if len(orders)==1 && len(strings.Split(orders[0]," "))<2{
   		return "Buy: 0 Sell: 0"
   	}
   ```

   

## Better Solutions



### Solution 1

```go
package kata

import (
    "strings"
    "regexp"
    "strconv"
    "fmt"
)

func BalanceStatement(lst string) string {
    if len(lst) == 0 {return "Buy: 0 Sell: 0"}
    var badform = []string{}
    prices := map[string]float64{"B": 0.0, "S": 0.0}
    arr := strings.Split(lst, ", ")
    var valid = regexp.MustCompile(`\S+ \d+ \d*\.\d+ (B|S)`)
    for _, v := range arr {
        if !valid.MatchString(v) {
            badform = append(badform, v + " ;")
        } else {
            uu := strings.Split(v, " ")
            if (len(uu) != 4) {
                badform = append(badform, v + " ;")
            } else {
                _, quantity, price, status := uu[0], uu[1], uu[2], uu[3]
                q, _ := strconv.Atoi(quantity)
                p, _ := strconv.ParseFloat(price, 64)
                newprice := prices[status] + float64(q) * p
                prices[status] = newprice
            }
        }
    }
    res :=  fmt.Sprintf("Buy: %.0f Sell: %.0f", prices["B"], prices["S"])
    if len(badform) != 0 {
        res += fmt.Sprintf("; Badly formed %d: %s", len(badform), strings.Join(badform, ""))
    }
    return res
}
```



空白判斷寫得比較精簡`if len(lst) == 0 {return "Buy: 0 Sell: 0"}`，不過我寫的時候是擔心會有輸入空格的情況所以才進行split的

價格宣告成map直接跟買賣綁在一起了 `prices := map[string]float64{"B": 0.0, "S": 0.0}`

另外最大的差別就是他使用了`regexp`套件，直接規範了字串結構，節省掉了一些多餘的處理動作。

關於regular expression我會另外記錄成一篇筆記



### Solution 2

```go
package kata

import (
  "regexp"
  "strconv"
  "fmt"
)
func BalanceStatement(lst string) string {
  re, errStr, errNum := regexp.MustCompile(`, *`), "", 0
  m := map[string]float64{ "B": 0.0, "S": 0.0 }
  for _, v := range re.Split(lst, -1) {
    if v == "" { continue }
    re = regexp.MustCompile(`^[\w\d\.]+ (\d+) (\d+\.\d+) ([B|S])$`)
    match := re.FindStringSubmatch(v)
    if len(match) != 4 {
      errStr, errNum = errStr + v + " ;", errNum + 1
      continue
    }
    num, _ := strconv.ParseFloat(match[1], 64)
    price, _ := strconv.ParseFloat(match[2], 64)
    m[match[3]] += price * num
  }
  ret := fmt.Sprintf("Buy: %.0f Sell: %.0f", m["B"], m["S"])
  if errStr != "" { ret += fmt.Sprintf("; Badly formed %d: %s", errNum, errStr) }
  return ret
}
```



`regexp`的下法又跟上面那位不太一樣
