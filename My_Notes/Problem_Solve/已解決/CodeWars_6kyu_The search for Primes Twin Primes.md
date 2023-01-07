# CodeWars: The search for Primes! Twin Primes!:20220901:TS

#typescript #problem_solve 

[The search for Primes! Twin Primes! | Codewars](https://www.codewars.com/kata/596549c7743cf369b900021b/typescript)

## Question

A twin prime is a prime number that is either 2 less or 2 more than another prime number—for example, either member of the twin prime pair (41, 43). In other words, a twin prime is a prime that has a prime gap of two. Sometimes the term twin prime is used for a pair of twin primes; an alternative name for this is prime twin or prime pair. (from wiki [Twin prime - Wikipedia](https://en.wikipedia.org/wiki/Twin_prime))

Your mission, should you choose to accept it, is to write a function that counts the number of sets of twin primes from 1 to n.

If n is wrapped by twin primes (n-1 == prime && n+1 == prime) then that should also count even though n+1 is outside the range.

Ex n = 10

Twin Primes are (3,5) (5,7) so your function should return 2!

### Sample Test

```typescript
import {twinPrime} from "./solution";
import {assert} from "chai";

describe("twinPrime", function() {
  it("Sample tests", function() {
    assert.equal(twinPrime(-25), 0);
    assert.equal(twinPrime(0), 0);
    assert.equal(twinPrime(1), 0);
    assert.equal(twinPrime(2), 0);
    assert.equal(twinPrime(10), 2);
    assert.equal(twinPrime(11), 2);
    assert.equal(twinPrime(12), 3);
    assert.equal(twinPrime(15), 3);
    assert.equal(twinPrime(25), 4);
  });
});
```

## My Solution

題目中都有給wiki連結了，偷看一下wiki不過分吧。

整篇看下來似懂非懂，感覺用得上的大概只有下面這段吧。

> For a twin prime pair of the form (6*n* − 1, 6*n* + 1) for some natural number *n* > 1, *n* must have units digit 0, 2, 3, 5, 7, or 8

做法就決定是先找符合上述條件的數值，再確認它們是不是質數了。

大概像是這樣

```typescript
export const twinPrime = (n: number): number => {
    let res = 0;
    if (n >= 4) {
        res++; // add (3, 5)
    }
    for (let i = 0; i <= n / 6; i++) {
        if (isPrime(6 * i)) {
            res++;
        }
    }
    return res;
}

// check if n-1 and n+1 are prime numbers
function isPrime(n: number): boolean { }
```

完成後如下

```typescript
export const twinPrime = (n: number): number => {
    let res = 1;// add (3, 5)
    if (n < 4) {
        return 0;
    }
    for (let i = 1; i <= n / 6; i++) {
        if (arePrimeNums(6 * i)) {
            res++;
        }
    }
    return res;
}

// check if n-1 and n+1 are prime numbers
function arePrimeNums(n: number): boolean {
    return isPrime(n - 1) && isPrime(n + 1);
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

## Better Solutions

### Solution 1

```typescript
function isprime(n: number): boolean{
  for(let i: number = 2; i <= Math.sqrt(n); i++){
    if(n % i === 0) return false
  }
  return n > 1
}

export const twinPrime = (n: number): number => {
  return Array.from({length: n / 2}, (_, i) => i * 2 + 1).filter(x => isprime(x) && isprime(x + 2)).length
}
```

### Solution 2

```typescript
export const twinPrime = (n: number): number => {

  if(n < 4) {
    return 0
  }

  const primes:number[] = [] 

  for(let i = 3; i <= n+1; i+=2) {
    if(primes.every(prime => i % prime !== 0 )){
      primes.push(i)
    }
  }

  return primes.reduce((acc, prime, id) => {
    if(prime + 2 === primes[id+1]) {
     acc+=1
    }
    return acc
  },0 )

}
```

---

一路看下來發現好像只有我用6n的解法，慚愧。
