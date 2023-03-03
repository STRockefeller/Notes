# CodeWars:Greedy thief:20230222:js

#problem_solve #codewars/4kyu #javascript #knapsack_problem

[Reference](https://www.codewars.com/kata/58296c407da141e2c7000271)

## Question

> When no more interesting kata can be resolved, I just choose to create the new kata, to solve their own, to enjoy the process --myjinxin2015 said

### Description

In a dark, deserted night, a thief entered a shop. There are some items in the room, and the items have different weight(Kg) and price($):

```js
items=[
{weight:2,price:6},
{weight:2,price:3},
{weight:6,price:5},
{weight:5,price:4},
{weight:4,price:6}
]
```

The thief is greedy, his desire is to take away all the goods. But unfortunately, his bag can only hold `n` Kg items. So he has to make a choice, try to take away more valuable items.

Please complete the function `greedyThief`, to help the thief to make the best choice. Two arguments will be given: `items`(an array that contains all items) and `n`(the maximum weight of the package can be accommodated).

The result should be a list of items that the thief can take away and has the maximum total price.

Notes: If more than one valid solutions exist, you should return one of them; If no valid solution should return `[]`; You should not modify argument `items`; In the end, you need a good algorithm ;-)

### Some examples

```
items=[
 {weight:2,price:6},
 {weight:2,price:3},
 {weight:6,price:5},
 {weight:5,price:4},
 {weight:4,price:6}
 ]
n=10

greedyThief(items, n) can be:
[
 {weight:2,price:6},
 {weight:2,price:3},
 {weight:4,price:6}
]

More examples please see the example tests ;-)
```

## My Solution

It seems to be a variation of the knapsack problem, but I am not familiar with it. Since I am not proficient in JavaScript, I wrote TypeScript instead.
I attempted to print a log and find the maximum value using a classical solution.

```typescript
class item {
    weight: number = 0;
    price: number = 0;
}

function greedyThief(items: item[], weightLimitation: number): number[][] {
    let itemsCount = items.length;
    // Create a matrix of itemsCount+1 rows and weightLimitation+1 columns with all elements initialized as 0
    let knapsackMatrix: number[][] = Array.from(Array(itemsCount + 1), () => (new Array(weightLimitation + 1) as number[]).fill(0));
    // Declare result array to store the chosen items
    let result: item[] = [];

    // Recursively solve for the maximum possible value given the remaining total weight
    function knapsack(itemCount: number, remainWeight: number): number {
        // unable to take this one
        if (remainWeight < 0) return -1e9;

        // no item
        if (itemCount === -1) return 0;

        if (knapsackMatrix[itemCount][weightLimitation]) return knapsackMatrix[itemCount][weightLimitation];

        console.log("itemCount: ", itemCount, "remainWeight: ", remainWeight)

        knapsackMatrix[itemCount][weightLimitation] = Math.max(
            knapsack(itemCount - 1, remainWeight - items[itemCount].weight) + items[itemCount].price,
            knapsack(itemCount - 1, remainWeight)
        )

        console.log("itemCount: ", itemCount, "remainWeight: ", remainWeight, "knapsackMatrix[itemCount][weightLimitation]: ", knapsackMatrix[itemCount][weightLimitation])

        return knapsackMatrix[itemCount][weightLimitation]
    }

    knapsack(itemsCount-1, weightLimitation);
    return knapsackMatrix;
}
```

test condition

```ts
//example in description
var items: item[] = [
    { weight: 2, price: 6 },
    { weight: 2, price: 3 },
    { weight: 6, price: 5 },
    { weight: 5, price: 4 },
    { weight: 4, price: 6 },
],
    n = 10,
```

log

