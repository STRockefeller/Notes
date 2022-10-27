# Destructuring assignment

references:

[解構賦值 - JavaScript | MDN](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)

[Day10【ES6 小筆記】物件的解構賦值-以一間好吃的餐廳為例（Object Destructuring） - iT 邦幫忙::一起幫忙解決難題，拯救 IT 人的一天](https://ithelp.ithome.com.tw/articles/10214721)

[Day11【ES6 小筆記】陣列的解構賦值-以哥哥的前女友為例（Array Destructuring） - iT 邦幫忙::一起幫忙解決難題，拯救 IT 人的一天](https://ithelp.ithome.com.tw/articles/10214766)



## Abstract

ES6 開始適用的新語法，其實就只是個語法糖罷了，個人沒有特別喜歡這種寫法，不過別人的程式還是必須看得懂，所以還是紀錄一下。



這邊就簡單紀錄一下，看得懂就好，詳細就看上面的參考連結吧。

## Arrays

```javascript
const foo = ['one', 'two', 'three'];

const [red, yellow, green] = foo;
console.log(red); // "one"
console.log(yellow); // "two"
console.log(green); // "three"

```

```javascript
let a, b;

[a, b] = [1, 2];
console.log(a); // 1
console.log(b); // 2
```

```javascript
let a = 1;
let b = 3;

[a, b] = [b, a];
console.log(a); // 3
console.log(b); // 1

const arr = [1,2,3];
[arr[2], arr[1]] = [arr[1], arr[2]];
console.log(arr); // [1,3,2]
```

## Object

```javascript
const o = {p: 42, q: true};
const {p, q} = o;

console.log(p); // 42
console.log(q); // true
```

```javascript
const o = {p: 42, q: true};
const {p: foo, q: bar} = o;

console.log(foo); // 42
console.log(bar); // true
```
