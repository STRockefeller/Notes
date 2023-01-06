# TypeScript String and String Literal



## References



[String Literal Types in TypeScript — Marius Schulz](https://mariusschulz.com/blog/string-literal-types-in-typescript)



## Abstract



這應該算在疑難雜症還是另開新篇讓我猶豫了下，不過感覺算是滿重要的內容所以還是另外記錄下來了。



起因是在開發 Vue 的時候發現的問題，簡單來說我想引用某個ts套件的內容，但是該套件把一些我需要的內容寫在example裡面而非src，所以我沒辦法直接 `import { OOO } from 'packageName'; ``，於是乎，我使用了相對路徑來取得我要參考的目標。但在執行階段會發生can't reslove 的錯誤。



去問了chatGPT拿到一個鬼打牆的回答

![](https://i.imgur.com/Gr8whb5.png)

具體錯誤如下

![](https://i.imgur.com/QqsuF7E.png)



沒辦法，只好花點時間研究何謂 string literal ，他和 string 又有甚麼差別。



## About string literal



> A string literal type is a type whose expected value is a string with textual contents equal to that of the string literal type.



姑且在去問了下GPT大大，得到如下回答。(你這不是很懂嗎?)



In TypeScript, a string literal is a piece of text enclosed in single or double quotes. It can be of any length and can contain Unicode characters. For example, here is a string literal:

```typescript
const greeting: string = "Hello, world!";
```

In TypeScript, string literals can be used to define the type of a variable and can be used to restrict the values that a variable can take. For example, we can define a function that accepts a string literal as an argument and that function can only be called with a specific string literal as an argument. For example:

```typescript
function greet(greeting: "Hello, world!") {
  console.log(greeting);
}

greet("Hello, world!"); // correct
greet("Hi there!"); // error, cannot pass a string other than "Hello, world!"

```

In short, string literals are a useful feature in TypeScript that allows you to specify that a variable can only take specific string values. It can help you catch errors more easily when writing code and can make your code more readable and maintainable.



## Can I use string as string literal?



Yes, you can use a string value as a string literal in TypeScript. For example, let's say you have a string variable called `greeting` and you want to use it as a string literal. You can do this by using the `as` keyword:

```typescript
const greeting: string = "Hello, world!";

function greet(greeting: "Hello, world!") {
  console.log(greeting);
}

greet(greeting as "Hello, world!"); // correct

```

In the code above, we first define a string variable called `greeting`. Then, we define a function called `greet` that takes a string literal as an argument. Finally, we call the `greet` function and pass the `greeting` variable as an argument. By using the `as` keyword, we are telling TypeScript that we want to use the value of the `greeting` variable as a string literal.

Keep in mind that this only works if the value of the `greeting` variable is exactly equal to the string literal that we specified in the `greet` function. If it is not, then you will get a type error at runtime. For example:

```typescript
const greeting: string = "Hi there!";

function greet(greeting: "Hello, world!") {
  console.log(greeting);
}

greet(greeting as "Hello, world!"); // error, cannot pass a string other than "Hello, world!"

```

In the code above, we define the `greeting` variable with a different value than the string literal we specified in the `greet` function. This will result in a type error at runtime, since the `greet` function can only be called with the string literal "Hello, world!" as an argument.