```console
itemCount:  4 remainWeight:  10
itemCount:  3 remainWeight:  6
itemCount:  2 remainWeight:  1
itemCount:  1 remainWeight:  1
itemCount:  0 remainWeight:  1
itemCount:  0 remainWeight:  1 knapsackMatrix[itemCount][weightLimitation]:  0
itemCount:  1 remainWeight:  1 knapsackMatrix[itemCount][weightLimitation]:  0
itemCount:  2 remainWeight:  1 knapsackMatrix[itemCount][weightLimitation]:  0
itemCount:  2 remainWeight:  6
itemCount:  1 remainWeight:  0
itemCount:  0 remainWeight:  0
itemCount:  0 remainWeight:  0 knapsackMatrix[itemCount][weightLimitation]:  0
itemCount:  1 remainWeight:  0 knapsackMatrix[itemCount][weightLimitation]:  0
itemCount:  1 remainWeight:  6
itemCount:  0 remainWeight:  4
itemCount:  0 remainWeight:  4 knapsackMatrix[itemCount][weightLimitation]:  6
itemCount:  1 remainWeight:  6 knapsackMatrix[itemCount][weightLimitation]:  9
itemCount:  2 remainWeight:  6 knapsackMatrix[itemCount][weightLimitation]:  9
itemCount:  3 remainWeight:  6 knapsackMatrix[itemCount][weightLimitation]:  9
itemCount:  4 remainWeight:  10 knapsackMatrix[itemCount][weightLimitation]:  15
[
  [
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    6
  ],
  [
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    9
  ],
  [
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    9
  ],
  [
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    9
  ],
  [
     0, 0, 0, 0, 0,
     0, 0, 0, 0, 0,
    15
  ],
  [
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    0
  ]
]
```

The answer is correct, but the array part is slightly different from what I had imagined.

Modify the solution to get the items put into the bag.

```typescript
class item {
    weight: number = 0;
    price: number = 0;
}

function greedyThief(items: item[], weightLimitation: number): item[] {
    let itemsCount = items.length;
    // Create a matrix of itemsCount+1 rows and weightLimitation+1 columns with all elements initialized as 0
    let knapsackMatrix: number[][] = Array.from(Array(itemsCount + 1), () => (new Array(weightLimitation + 1) as number[]).fill(0));
    // Declare result array to store the chosen items
    let result: item[] = [];

    // Recursively solve for the maximum possible value given the remaining total weight
    function knapsack(itemCount: number, remainWeight: number): number {

        // unable to take this one
        if (remainWeight < 0) return -1e9;

        // no item
        if (itemCount === -1) return 0;

        if (knapsackMatrix[itemCount][weightLimitation]) return knapsackMatrix[itemCount][weightLimitation];

        let putIntoBag = knapsack(itemCount - 1, remainWeight - items[itemCount].weight) + items[itemCount].price
        let notPutIntoBag = knapsack(itemCount - 1, remainWeight)

        if (putIntoBag > notPutIntoBag) {
            result.push(items[itemCount])
            return knapsackMatrix[itemCount][weightLimitation] = putIntoBag
        }
        else return knapsackMatrix[itemCount][weightLimitation] = notPutIntoBag
    }

    knapsack(itemsCount - 1, weightLimitation);
    return result;
}
```

Unfortunately, the code did not pass this test case.

```js
//should get the max total price
var items=[
 {weight:9,price:1},
 {weight:9,price:2},
 {weight:9,price:3},
 {weight:9,price:4},
 {weight:9,price:5}
 ],
n=10,referenceResult=[{weight:9,price:5}]
Test.assertEquals(check(greedyThief(items, n) ,items,referenceResult),"Passed!")
```

I found that I did count the duplicated results in the code.

Fix the problem...

```ts
class item {
    weight: number = 0;
    price: number = 0;
}

function greedyThief(items: item[], weightLimitation: number): item[] {
    let itemsCount = items.length;
    // Declare result array to store the chosen items
    let result: item[] = [];

    class knapsackReply {
        value: number = 0;
        history: number[] = [];
    }

    // Create a matrix of itemsCount+1 rows and weightLimitation+1 columns with all elements initialized as 0
    let knapsackMatrix: knapsackReply[][] = Array.from(Array(itemsCount + 1), () => (new Array(weightLimitation + 1) as knapsackReply[]));

    // Recursively solve for the maximum possible value given the remaining total weight
    function knapsack(itemCount: number, remainWeight: number, history: number[]): knapsackReply {
        // unable to take this one
        if (remainWeight < 0) return { value: -Infinity, history: history };

        // no item
        if (itemCount === -1) return { value: 0, history: history };

        if (knapsackMatrix[itemCount][remainWeight]) return knapsackMatrix[itemCount][remainWeight];

        let p = knapsack(itemCount - 1, remainWeight - items[itemCount].weight, [...history, itemCount])
        let putIntoBagValue = p.value + items[itemCount].price
        let np = knapsack(itemCount - 1, remainWeight, history)
        let notPutIntoBagValue = np.value;

        if (putIntoBagValue > notPutIntoBagValue) {
            return knapsackMatrix[itemCount][remainWeight] = { value: putIntoBagValue, history: p.history }
        }
        else return knapsackMatrix[itemCount][remainWeight] = { value: notPutIntoBagValue, history: np.history }
    }

    let history = knapsack(itemsCount - 1, weightLimitation, []).history;

    // iterate history
    for (let i = 0; i < history.length; i++) {
        result.push(items[history[i]]);
    }

    return result;
}
```

