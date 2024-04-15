# Using Matrix Exponentiation to Solve Fibonacci Numbers

tags: #Fibonacci_sequence #golang #algorithms #exponential

In this document, we will explore a technique called matrix exponentiation to efficiently calculate Fibonacci numbers. Fibonacci numbers are a sequence of numbers in which each number is the sum of the two preceding ones, usually starting with 0 and 1.

## References

[medium-find-nth-fibonacci-number-by-fast-doubling](https://medium.com/starbugs/find-nth-fibonacci-number-by-fast-doubling-6ac2857a7834)

## Introduction

The Fibonacci sequence is defined as follows:

$$
F_0 = 0, \quad F_1 = 1 \\
F_n = F_{n-1} + F_{n-2} \quad \text{for } n > 1
$$

Calculating Fibonacci numbers using the recursive definition can be computationally expensive as it involves redundant calculations. Matrix exponentiation provides a more efficient approach.

## Matrix Representation

To use matrix exponentiation, we represent the Fibonacci sequence using a matrix. Let's define the matrix as follows:

$$
A = \begin{bmatrix} 1 & 1 \\ 1 & 0 \end{bmatrix}
$$

This matrix helps us compute the next Fibonacci number based on the previous two numbers.

## Matrix Exponentiation Algorithm

To calculate the nth Fibonacci number efficiently, we can use the following steps:

1. Define the base case matrix:

$$
B = \begin{bmatrix} 1 & 0 \end{bmatrix}
$$

2. Raise the matrix A to the power of n-1:

$$
M = A^{(n-1)}
$$

3. Multiply the matrix M with the base case matrix B:

$$
C = B \times M
$$

4. The result C will contain the (n+1)th Fibonacci number:

$$
F_n = C[0][0]
$$

the [proof](https://math.stackexchange.com/questions/784710/how-to-prove-fibonacci-sequence-with-matrices/784723#784723) of the formula

$$
A^{n+1}=A\,A^n=\begin{bmatrix}
1 & 1 \\ 1 & 0
\end{bmatrix}\begin{bmatrix}
F_{n+1} & F_{n} \\ F_{n} & F_{n-1}
\end{bmatrix}=\begin{bmatrix}
F_{n+1}+F_n & F_{n}+F_{n-1} \\  F_{n+1} & F_{n}
\end{bmatrix}=\begin{bmatrix}
F_{n+2} & F_{n+1} \\ F_{n+1} & F_{n}
\end{bmatrix}
$$

## Implementation in Golang

Let's now implement the above algorithm in Golang (with [[Exponentiation by squaring]]):

```go
package main

import "fmt"

// Function to calculate Fibonacci number using matrix exponentiation
func fibonacci(n int) int {
    A := [2][2]int{{1, 1}, {1, 0}}
    B := [2]int{1, 0}

    // Perform matrix exponentiation
    M := matrixExponentiation(A, n-1)

    // Multiply matrix M with base case matrix B
    C := multiplyMatrices(B, M)

    // Result is the first element of C
    return C[0]
}

// Function to raise a matrix to the power of n
func matrixExponentiation(A [2][2]int, n int) [2][2]int {
    if n == 0 {
        return [2][2]int{{1, 0}, {0, 1}}
    }

    if n%2 == 1 {
        M := matrixExponentiation(A, (n-1)/2)
        return multiplyMatrices2(multiplyMatrices2(M, M), A)
    } else {
        M := matrixExponentiation(A, n/2)
        return multiplyMatrices2(M, M)
    }
}

// Function to multiply two matrices
func multiplyMatrices(A [2]int, B [2][2]int) [2]int {
    C := [2]int{0, 0}

    C[0] = A[0]*B[0][0] + A[1]*B[1][0]
    C[1] = A[0]*B[0][1] + A[1]*B[1][1]

    return C
}

func multiplyMatrices2(A [2][2]int, B [2][2]int) [2][2]int {
	C := [2][2]int{}

	C[0][0] = A[0][0]*B[0][0] + A[0][1]*B[1][0]
	C[0][1] = A[0][0]*B[0][1] + A[0][1]*B[1][1]
	C[1][0] = A[1][0]*B[0][0] + A[1][1]*B[1][0]
	C[1][1] = A[1][0]*B[0][1] + A[1][1]*B[1][1]

	return C
}

func main() {
    n := 10
    fmt.Printf("Fibonacci number at position %d: %d\n", n, fibonacci(n))
}
```

In the above code, the `fibonacci` function calculates the nth Fibonacci number using matrix exponentiation. The `matrixExponentiation` function raises the matrix A to the power of n, and the `multiplyMatrices` function multiplies two matrices.

## Conclusion

By using matrix exponentiation, we can efficiently calculate Fibonacci numbers without the need for recursive calculations. This approach significantly reduces the time complexity and provides a faster solution.

### Complexity

| Algorithm             | Time Complexity    | Space Complexity   |
|-----------------------|--------------------|--------------------|
| Matrix Exponentiation | O(log n)           | O(1)               |
| Dynamic Programming   | O(n)               | O(n)               |

In the table above, we compare the time and space complexity of the **Matrix Exponentiation** algorithm with the **Dynamic Programming** solution for calculating Fibonacci numbers.

For the Matrix Exponentiation algorithm, the time complexity is `O(log n)` because the exponentiation process reduces the number of iterations required to calculate the nth Fibonacci number. The space complexity is `O(1)` because we only need a fixed number of variables to store intermediate results.

On the other hand, the Dynamic Programming solution has a time complexity of `O(n)` because it iteratively computes each Fibonacci number up to the nth Fibonacci number. The space complexity is `O(n)` because we need an array or table to store previously calculated Fibonacci numbers.

Comparing the two algorithms, Matrix Exponentiation offers a significant improvement in terms of time complexity, especially for large values of n. It achieves this by leveraging the properties of matrix multiplication and exponentiation. However, it requires a deeper understanding of linear algebra concepts. Dynamic Programming, on the other hand, is more straightforward to implement but may become inefficient for very large values of n due to its linear time complexity.
