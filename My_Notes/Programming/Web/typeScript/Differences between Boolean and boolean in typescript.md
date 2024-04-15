# Differences between Boolean and boolean in typescript

tags: #typescript #boolean #comparison

## Introduction

TypeScript is a typed superset of JavaScript. This means that it supports all of the same features as JavaScript, but it also adds type safety. One of the types that TypeScript supports is the boolean type.

The boolean type can represent two values: true and false. In JavaScript, there is also a Boolean object. The Boolean object is a wrapper around the primitive boolean value. This means that it is an object that has the property `value`, which is a primitive boolean value.

## Differences between Boolean and boolean

The main difference between Boolean and boolean is that Boolean is an object type, while boolean is a primitive type. This means that there are some subtle differences in how they are used.

For example, the typeof operator will return `object` for a Boolean object, but it will return `boolean` for a primitive boolean value.

Another difference is that the instanceof operator will return true if you apply it to a Boolean object, but it will return false if you apply it to a primitive boolean value.

## Recommendations

It is recommended to use the primitive type boolean in your TypeScript code. This is because the TypeScript type system does not force an object to its primitive type, while JavaScript does. This means that if you use a Boolean object in TypeScript, it will be treated as an object, even if it is assigned to a variable with the type boolean.

## Conclusion

In this document, we have explained the differences between Boolean and boolean in TypeScript. We have seen that Boolean is an object type, while boolean is a primitive type. We have also seen that it is recommended to use the primitive type boolean in your TypeScript code.

| Feature             | Boolean                                     | boolean                                               |
| ------------------- | ------------------------------------------- | ----------------------------------------------------- |
| Type                | Object type                                 | Primitive type                                        |
| Value               | true or false                               | true or false                                         |
| typeof operator     | Returns `object`                            | Returns `boolean`                                     |
| instanceof operator | Returns true if applied to a Boolean object | Returns false if applied to a primitive boolean value |
| Recommended usage   | Not recommended                             | Recommended                                           |

## References

* [TypeScript Boolean](https://www.tutorialsteacher.com/typescript/typescript-boolean)
* [JavaScript Boolean vs. boolean: Explained By Examples](https://www.javascripttutorial.net/javascript-boolean/)
* [What is the difference between Boolean and boolean in Typescript?](https://stackoverflow.com/questions/64443288/what-is-the-difference-between-boolean-and-boolean-in-typescript)
