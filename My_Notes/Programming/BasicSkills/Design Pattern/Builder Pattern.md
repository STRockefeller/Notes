# Builder Pattern

tags: #design_pattern #builder_pattern #refactor

## References

- [corrupt003](http://corrupt003-design-pattern.blogspot.com/2017/01/builder-pattern.html)
- [medium](https://medium.com/wenchin-rolls-around/%E8%A8%AD%E8%A8%88%E6%A8%A1%E5%BC%8F-%E5%BB%BA%E9%80%A0%E8%80%85%E6%A8%A1%E5%BC%8F-builder-design-pattern-7c8eac7c9a7)
- [refactoring.guru](https://refactoring.guru/design-patterns/builder)
- [design patterns in go](https://www.udemy.com/course/design-patterns-go/)

## Purpose

> **Builder** is a creational design pattern that lets you construct complex objects step by step. The pattern allows you to produce different types and representations of an object using the same construction code.

(from refactoring.guru)

Problems solved by builder pattern.

1. telescoping constructor
2. nullable parameters in constructor

---

> The Builder pattern suggests that you extract the object construction code out of its own class and move it to separate objects called _builders_.

(from refactoring.guru)

## Structure

![structure](https://refactoring.guru/images/patterns/diagrams/builder/structure.png)
(from refactoring.guru)

> 1. The **Builder** interface declares product construction steps that are common to all types of builders.
> 2. **Concrete Builders** provide different implementations of the construction steps. Concrete builders may produce products that don’t follow the common interface.
> 3. **Products** are resulting objects. Products constructed by different builders don’t have to belong to the same class hierarchy or interface.
> 4. The **Director** class defines the order in which to call construction steps, so you can create and reuse specific configurations of products.
> 5. The **Client** must associate one of the builder objects with the director. Usually, it’s done just once, via parameters of the director’s constructor. Then the director uses that builder object for all further construction. However, there’s an alternative approach for when the client passes the builder object to the production method of the director. In this case, you can use a different builder each time you produce something with the director.

## Examples

### Html builder

(according to design patterns in go)

Let's imagine the situation where let's say you're writing a Web service.

So a Web server is supposed to serve HTML.

For example, you have a piece of text and you want to turn that text into a paragraph.

```go
const indentSize = 2

type HtmlElement struct {
	name, text string
	elements   []HtmlElement
}

func (e *HtmlElement) String() string {
	return e.string(0)
}

func (e *HtmlElement) string(indent int) string {
	sb := strings.Builder{}
	i := strings.Repeat(" ", indentSize*indent)
	sb.WriteString(fmt.Sprintf("%s< %s>\n", i, e.name))
	if len(e.text) > 0 {
		sb.WriteString(strings.Repeat(" ",
			indentSize*(indent+1)))
		sb.WriteString(e.text)
		sb.WriteString("\n")
	}

	for _, el := range e.elements {
		sb.WriteString(el.string(indent + 1))
	}
	sb.WriteString(fmt.Sprintf("%s</%s>\n",
		i, e.name))
	return sb.String()
}

type HtmlBuilder struct {
	rootName string
	root     HtmlElement
}

func NewHtmlBuilder(rootName string) *HtmlBuilder {
	b := HtmlBuilder{rootName,
		HtmlElement{rootName, "", []HtmlElement{}}}
	return &b
}

func (b *HtmlBuilder) String() string {
	return b.root.String()
}

func (b *HtmlBuilder) AddChild(
	childName, childText string) {
	e := HtmlElement{childName, childText, []HtmlElement{}}
	b.root.elements = append(b.root.elements, e)
}

func (b *HtmlBuilder) AddChildFluent(
	childName, childText string) *HtmlBuilder {
	e := HtmlElement{childName, childText, []HtmlElement{}}
	b.root.elements = append(b.root.elements, e)
	return b
}

```

### Person Builder

(according to design patterns in go)

In most situations that you encounter in daily programming, a single builder is sufficient for building up a particular object.

But there are situations where you need more than one builder, where you need to somehow separate the process of building up the different aspects of a particular type.

```go
package main

import "fmt"

type Person struct {
	StreetAddress, Postcode, City string
	CompanyName, Position         string
	AnnualIncome                  int
}

type PersonBuilder struct {
	person *Person // needs to be inited
}

func NewPersonBuilder() *PersonBuilder {
	return &PersonBuilder{&Person{}}
}

func (it *PersonBuilder) Build() *Person {
	return it.person
}

func (it *PersonBuilder) Works() *PersonJobBuilder {
	return &PersonJobBuilder{*it}
}

func (it *PersonBuilder) Lives() *PersonAddressBuilder {
	return &PersonAddressBuilder{*it}
}

type PersonJobBuilder struct {
	PersonBuilder
}

func (pjb *PersonJobBuilder) At(
	companyName string) *PersonJobBuilder {
	pjb.person.CompanyName = companyName
	return pjb
}

func (pjb *PersonJobBuilder) AsA(
	position string) *PersonJobBuilder {
	pjb.person.Position = position
	return pjb
}

func (pjb *PersonJobBuilder) Earning(
	annualIncome int) *PersonJobBuilder {
	pjb.person.AnnualIncome = annualIncome
	return pjb
}

type PersonAddressBuilder struct {
	PersonBuilder
}

func (it *PersonAddressBuilder) At(
	streetAddress string) *PersonAddressBuilder {
	it.person.StreetAddress = streetAddress
	return it
}

func (it *PersonAddressBuilder) In(
	city string) *PersonAddressBuilder {
	it.person.City = city
	return it
}

func (it *PersonAddressBuilder) WithPostcode(
	postcode string) *PersonAddressBuilder {
	it.person.Postcode = postcode
	return it
}

func main() {
	pb := NewPersonBuilder()
	pb.
		Lives().
		At("123 London Road").
		In("London").
		WithPostcode("SW12BC").
		Works().
		At("Fabrikam").
		AsA("Programmer").
		Earning(123000)
	person := pb.Build()
	fmt.Println(*person)
}
```

### Email Builder

(according to design patterns in go)

So one question you might be asking is, how do I get the uses of my API to actually use my builders as opposed to stop messing with the objects directly?

And one approach to this is you simply hide the objects that you want your users not to touch.

Let's suppose that you have a an API of some kind for sending emails.

```go
package main

import "strings"

type email struct {
	from, to, subject, body string
}

type EmailBuilder struct {
	email email
}

func (b *EmailBuilder) From(from string) *EmailBuilder {
	if !strings.Contains(from, "@") {
		panic("email should contain @")
	}
	b.email.from = from
	return b
}

func (b *EmailBuilder) To(to string) *EmailBuilder {
	b.email.to = to
	return b
}

func (b *EmailBuilder) Subject(subject string) *EmailBuilder {
	b.email.subject = subject
	return b
}

func (b *EmailBuilder) Body(body string) *EmailBuilder {
	b.email.body = body
	return b
}

func sendMailImpl(email *email) {
	// actually ends the email
}

type build func(*EmailBuilder)

func SendEmail(action build) {
	builder := EmailBuilder{}
	action(&builder)
	sendMailImpl(&builder.email)
}

func main() {
	SendEmail(func(b *EmailBuilder) {
		b.From("foo@bar.com").
			To("bar@baz.com").
			Subject("Meeting").
			Body("Hello, do you want to meet?")
	})
}
```

### Functional Person Builder

(according to design patterns in go)

```go
package main

import "fmt"

type Person struct {
	name, position string
}

type personMod func(*Person)
type PersonBuilder struct {
	actions []personMod
}

func (b *PersonBuilder) Called(name string) *PersonBuilder {
	b.actions = append(b.actions, func(p *Person) {
		p.name = name
	})
	return b
}

func (b *PersonBuilder) Build() *Person {
	p := Person{}
	for _, a := range b.actions {
		a(&p)
	}
	return &p
}

// extend PersonBuilder
func (b *PersonBuilder) WorksAsA(position string) *PersonBuilder {
	b.actions = append(b.actions, func(p *Person) {
		p.position = position
	})
	return b
}

func main() {
	b := PersonBuilder{}
	p := b.Called("Dmitri").WorksAsA("dev").Build()
	fmt.Println(*p)
}

```

## 實作之前

不知不覺筆記的前兩個部份就變成僅節錄網路或書籍資料的內容，心得部分都移到實作了，這次把這個部分獨立出來試試。

### Builder Pattern 與其他 Design Pattern 的比較

關於這個`Builder Pattern`，第一眼得到的印象是**似曾相識**，目的是生成物件這點讓我聯想到`Factory Pattern`，將整體拆成細部再一一組起的概念類似於`Decorator Pattern`，把這些設計模式弄混顯然有礙於我學習並理解這次的主角`Builder Pattern`。

所以第一要務就是比較並釐清這些設計模式的差別所在

#### VS Factory Pattern

`Factory Pattern` 著重於"在執行階段生成物件"，生成的物件根據傳入的參數來自相應的類別(但會繼承自相同的父類別或介面)

`Builder Pattern` 則是在**同一個類別**中減少建構式多載的情形

#### VS Decorator Pattern

同樣將物件拆分，`Decorator Pattern`使用多個Decorator類別去影響目標的屬性。在`Builder Pattern`中，我們則是透過Builder class 去一步步完善Product物件。

## 實作

既然是Builder Pattern那就以蓋房子為例吧，簡單的選項如幾扇門、幾扇窗、幾層樓、有沒有後院等等。

### 實作一

先用標準結構實作一次

Class Diagram

![](https://i.imgur.com/EwiBd9K.png)

Building (就是Product)

```C#
    public class Building
    {
        private List<string> describes = new List<string>();
        public Building() => addDescribe("房子的詳細規格:");
        public void addDescribe(string describe) => describes.Add(describe);
        public IEnumerable<string> GetDetail()
        {
            foreach (string des in describes)
                yield return des;
        }
    }
```

IBuilder

```C#
    public interface IBuilder
    {
        void reset();
        void setWindowNum(int num);
        void setDoorNum(int num);
        void setFloorNum(int num);
        void setBackYard();
        Building GetBuilding();
    }
```

Builder

```C#
    public class Builder : IBuilder
    {
        private Building building;
        public Builder() => reset();

        public Building GetBuilding() => building;

        public void reset() => building = new Building();

        public void setBackYard() => building.addDescribe("含後院");

        public void setDoorNum(int num) => building.addDescribe(num.ToString()+"扇門");
        public void setFloorNum(int num) => building.addDescribe(num.ToString() + "層樓");

        public void setWindowNum(int num) => building.addDescribe(num.ToString() + "扇窗");
    }
```

Director

```C#
    public class Director
    {
        public Building GetOrdinaryBuilding()
        {
            Builder builder = new Builder();
            builder.setFloorNum(3);
            builder.setWindowNum(8);
            builder.setDoorNum(3);
            builder.setBackYard();
            return builder.GetBuilding();
        }
    }
```

測試程式

```C#
        private void builderTest()
        {
            Director director = new Director();
            Building building = director.GetOrdinaryBuilding();
            IEnumerable<string> buildingDetail = building.GetDetail();
            foreach (string detail in buildingDetail)
                Console.WriteLine(detail);
        }
```

結果

> 房子的詳細規格:
> 3層樓
> 8扇窗
> 3扇門
> 含後院

### 實作二

用另一種架構實作看看

Class Diagram

![](https://i.imgur.com/tIeTDdR.png)

Building

```C#
    public class Building
    {
        public int? DoorNum { get; set; }
        public int? WindowNum { get; set; }
        public int? FloorNum { get; set; }
        public bool HasBackYard { get; set; }
        public Building() => HasBackYard = false;
        public List<string> Describe()
        {
            List<string> res = new List<string>();
            res.Add("房子的詳細規格:");
            if (DoorNum != null) { res.Add(DoorNum.ToString() + "扇門"); }
            if (WindowNum != null) { res.Add(WindowNum.ToString() + "扇窗"); }
            if (FloorNum != null) { res.Add(FloorNum.ToString() + "層樓"); }
            if (HasBackYard) { res.Add("含後院"); }
            return res;
        }
    }
```

`?`是為了做null判斷 [Reference](https://medium.com/@mybaseball52/handling-null-in-csharp-60eabafe8e22)

IBuilder

```C#
    public interface IBuilder
    {
        IBuilder reset();
        IBuilder setWindowNum(int num);
        IBuilder setDoorNum(int num);
        IBuilder setFloorNum(int num);
        IBuilder setBackYard();
        Building GetBuilding();
    }
```

Builder

```C#
    public class Builder : IBuilder
    {
        private Building building;
        public Builder() => building = new Building();
        public Building GetBuilding() => building;

        public IBuilder reset()
        {
            building = new Building();
            return this;
        }

        public IBuilder setBackYard()
        {
            building.HasBackYard = true;
            return this;
        }

        public IBuilder setDoorNum(int num)
        {
            building.DoorNum = num;
            return this;
        }

        public IBuilder setFloorNum(int num)
        {
            building.FloorNum = num;
            return this;
        }

        public IBuilder setWindowNum(int num)
        {
            building.WindowNum = num;
            return this;
        }
    }
```

測試程式

```C#
        private void builderTest2()
        {
            Builder2.Building building = new Builder2.Builder()
                .setDoorNum(3)
                .setFloorNum(3)
                .setWindowNum(8)
                .setBackYard()
                .GetBuilding();
            foreach (string s in building.Describe())
                Console.WriteLine(s);
        }
```

結果

> 房子的詳細規格:
> 3扇門
> 8扇窗
> 3層樓
> 含後院
