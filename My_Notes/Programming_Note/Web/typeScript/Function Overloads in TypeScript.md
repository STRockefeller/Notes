# Function Overloads in TypeScript

tags: #typescript #function_overloads

## References

- [official docs](https://www.typescriptlang.org/docs/handbook/2/functions.html#function-overloads)
- [aaronbos](https://aaronbos.dev/posts/function-overload-typescript)

## Syntax

The syntax for declaring function overloads in TypeScript is as follows:

```typescript
function functionName(parameter1: type1): returnType1;
function functionName(parameter1: type1, parameter2: type2): returnType2;
// additional overload declarations...
function functionName(parameter1: type1, parameter2: type2, parameter3: type3): returnType3;
```

In this syntax, each line represents a different function signature for the `functionName`. The number and types of parameters, as well as the return type, can vary for each overload.

## Example

Let's say we wanna make a function called `calculateArea` that can figure out the area of different shapes. We can create different signatures to deal with different types of shapes like the following example code.

```typescript
function calculateArea(shape: 'circle', radius: number): number;
function calculateArea(shape: 'rectangle', width: number, height: number): number;
function calculateArea(shape: 'triangle', base: number, height: number): number;

function calculateArea(shape: string, ...args: number[]): number {
  if (shape === 'circle') {
    const [radius] = args;
    return Math.PI * radius * radius;
  } else if (shape === 'rectangle') {
    const [width, height] = args;
    return width * height;
  } else if (shape === 'triangle') {
    const [base, height] = args;
    return (base * height) / 2;
  } else {
    throw new Error('Unsupported shape');
  }
}
```

In this example, we have three function signatures that represent calculating the area of a circle, rectangle, and triangle. The last function implementation handles the actual calculation based on the provided shape and arguments.

## signatures

In TypeScript, when we talk about "overload signatures" and "implementation signatures," we are referring to two different parts of function overloads.

**Overload Signatures**:

- Overload signatures are the function signatures that define the different ways the function can be called. They specify the types and number of arguments the function expects and the return type it produces.
- Overload signatures are declared before the actual function implementation and are used to provide clear documentation of the function's expected input and output types.
- Overload signatures are separated by semicolons (`;`) and use the `:` syntax to specify the parameter types and return type.
- Overload signatures are not directly accessible to the callers of the function. Instead, they serve as a way for the compiler to determine which implementation signature to use based on the provided arguments.

**Implementation Signatures**:

- Implementation signatures, on the other hand, are the actual function implementations that follow the overload signatures.
- Implementation signatures provide the logic for each specific overload of the function. They define how the function behaves when called with specific argument types.
- Implementation signatures are declared after the overload signatures and follow the same syntax as a regular function.
- Unlike overload signatures, implementation signatures are visible and callable by the users of the function.

| Aspect               | Overload Signatures                                              | Implementation Signatures                                       |
|-----------------------|-----------------------------------------------------------------|-----------------------------------------------------------------|
| Purpose               | Provide different function signatures based on argument types    | Define the actual logic for each specific overload               |
| Placement             | Declared before the implementation                               | Declared after the overload signatures                          |
| Visibility            | Not directly accessible to callers                               | Visible and callable by callers                                 |
| Syntax                | Use `:` to specify parameter types and return type               | Follow the regular function syntax                               |
| Documentation         | Clear documentation of expected input/output types               | Logic-specific details for each specific overload               |
| Compiler Resolution   | Used by the compiler for overload resolution                      | Used by the compiler to execute the appropriate function logic  |
| Callability            | Not directly callable by callers                                  | Callable by callers, executes the corresponding function logic |

## Compare with C\#

| Aspect                | TypeScript Function Overloads                                                                   | C# Function Overloads                                                                           |
| --------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Syntax                | Uses `function` keyword                                                                         | Uses `public` or `private` access modifiers                                                     |
|                       | followed by function name                                                                       | followed by return type and function name                                                       |
| Overloaded Signatures | Defined using `:` syntax                                                                        | Defined using `()` syntax                                                                       |
|                       | Each signature includes parameter types and return type                                         | Each signature includes parameter types separated by commas                                     |
| Implementation        | Implementation signature                                                                        | Implementation follows the overloaded signatures                                                |
| Signatures Visibility | Implementation signature is not visible to callers                                              | Implementations are visible to callers                                                          |
| Overload Resolution   | Compiler selects the most specific overload based on provided arguments                         | Compiler selects the most specific overload based on provided arguments                         |
| Error Handling        | Compilation error if no matching overload found or if multiple equally specific overloads exist | Compilation error if no matching overload found or if multiple equally specific overloads exist |