This time, it failed on this case.

```js
items = [{"weight":17,"price":23},{"weight":11,"price":59},{"weight":19,"price":70},{"weight":17,"price":2},{"weight":17,"price":24},{"weight":7,"price":96},{"weight":11,"price":91},{"weight":16,"price":56},{"weight":0,"price":15},{"weight":4,"price":75},{"weight":12,"price":22},{"weight":8,"price":28},{"weight":20,"price":34},{"weight":10,"price":5},{"weight":17,"price":98},{"weight":16,"price":43},{"weight":8,"price":15},{"weight":9,"price":64},{"weight":19,"price":29},{"weight":20,"price":0},{"weight":15,"price":93},{"weight":11,"price":25},{"weight":13,"price":18},{"weight":8,"price":26},{"weight":18,"price":10},{"weight":17,"price":25},{"weight":18,"price":83},{"weight":8,"price":55},{"weight":11,"price":22},{"weight":18,"price":84},{"weight":12,"price":64},{"weight":11,"price":49},{"weight":19,"price":84},{"weight":1,"price":40},{"weight":0,"price":3},{"weight":19,"price":49},{"weight":11,"price":21},{"weight":8,"price":5},{"weight":13,"price":20},{"weight":2,"price":65},{"weight":20,"price":58},{"weight":19,"price":13},{"weight":3,"price":38},{"weight":1,"price":79},{"weight":8,"price":5},{"weight":8,"price":8},{"weight":12,"price":39}]
n = 281 


The max total price is 1586
But your result's total price is 1060 
A reference result:
[{"weight":11,"price":59},{"weight":19,"price":70},{"weight":7,"price":96},{"weight":11,"price":91},{"weight":16,"price":56},{"weight":0,"price":15},{"weight":4,"price":75},{"weight":8,"price":28},{"weight":17,"price":98},{"weight":9,"price":64},{"weight":15,"price":93},{"weight":11,"price":25},{"weight":8,"price":26},{"weight":18,"price":83},{"weight":8,"price":55},{"weight":18,"price":84},{"weight":12,"price":64},{"weight":11,"price":49},{"weight":19,"price":84},{"weight":1,"price":40},{"weight":0,"price":3},{"weight":19,"price":49},{"weight":2,"price":65},{"weight":20,"price":58},{"weight":3,"price":38},{"weight":1,"price":79},{"weight":12,"price":39}] 
```

Add some logs and test this case

