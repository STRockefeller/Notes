# Decorators

reference: https://www.typescriptlang.org/docs/handbook/decorators.html



## Prerequisite

decorator 目前仍是js的實驗性語法，要在ts中使用必須特別設定

command line

```bash
tsc --target ES5 --experimentalDecorators
```



tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES5",
    "experimentalDecorators": true
  }
}
```





## Decorators

> A *Decorator* is a special kind of declaration that can be attached to a [class declaration](https://www.typescriptlang.org/docs/handbook/decorators.html#class-decorators), [method](https://www.typescriptlang.org/docs/handbook/decorators.html#method-decorators), [accessor](https://www.typescriptlang.org/docs/handbook/decorators.html#accessor-decorators), [property](https://www.typescriptlang.org/docs/handbook/decorators.html#property-decorators), or [parameter](https://www.typescriptlang.org/docs/handbook/decorators.html#parameter-decorators). Decorators use the form `@expression`, where `expression` must evaluate to a function that will be called at runtime with information about the decorated declaration.
>
> For example, given the decorator `@sealed` we might write the `sealed` function as follows:
>
> ```javascript
> function sealed(target) {
>   // do something with 'target' ...
> }
> ```

簡而言之，只要符合特定的格式，就能作為decorator使用。



## Decorator Factories

```typescript
function color(value: string) {
  // this is the decorator factory, it sets up
  // the returned decorator function
  return function (target) {
    // this is the decorator
    // do something with 'target' and 'value'...
  };
}
```



## Decorator Composition

As such, the following steps are performed when evaluating multiple decorators on a single declaration in TypeScript:

1. The expressions for each decorator are evaluated top-to-bottom.
2. The results are then called as functions from bottom-to-top.

```typescript
function first() {
  console.log("first(): factory evaluated");
  return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
    console.log("first(): called");
  };
}
 
function second() {
  console.log("second(): factory evaluated");
  return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
    console.log("second(): called");
  };
}
 
class ExampleClass {
  @first()
  @second()
  method() {}
  // 也可以寫成如下
  // @first()  @second()  method() {}
}
```

輸出如下

```
first(): factory evaluated
second(): factory evaluated
second(): called
first(): called
```



## Decorator Evaluation

There is a well defined order to how decorators applied to various declarations inside of a class are applied:

1. *Parameter Decorators*, followed by *Method*, *Accessor*, or *Property Decorators* are applied for each instance member.
2. *Parameter Decorators*, followed by *Method*, *Accessor*, or *Property Decorators* are applied for each static member.
3. *Parameter Decorators* are applied for the constructor.
4. *Class Decorators* are applied for the class.



## Class Decorators

class decorators 的定義為

```typescript
function classDecorator(target:any):void;
// or
function classDecorator(target:Function):void;
```

其中參數為該class的建構子



example

```typescript
// @experimentalDecorators
function test(constructor: Function) {
  console.log(constructor)
}
// ---cut---
@test
class Class1 {
  title: string;

  constructor(t: string) {
    this.title = t;
  }
}
```

output

```
[LOG]: class Class1 {
    constructor(t) {
        this.title = t;
    }
} 
```



## Method Decorators

```typescript
function methodDecorator(target: any, propertyKey: string, descriptor: PropertyDescriptor):void
```

The expression for the method decorator will be called as a function at runtime, with the following three arguments:

1. Either the constructor function of the class for a static member, or the prototype of the class for an instance member.
2. The name of the member.
3. The *Property Descriptor* for the member.



注意第一個參數對於static member有不一樣的意義

拿上面的範例修改一下繼續測

```typescript
// @experimentalDecorators
function classDecotator(constructor: Function): void {
    console.log("class decorator:");
    console.log(constructor);
}

function methodDecorator(constructor: any, propertyKey: string, descriptor: PropertyDescriptor): void {
    console.log("method decorator:");
    console.log(constructor);
    console.log(propertyKey);
    console.log(descriptor);
}
// ---cut---
@classDecotator
class Class1 {
    title: string;

    constructor(t: string) {
        this.title = t;
    }

    @methodDecorator
    private test() { }
}
```

output

```
[LOG]: "method decorator:" 
[LOG]: class Class1 {
    constructor(t) {
        this.title = t;
    }
    static test() { }
} 
[LOG]: "test" 
[LOG]: {
  "writable": true,
  "enumerable": false,
  "configurable": true
} 
[LOG]: "class decorator:" 
[LOG]: class Class1 {
    constructor(t) {
        this.title = t;
    }
    static test() { }
} 
```



如果把方法改成static

```typescript
// @experimentalDecorators
function classDecotator(constructor: Function): void {
    console.log("class decorator:");
    console.log(constructor);
}

function methodDecorator(constructor: any, propertyKey: string, descriptor: PropertyDescriptor): void {
    console.log("method decorator:");
    console.log(constructor);
    console.log(propertyKey);
    console.log(descriptor);
}
// ---cut---
@classDecotator
class Class1 {
    title: string;

    constructor(t: string) {
        this.title = t;
    }

    @methodDecorator
    private static test() { }
}
```

output

```
[LOG]: "method decorator:" 
[LOG]: class Class1 {
    constructor(t) {
        this.title = t;
    }
    static test() { }
} 
[LOG]: "test" 
[LOG]: {
  "writable": true,
  "enumerable": false,
  "configurable": true
} 
[LOG]: "class decorator:" 
[LOG]: class Class1 {
    constructor(t) {
        this.title = t;
    }
    static test() { }
} 
```



## Accessor Decorators

```typescript
function accessorDecorator(target: any, propertyKey: string, descriptor: PropertyDescriptor):void
```

The expression for the accessor decorator will be called as a function at runtime, with the following three arguments:

1. Either the constructor function of the class for a static member, or the prototype of the class for an instance member.
2. The name of the member.
3. The *Property Descriptor* for the member.



## Property Decorators

```typescript
function propertyDecorator(target:any,propertyKey:string):void;
```

The expression for the property decorator will be called as a function at runtime, with the following two arguments:

1. Either the constructor function of the class for a static member, or the prototype of the class for an instance member.
2. The name of the member.