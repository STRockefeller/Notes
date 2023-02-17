# Type Alias

#golang #type_alias

## References

[go dev talks](https://go.dev/talks/2016/refactor.article#TOC_5.3.)
[linuxhint](https://linuxhint.com/golang-type-alias/)

## Syntax

```go
type alias = existingType
```

If you find the structure familiar, that's normal, as it is similar to a type definition but with an added equal sign.

## Type Definition and Type Alias

Examples are likely to be more easily understood than text-based explanations here.

If we have the following type declarations.

```go
type A string
type B = string
type C = string
```

And following `func` declarations.

```go
func inputA(A) {}
func inputB(B) {}
```

Based on the above clues, which part of the following code is correct and which part is incorrect?

```go
func test(){
	var a A
	var b B
	var c C

	inputA(a)
	inputA(b)
	inputA(c)
	inputB(a)
	inputB(b)
	inputB(c)
}
```

---

answer

```go
func test(){
	var a A
	var b B
	var c C

	inputA(a)
	inputA(b) // cannot use b (variable of type string) as A value in argument to inputA
	inputA(c) // cannot use c (variable of type string) as A value in argument to inputA
	inputB(a) // cannot use a (variable of type A) as string value in argument to inputB
	inputB(b)
	inputB(c)
}
```

In short, a type alias is not a new type, it is simply an alternate name for an existing type.

Notice that you CANNOT declare methods to a type alias.

```go
func (A) Hello() {}
func (B) Hello() {} // invalid receiver type string (basic or unnamed type)
```

## Conclusion

If you need to define methods for a type, use type definition; otherwise, use type alias.