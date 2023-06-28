# Differences between ?? and || in Typescript

tags: #typescript #operators #comparison

The `??` and `||` operators are both used in Typescript to provide a default value if the first operand is null or undefined. However, there are some key differences between the two operators.

| Operator | Description |
|---|---|
| `??` | The nullish coalescing operator. Returns the right operand if the left operand is null or undefined, otherwise returns the left operand. |
| `||` | The logical OR operator. Returns the right operand if the left operand is falsy, otherwise returns the left operand. |

## Table of Differences

| Feature | `??` | `||` |
|---|---|---|
| Returns the right operand if | The left operand is null or undefined. | The left operand is falsy. |
| Returns the left operand if | The left operand is not null or undefined. | The left operand is truthy. |
| Can be used with | Any type. | Any type that can be coerced to a boolean. |

## Example

```typescript
const value = null;

// `??` will return the string "default" because the left operand (value) is null.
const result = value ?? "default";
console.log(result); // "default"

// `||` will return the string "default" because the left operand (value) is falsy.
const result2 = value || "default";
console.log(result2); // "default"
```

## When to use which operator?

The `??` operator should be used when you want to provide a default value for a variable that could be null or undefined. The `||` operator should be used when you want to evaluate a logical expression and return the right operand if the left operand is falsy.

For example, you might use the `??` operator to set the default value of a `string` variable to "default" if the variable is not initialized. You might use the `||` operator to evaluate an expression and return the value of the right operand if the left operand is false.

## Conclusion

The `??` and `||` operators are both useful in Typescript, but they have different purposes. The `??` operator should be used to provide a default value for a variable that could be null or undefined, while the `||` operator should be used to evaluate a logical expression and return the right operand if the left operand is falsy.
