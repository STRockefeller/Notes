# Exponentiation by Squaring

tags: #exponential #algorithms #golang

Exponentiation by squaring is an efficient algorithm used to compute the power of a number. It reduces the number of multiplications required, especially for large exponents.
This technique is widely used in various applications, such as cryptography and algorithmic computations.

## References

[wiki](https://simple.wikipedia.org/wiki/Exponentiation_by_squaring)

## Algorithm Overview

Exponentiation by squaring relies on the principle that any exponentiation operation can be expressed as a combination of multiplications and squarings.
The key idea behind the algorithm is to divide the exponent in half and recursively compute the result.

Let's say we want to compute the value of `base` raised to the power `exponent`. The steps of the exponentiation by squaring algorithm are as follows:

1. If the exponent is 0, return 1 as the result.
2. If the exponent is 1, return the value of the base as the result.
3. If the exponent is even, recursively compute `base` raised to the power of half the exponent, square the result, and return it.
4. If the exponent is odd, recursively compute `base` raised to the power of half the exponent, square the result, and multiply it by the base.

This algorithm significantly reduces the number of multiplications required by exploiting the properties of exponents and squaring.

## Mathematical Representation

Let's represent the exponentiation by squaring algorithm mathematically. We denote the base as $b$ and the exponent as $e$. The result of the exponentiation is denoted as $r$. The algorithm can be defined as follows:

1. If $e = 0$, $r = 1$.
2. If $e = 1$, $r = b$.
3. If $e$ is even, $r = \left(b^{\frac{e}{2}}\right)^2$.
4. If $e$ is odd, $r = \left(b^{\frac{e}{2}}\right)^2 \cdot b$.

## Code Examples in Go

Let's now explore code examples in Go to implement the exponentiation by squaring algorithm:

```go
func power(base, exponent int) int {
    if exponent == 0 {
        return 1
    }
    if exponent == 1 {
        return base
    }
    if exponent%2 == 0 {
        result := power(base, exponent/2)
        return result * result
    }
    result := power(base, exponent/2)
    return result * result * base
}
```

The `power` function takes the `base` and `exponent` as input and returns the result of the exponentiation. It follows the algorithm steps described earlier. The function uses recursive calls to compute the result efficiently.

You can use this function to calculate the power of a number efficiently using exponentiation by squaring.

## Conclusion

Exponentiation by squaring is a powerful algorithm that allows us to efficiently compute the power of a number. By reducing the number of multiplications required, it offers a significant improvement in computational efficiency, especially for large exponents. The algorithm is widely used in various fields, and understanding its principles can be beneficial for optimizing computations in practice.
