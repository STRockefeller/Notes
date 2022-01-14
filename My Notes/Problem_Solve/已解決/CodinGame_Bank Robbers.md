

# CodinGame:BANK ROBBERS:20220106:Go

[Reference](https://www.codingame.com/training/easy/bank-robbers)

## Question

### STATEMENT

###  Goal

A gang of R foolish robbers decides to heist a bank. In the bank there are V vaults (indexed from 0 to V - 1). The robbers have managed to extract some information from the bank's director:
\- The combination of a vault is composed of C characters (digits/vowels).
\- The first N characters consist of digits from 0 to 9.
\- The remaining characters consist of vowels (A, E, I, O, U).
\- C and N may be the same or different for different vaults.

All the robbers work at the same time. A robber can work on one vault at a time, and a vault can be worked on by only one robber. Robbers deal with the different vaults in increasing order.

A robber tries the combinations at the speed of 1 combination per second. He tries **all** the possible combinations, i.e. he continues to try the untried combinations even after he has found the correct combination. Once he finishes one vault, he moves on to the next available vault, that is the vault with the smallest index among all the vaults that have not been worked on yet. The heist is finished when the robbers have worked on all the vaults.

Assume it takes no time to move from one vault to another.

You have to output the total time the heist takes.



```go
package main

import "fmt"

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    var R int
    fmt.Scan(&R)
    
    var V int
    fmt.Scan(&V)
    
    for i := 0; i < V; i++ {
        var C, N int
        fmt.Scan(&C, &N)
    }
    
    // fmt.Fprintln(os.Stderr, "Debug messages...")
    fmt.Println("1")// Write answer to stdout
}
```



## My Solution

```go
package main

import (
    "fmt"
    "math"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    var R int
    fmt.Scan(&R)
    
    var V int
    fmt.Scan(&V)

    tasks := make([]task,V)
    robbers := make([]robber,R)
    
    for i := 0; i < V; i++ {
        var C, N int
        fmt.Scan(&C, &N)

        tasks[i] = task(math.Pow(10,float64(N))*math.Pow(5,float64(C-N)))
    }

    for _,task := range tasks {
        task.assign(robbers)
    }

    res := 0
    for _,robber := range robbers{
        if robber.task > res {
            res = robber.task
        }
    }

    
    // fmt.Fprintln(os.Stderr, "Debug messages...")
    fmt.Println(res)// Write answer to stdout
}

type robber struct{
    task int
}

type task float64

func (t task)assign(robbers []robber)[]robber{
    minIndex := 0
    minValue := robbers[0].task

    for i,robber:=range robbers{
        if robber.task == 0{
            robbers[i].task = int(t)
            return robbers
        }

        if robber.task < minValue{
            minIndex = i
            minValue = robber.task
        }
    }

    robbers[minIndex].task = robbers[minIndex].task + int(t)
    return robbers
}
```

題目本身很簡單，但一時想不到合適的寫法，先寫一個比較沒效率的，記錄下來以後看看有沒有更好的解法。

## Better Solutions

