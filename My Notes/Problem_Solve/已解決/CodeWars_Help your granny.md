# CodeWars:Help your granny:20211116:Go

[Reference](https://www.codewars.com/kata/5536a85b6ed4ee5a78000035/go)

### Question

Your granny, who lives in town X0, has friends. These friends are given in an array, for example: array of friends is `["A1", "A2", "A3", "A4", "A5"]`.

**The order of friends in this array must \*not be changed\* since this order gives the order in which they will be visited.**

Friends inhabit towns and you get an array with friends and their towns (or an associative array), for example: `[["A1", "X1"], ["A2", "X2"], ["A3", "X3"], ["A4", "X4"]]` which means A1 is in town X1, A2 in town X2... It can happen that we do not know the town of one of the friends hence it will not be visited.

Your granny wants to visit her friends and to know approximately how many miles she will have to travel. You will make the circuit that permits her to visit her friends. For example here the circuit will be:`X0, X1, X2, X3, X4, X0` and you will compute approximately the total distance `X0X1 + X1X2 + .. + X4X0`.

For the distances you are given an array or a dictionary that gives each distance X0X1, X0X2 and so on. For example (it depends on the language):

```
[ ["X1", 100.0], ["X2", 200.0], ["X3", 250.0], ["X4", 300.0] ]
or
("X1" -> 100.0, "X2" -> 200.0, "X3" -> 250.0, "X4" -> 300.0)
```

which means that X1 is at 100.0 miles from X0, X2 at 200.0 miles from X0, etc... It's not real life, it's a story... : the towns X0, X1, .., X0 are placed in the following manner (see drawing below):

X0X1X2 is a right triangle with the right angle in X1, X0X2X3 is a right triangle with the right angle in X2, ... In a travel X0, X1, .., Xi-1, Xi, Xi+1.., X0 you will suppose - to make it easier - that there is a right angle in Xi (i > 0).

So if a town Xi is not visited you will consider that the triangle `X0Xi-1Xi+1` is still a right triangle in `Xi-1` and you can use the "Pythagorean_theorem".

#### Task

Can you help your granny and give her approximately the distance to travel?

#### Notes

If you have some difficulty to see the tour I made a maybe useful drawing:

![alternative text](http://i.imgur.com/dG7iWXhm.jpg)

#### All languages:

- See the type of data in the sample tests.
- Friends and towns can have other names than in the examples.
- Function "tour" returns an int which is the floor of the total distance.





### Unit Test

```go
package kata_test
import (
  . "github.com/onsi/ginkgo"
  . "github.com/onsi/gomega"
  . "codewarrior/kata"

)

func dotest(arrFriends []string, ftwns map[string]string, h map[string]float64, exp int) {
    var ans = Tour(arrFriends, ftwns, h)
    Expect(ans).To(Equal(exp))
}

var _ = Describe("Tests Tour", func() {

    It("should handle basic cases", func() {

        var friends1 = []string{ "A1", "A2", "A3", "A4", "A5" }
        var fTowns1 = map[string]string{"A1": "X1", "A2": "X2", "A3": "X3", "A4": "X4"}
        var dist1 = map[string]float64{"X1": 100.0, "X2": 200.0, "X3": 250.0, "X4": 300.0}
        dotest(friends1, fTowns1, dist1, 889)

        friends1 = []string{ "B1", "B2" }
        fTowns1 =  map[string]string{"B1": "Y1", "B2": "Y2", "B3": "Y3", "B4": "Y4", "B5": "Y5"}
        dist1 = map[string]float64{"Y1": 50.0, "Y2": 70.0, "Y3": 90.0, "Y4": 110.0, "Y5": 150.0}
        dotest(friends1, fTowns1, dist1, 168)
        
    })
})

```



## My Solution

看了單元測試才比較明白題目的要求

先重點整理一下:

1. 輸入按順序分別代表:
   1. 朋友名單
   2. 朋友住哪個城鎮
   3. 阿嬤家到各城鎮的直線距離
2. 不一定每個朋友都有對應的居住地(無家可歸?)
3. 不一定每個城鎮都有住朋友
4. 相鄰兩個城鎮和阿嬤家可以組成right triangle
5. 最後結果要估算成整數，至於怎麼概算還不曉得



解答

```go
package kata

import (
	"math"
	"sort"
)

func Tour(arrFriends []string, ftwns map[string]string, h map[string]float64) int {
	usefulFriendTownMap := make(map[string]string)
	for _, friend := range arrFriends {
		if val, hasKey := ftwns[friend]; hasKey {
			usefulFriendTownMap[friend] = val
		}
	}
	usefulTownDistanceMap := make(map[string]float64)
	for _, town := range usefulFriendTownMap {
		if val, hasKey := h[town]; hasKey {
			usefulTownDistanceMap[town] = val
		}
	}
	var values []float64
	for _, val := range usefulTownDistanceMap {
		values = append(values, val)
	}
	sort.Slice(values, func(i, j int) bool {
		return int(values[i]) < int(values[j])
	})

	res := values[0] + values[len(values)-1]
	for i := 1; i < len(values); i++ {
		res += calDistance(values[i-1], values[i])
	}
	return int(math.Floor(res))
}

func calDistance(d1, d2 float64) float64 {
	return math.Sqrt(math.Pow(d2, 2) - math.Pow(d1, 2))
}

```

基本上算是一次過，概算的部分一開始用四捨五入，但是結果比正確答案多一，改成無條件捨去就通關了



## Better Solutions

### Solution 1

```go
package kata
import (
. "fmt"
. "math"
)

func Tour(f []string, ftwns map[string]string, h map[string]float64) int {
    result := 0.0
    toFrom := h[ftwns[f[0]]]
    prev := 0.0
    
    for i := 1; i < len(f); i++ {
        if v, ok := h[ftwns[f[i]]]; ok {
            
            prev = h[ftwns[f[i - 1]]]
            
            result += Sqrt((Pow(v, 2)) - (Pow(prev, 2)))
            Println(result)
        } else {
            break
        }
        
        prev = h[ftwns[f[i]]]
    }
    result += prev
    
    return int(Floor(result)) + int(Floor(toFrom))
}
```



### Solution 2

```go
package kata

import (
  "math"
)

func Tour(arrFriends []string, ftwns map[string]string, h map[string]float64) int {
    var c float64
    b := h[ftwns[arrFriends[0]]]
    dist := b
    for ind, _ := range arrFriends[:len(arrFriends)-1] {
      if h[ftwns[arrFriends[ind+1]]] != 0 {
        c = h[ftwns[arrFriends[ind+1]]]
        a := math.Sqrt(math.Pow(c, 2) - math.Pow(b, 2))
        b = c
        dist += a
      }
    }
    dist += c
    return int(dist)
}
```

