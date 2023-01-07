# CodeWars:Gap in Primes:20220901:TS

#typescript #problem_solve 

[Gap in Primes | Codewars](https://www.codewars.com/kata/561e9c843a2ef5a40c0000a4)

## Question

The prime numbers are not regularly spaced. For example from `2` to `3` the gap is `1`. From `3` to `5` the gap is `2`. From `7` to `11` it is `4`. Between 2 and 50 we have the following pairs of 2-gaps primes: `3-5, 5-7, 11-13, 17-19, 29-31, 41-43`

A prime gap of length n is a run of n-1 consecutive composite numbers between two **successive** primes (see: http://mathworld.wolfram.com/PrimeGaps.html).

We will write a function gap with parameters:

- `g` (integer >= 2) which indicates the gap we are looking for

- `m` (integer > 2) which gives the start of the search (m inclusive)

- `n` (integer >= m) which gives the end of the search (n inclusive)

In the example above `gap(2, 3, 50)` will return `[3, 5] or (3, 5) or {3, 5}` which is the first pair between 3 and 50 with a 2-gap.

So this function should return the **first** pair of two prime numbers spaced with a gap of `g` between the limits `m`, `n` if these numbers exist otherwise `nil or null or None or Nothing (or ... depending on the language).

```
In such a case (no pair of prime numbers with a gap of `g`)
In C: return [0, 0]
In C++, Lua, COBOL: return `{0, 0}`. 
In F#: return `[||]`. 
In Kotlin, Dart and Prolog: return `[]`.
In Pascal: return Type TGap (0, 0).
```

#### Examples:

- `gap(2, 5, 7) --> [5, 7] or (5, 7) or {5, 7}`

- `gap(2, 5, 5) --> nil. In C++ {0, 0}. In F# [||]. In Kotlin, Dart and Prolog return` []`

- `gap(4, 130, 200) --> [163, 167] or (163, 167) or {163, 167}`

([193, 197] is also such a 4-gap primes between 130 and 200 but it's not the first pair)

- `gap(6,100,110) --> nil or {0, 0} or ...` : between 100 and 110 we have `101, 103, 107, 109` but `101-107`is not a 6-gap because there is `103`in between and `103-109`is not a 6-gap because there is `107`in between.

- You can see more examples of return in Sample Tests.

#### Note for Go

For Go: nil slice is expected when there are no gap between m and n. Example: gap(11,30000,100000) --> nil

#### Ref

[Prime gap - Wikipedia](https://en.wikipedia.org/wiki/Prime_gap)

## My Solution

沒什麼頭緒，先想個最笨的解法好了，把範圍內的所有質數都找出來，再兩兩找gap是否符合條件。

或者是一樣從頭找質數，找到一個後把它加上 gap 之後如果沒超出範圍，就再判斷是否為質數。雖然感覺還是挺笨的，但似乎比上面那個好那麼一點點。



```typescript
export const gap = (g: number, m: number, n: number): number[] | null => {
    for (let i = m; i <= n - g; i++) {
        if (isPrime(i) && isPrime(i + g))
            return [i, i + g]
    }
    return null
}

function isPrime(num: number): boolean {
    let i = 2;
    while (i * i <= num) {
        if (num % i === 0) {
            return false;
        }
        i++;
    }
    return true;
}
```

寫完之後才發現他是錯的

>  `101-107`is not a 6-gap because there is `103`in between and `103-109`is not a 6-gap because there is `107`in between.

還必須判斷是不是gap才行。時間複雜度激增

```typescript
export const gap = (g: number, m: number, n: number): number[] | null => {
    for (let i = m; i <= n - g; i++) {
        if (isPrime(i) && isPrime(i + g)) {
            let hasPrime = false;
            for (let j = i + 1; j < i + g; j++) {
                if (isPrime(j)) {
                    hasPrime = true;
                    break;
                }
            }
            if (!hasPrime)
                return [i, i + g]
        }
    }
    return null
}

function isPrime(num: number): boolean {
    let i = 2;
    while (i * i <= num) {
        if (num % i === 0) {
            return false;
        }
        i++;
    }
    return true;
}
```

雖然寫的世界爛，但還是過了。

## Better Solutions





### Solution 1



```typescript
function isPrime(n: number): boolean {
  for (let i = 2; i < n; i++) {
    if (n % i === 0) return false;
  }
  return true;
}

export class G964 {
  public static gap = (g: number, m: number, n: number): number[] | null => {
    let prev = 0;
    for (let p = m; p <= n; p++) {
      if (!isPrime(p)) continue;
      if (prev > 0 && p - prev === g) return [prev, p];
      prev = p;
    }
    return null;
  }
}
```

好像沒有看到什麼特別好的寫法，不過這個人寫的應該比我有效率一些，先找到質數再回頭看前一個質數的差是不是gap，這才發現我的程式碼中有重複計算的部分，當然可以避免，不過還是得額外花費空間去紀錄已經算過的資料，相比之下還是這個做法好點。
