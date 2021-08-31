# CodeWars:IP Validation:20210831:Go

[Reference](https://www.codewars.com/kata/515decfd9dcfc23bb6000006)



## Question

Write an algorithm that will identify valid IPv4 addresses in dot-decimal format. IPs should be considered valid if they consist of four octets, with values between `0` and `255`, inclusive.

#### Valid inputs examples:

```
Examples of valid inputs:
1.2.3.4
123.45.67.89
```

#### Invalid input examples:

```
1.2.3
1.2.3.4.5
123.456.78.90
123.045.067.089
```

#### Notes:

- Leading zeros (e.g. `01.02.03.04`) are considered invalid
- Inputs are guaranteed to be a single string

## My Solution

滿簡單的題目，不過這次給自己一點挑戰，**使用剛學的regexp套件**完成這題



首先要先想出一個規則，符合這個規則就算合格的IP格式

(n個數字，不能leading 0，範圍是0~255).(n個數字，同左).(n個數字，同左).(n個數字，同左)

先把大致上的格式寫出來

```
 \d+\.\d+\.\d+\.\d+
```

加入起始和結束的判斷，避免過多的IP通關(如1.2.3.4.5)

```
\A\d+\.\d+\.\d+\.\d+$
```

限定數字的數量1~3個

```
\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$
```

再來判斷leading 0 和是否在0~255之間就不知道怎麼寫了，不過符合這個條件的就不會有負數值，轉整數也不會有err，後面可以少判斷一些條件了



答案

```go
func Is_valid_ip(ip string) bool {
	if !regexp.MustCompile(`\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$`).MatchString(ip) {
		return false
	}
	for _, element := range regexp.MustCompile(`\.`).Split(ip, 4) {
		number, _ := strconv.Atoi(element)
		switch {
		case element[0] == []byte("0")[0] && len(element) > 1:
			return false
		case number > 255:
			return false
		}
	}
	return true
}
```

中間比對leading 0 的寫法有點多此一舉的感覺，但是一時間又沒想到其他寫法...

## Better Solutions



## Solution 1

```go
package kata

import "net"
func Is_valid_ip(ip string) bool {
  res := net.ParseIP(ip)
  if res == nil {
    return false
  }
  return true
}
```

wow...



### Solution 2

```go
package kata

import (
  "strings"
  "strconv"
)

func Is_valid_ip(ip string) bool {

  parts := strings.Split(ip, ".")
  
  if (len(parts) != 4) {
    return false;
  }
  
  for _, part := range parts {
    if (len(part) > 1 && string(part[0]) == "0") {
        return false
    }
    
    val, err := strconv.Atoi(part)
    
    if err != nil {
      return false
    }

    if val < 0 || val > 255 {
     return false 
    }
  }

  return true
}
```



`string(part[0]) == "0"`對吼，我還可以把前面的byte轉成string...



### Solution 3

```go
package kata

import (
  "regexp"
)

func Is_valid_ip(ip string) bool {
  match, _ := regexp.Compile("^([0-1]?[0-9]?[0-9]?|2[0-4][0-9]|25[0-5])([.])([0-1]?[0-9]?[0-9]?|2[0-4][0-9]|25[0-5])([.])([0-1]?[0-9]?[0-9]?|2[0-4][0-9]|25[0-5])([.])([0-1]?[0-9]?[0-9]?|2[0-4][0-9]|25[0-5])$")
  return len(match.FindStringSubmatch(ip)) == 8
}
```

找到一個同樣是使用`regexp`套件的解答了

