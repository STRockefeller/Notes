# Single Responsibility Principle

#solid_principles #programming_principles

The Single Responsibility Principle is a software design principle that states that a software module or class should **have only one reason to change**.

[design patterns in go](https://www.udemy.com/course/design-patterns-go/learn/lecture/16912628#overview)

## Note of Design Patterns in Go

If I have a `Journal` struct like this.

```go
package main

var entryCount = 0
type Journal struct{
    entries []string
}

func (j *Journal)AddEntry(text string)int{
    entryCount++
    entry := fmt.Sprintf("%d: %s", entryCount, text)
    j.entries = append(j.entries, entry)
    return entryCount
}


func (j *Journal)RemoveEntry(index int){
    // ...
}
```

Journal struct have a primary responsibility of managing entries.

In this case, if I were to add more responsibilities to this structure, such as storing its own state.

```go
func (j *Journal) Save(filename string){
    // ...
}


func (j *Journal) Load(filePath string){
    // ...
}
```

then the single responsibility was broken because the responsibility of the `Journal` is to do with the management of the entries not persistence.

To follow the SRP, declaring a new struct to handle persistence is a good idea.

```go
type Persistence struct{}

func (p *Persistence) Save(journal Journal,fileName string){
    // ...
}

func (p *Persistence) Load(journal Journal,filePath string){
    // ...
}
```