```ts
class item {
    weight: number = 0;
    price: number = 0;
}

function greedyThief(items: item[], weightLimitation: number): item[] {
    let itemsCount = items.length;
    // Declare result array to store the chosen items
    let result: item[] = [];

    class knapsackReply {
        value: number = 0;
        history: number[] = [];
    }

    // Create a matrix of itemsCount+1 rows and weightLimitation+1 columns with all elements initialized as 0
    let knapsackMatrix: knapsackReply[][] = Array.from(Array(itemsCount + 1), () => (new Array(weightLimitation + 1) as knapsackReply[]));

    // Recursively solve for the maximum possible value given the remaining total weight
    function knapsack(itemCount: number, remainWeight: number, history: number[]): knapsackReply {
        // unable to take this one
        if (remainWeight < 0) return { value: -Infinity, history: history };

        // no item
        if (itemCount === -1) return { value: 0, history: history };

        if (knapsackMatrix[itemCount][remainWeight]) return knapsackMatrix[itemCount][remainWeight];

        let p = knapsack(itemCount - 1, remainWeight - items[itemCount].weight, [...history, itemCount])
        let putIntoBagValue = p.value + items[itemCount].price
        let np = knapsack(itemCount - 1, remainWeight, history)
        let notPutIntoBagValue = np.value;

        if (putIntoBagValue > notPutIntoBagValue) {
            return knapsackMatrix[itemCount][remainWeight] = { value: putIntoBagValue, history: p.history }
        }
        else return knapsackMatrix[itemCount][remainWeight] = { value: notPutIntoBagValue, history: np.history }
    }

    let ans = knapsack(itemsCount - 1, weightLimitation, [])
    let history = ans.history;
    console.log("ans value", ans.value)

    // iterate history
    for (let i = 0; i < history.length; i++) {
        result.push(items[history[i]]);
    }

    let recountAns = 0;
    for (let i = 0; i < result.length; i++) {
        recountAns += result[i].price;
    }
    console.log("recountAns", recountAns)

    return result;
}

var items = [{ "weight": 17, "price": 23 }, { "weight": 11, "price": 59 }, { "weight": 19, "price": 70 }, { "weight": 17, "price": 2 }, { "weight": 17, "price": 24 }, { "weight": 7, "price": 96 }, { "weight": 11, "price": 91 }, { "weight": 16, "price": 56 }, { "weight": 0, "price": 15 }, { "weight": 4, "price": 75 }, { "weight": 12, "price": 22 }, { "weight": 8, "price": 28 }, { "weight": 20, "price": 34 }, { "weight": 10, "price": 5 }, { "weight": 17, "price": 98 }, { "weight": 16, "price": 43 }, { "weight": 8, "price": 15 }, { "weight": 9, "price": 64 }, { "weight": 19, "price": 29 }, { "weight": 20, "price": 0 }, { "weight": 15, "price": 93 }, { "weight": 11, "price": 25 }, { "weight": 13, "price": 18 }, { "weight": 8, "price": 26 }, { "weight": 18, "price": 10 }, { "weight": 17, "price": 25 }, { "weight": 18, "price": 83 }, { "weight": 8, "price": 55 }, { "weight": 11, "price": 22 }, { "weight": 18, "price": 84 }, { "weight": 12, "price": 64 }, { "weight": 11, "price": 49 }, { "weight": 19, "price": 84 }, { "weight": 1, "price": 40 }, { "weight": 0, "price": 3 }, { "weight": 19, "price": 49 }, { "weight": 11, "price": 21 }, { "weight": 8, "price": 5 }, { "weight": 13, "price": 20 }, { "weight": 2, "price": 65 }, { "weight": 20, "price": 58 }, { "weight": 19, "price": 13 }, { "weight": 3, "price": 38 }, { "weight": 1, "price": 79 }, { "weight": 8, "price": 5 }, { "weight": 8, "price": 8 }, { "weight": 12, "price": 39 }]
var n = 281

console.log("third test:", greedyThief(items, n));
```

results

```js
ans value 1586
recountAns 1060
third test: [
  { weight: 12, price: 39 },
  { weight: 8, price: 8 },
  { weight: 8, price: 5 },
  { weight: 1, price: 79 },
  { weight: 3, price: 38 },
  { weight: 19, price: 13 },
  { weight: 20, price: 58 },
  { weight: 2, price: 65 },
  { weight: 13, price: 20 },
  { weight: 8, price: 5 },
  { weight: 11, price: 21 },
  { weight: 19, price: 49 },
  { weight: 0, price: 3 },
  { weight: 1, price: 40 },
  { weight: 19, price: 84 },
  { weight: 11, price: 49 },
  { weight: 12, price: 64 },
  { weight: 18, price: 84 },
  { weight: 11, price: 22 },
  { weight: 8, price: 55 },
  { weight: 18, price: 83 },
  { weight: 17, price: 25 },
  { weight: 18, price: 10 },
  { weight: 8, price: 26 },
  { weight: 11, price: 25 },
  { weight: 4, price: 75 },
  { weight: 0, price: 15 }
]
```

## Better Solutions
