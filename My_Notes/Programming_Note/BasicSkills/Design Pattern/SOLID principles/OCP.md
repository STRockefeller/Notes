# Open Close Principle

#solid_principles #programming_principles

The Open-Closed Principle is a software design principle that states that software entities (such as classes, modules, functions, etc.) should **be open for extension, but closed for modification.**

In other words, this principle suggests that you should design your code in a way that allows you to add new functionality without changing existing code. This can help to reduce the risk of introducing bugs and other issues when making changes to your codebase.

## Note of Design patterns in Go

[design patterns in go](https://www.udemy.com/course/design-patterns-go/learn/lecture/16912634#questions)

If I have a struct like this

```go
// Color and Size are enums
type Product struct{
    name string
    color Color
    size Size
}

type Filter struct{}

func(f *Filter) FilterByColor(products []Product, color Color)[]*Product{
    // ...
}

```

OK,so it might look like everything is OK.

However, imagine that you implement this filtering by color and it goes into production and then your manager comes back and they say something like, well, you know, we also need filtering by size.

You have to basically change the type, adding another method to it.

```go
func(f *Filter) FilterBySize(products []Product, size Size)[]*Product{
    // ...
}
```

Every time there is a new requirement, you must add a new method to the Filter struct, which does not adhere to the open/closed principle.

And we can use the specification pattern to solve this problem.

```go
type Specification interface{
    IsSatisfied(p *Product) bool
}


type ColorSpecification struct{
    color Color
}

func(c ColorSpecification) IsSatisfied(p *Product)bool{
    return p.color == c.color
}

type SizeSpecification struct{
    size Size
}

func(s SizeSpecification) IsSatisfied(p *Product)bool{
    return p.size == s.size
}
```
