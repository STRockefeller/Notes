# Regular Expression

tags: #golang #regexp

[Reference:pkg.go.dev](https://pkg.go.dev/regexp)

[Reference:yourbasic](https://yourbasic.org/golang/regexp-cheat-sheet/)

[[Regular Expression Cheat Sheet 詳細版]]

## Abstract

用來定義字串規則的套件，目前找到的參考資料都較為零散，所以筆記可能也會有點亂，之後再來整理

以下內容待補充

* [func CompilePOSIX](#func CompilePOSIX)
* [func (*Regexp) Expand](#func (*Regexp) Expand)

## Cheat Sheets

### Choice and grouping

| Regexp | Meaning                |
| :----- | :--------------------- |
| `xy`   | `x` followed by `y`    |
| `x|y`  | `x` or `y`, prefer `x` |
| `xy|z` | same as `(xy)|z`       |
| `xy*`  | same as `x(y*)`        |

### Repetition (greedy and non-greedy)

| Regexp | Meaning                     |
| :----- | :-------------------------- |
| `x*`   | zero or more x, prefer more |
| `x*?`  | prefer fewer (non-greedy)   |
| `x+`   | one or more x, prefer more  |
| `x+?`  | prefer fewer (non-greedy)   |
| `x?`   | zero or one x, prefer one   |
| `x??`  | prefer zero                 |
| `x{n}` | exactly n x                 |

### Character classes

| Expression  | Meaning                                    |
| :---------- | :----------------------------------------- |
| `.`         | any character                              |
| `[ab]`      | the character a or b                       |
| `[^ab]`     | any character except a or b                |
| `[a-z]`     | any character from a to z                  |
| `[a-z0-9]`  | any character from a to z or 0 to 9        |
| `\d`        | a digit: `[0-9]`                           |
| `\D`        | a non-digit: `[^0-9]`                      |
| `\s`        | a whitespace character: `[\t\n\f\r ]`      |
| `\S`        | a non-whitespace character: `[^\t\n\f\r ]` |
| `\w`        | a word character: `[0-9A-Za-z_]`           |
| `\W`        | a non-word character: `[^0-9A-Za-z_]`      |
| `\p{Greek}` | Unicode character class*                   |
| `\pN`       | one-letter name                            |
| `\P{Greek}` | negated Unicode character class*           |
| `\PN`       | one-letter name                            |

\* [RE2: Unicode character class names](https://github.com/google/re2/wiki/Syntax)

### Special characters

To match a **special character** `\^$.|?*+-[]{}()` literally, escape it with a backslash. For example `\{` matches an opening brace symbol.

Other escape sequences are:

| Symbol | Meaning                                   |
| :----- | :---------------------------------------- |
| `\t`   | horizontal tab = `\011`                   |
| `\n`   | newline = `\012`                          |
| `\f`   | form feed = `\014`                        |
| `\r`   | carriage return = `\015`                  |
| `\v`   | vertical tab = `\013`                     |
| `\123` | octal character code (up to three digits) |
| `\x7F` | hex character code (exactly two digits)   |

### Text boundary anchors

| Symbol | Matches                      |
| :----- | :--------------------------- |
| `\A`   | at beginning of text         |
| `^`    | at beginning of text or line |
| `$`    | at end of text               |
| `\z`   |                              |
| `\b`   | at ASCII word boundary       |
| `\B`   | not at ASCII word boundary   |

### Case-insensitive and multi-line matches

To change the default matching behavior, you can add a set of flags to the beginning of a regular expression.

For example, the prefix `"(?is)"` makes the matching case-insensitive and lets `.` match `\n`. (The default matching is case-sensitive and `.` doesn’t match `\n`.)

| Flag | Meaning                                                      |
| :--- | :----------------------------------------------------------- |
| `i`  | case-insensitive                                             |
| `m`  | let `^` and `$` match begin/end line in addition to begin/end text (multi-line mode) |
| `s`  | let `.` match `\n` (single-line mode)                        |

## regexp

一邊對照上面的Cheat Sheet，一邊來看官方文件的範例

### func [Match](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=559)

```go
func Match(pattern string, b []byte) (matched bool, err error)
```

> Match reports whether the byte slice b contains any match of the regular expression pattern. More complicated queries need to use Compile and the full Regexp interface.

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	matched, err := regexp.Match(`foo.*`, []byte(`seafood`)) //'.'代表任意字元，'*'代表0~n個
	fmt.Println(matched, err) // true <nil>
	matched, err = regexp.Match(`bar.*`, []byte(`seafood`)) //同上
	fmt.Println(matched, err) // false <nil>
	matched, err = regexp.Match(`a(b`, []byte(`seafood`)) // 錯誤的表達式
	fmt.Println(matched, err) // false error parsing regexp: missing closing ): `a(b`
}
```

### func [MatchReader](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=537)

```go
func MatchReader(pattern string, r io.RuneReader) (matched bool, err error)
```

基本[同上](#func Match)，只是對象變成`io.RuneReader`而已

### func [MatchString](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=548)

```go
func MatchString(pattern string, s string) (matched bool, err error)
```

基本同[第一項](#func Match)，只是對象變成`string`而已

### func [QuoteMeta](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=720)

```go
func QuoteMeta(s string) string
```

把字串變成Regular Expression

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	fmt.Println(regexp.QuoteMeta(`Escaping symbols like: .+*?()|[]{}^$`)) // Escaping symbols like: \.\+\*\?\(\)\|\[\]\{\}\^\$
}
```

### Regexp struct

> Regexp is the representation of a compiled regular expression. A Regexp is safe for concurrent use by multiple goroutines, except for configuration methods, such as Longest.

這是套件定義的一個表達式的struct，下面提到的函式或方法多少和他都有點關係

#### func [Compile](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=132)

```go
func Compile(expr string) (*Regexp, error)
```

和 [QuoteMeta](#func QuoteMeta) 一樣是把`string`變成Regular Expression，不過回傳的是`*Regexp`而非`string`

官方文件沒有範例所以就自己試了一下

```go
func main() {
	str := "h823h4hf&*^#>"
	quo := regexp.QuoteMeta(str)
	reg, err := regexp.Compile(str)
	fmt.Println(quo, reg, err) // h823h4hf&\*\^#> h823h4hf&*^#> <nil>
}
```

其中`reg`長這樣

![](https://i.imgur.com/mcC7hJt.png)

#### func [CompilePOSIX](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=155)

```go
func CompilePOSIX(expr string) (*Regexp, error)
```

> CompilePOSIX is like Compile but restricts the regular expression to POSIX ERE (egrep) syntax and changes the match semantics to leftmost-longest.
>
> That is, when matching against text, the regexp returns a match that begins as early as possible in the input (leftmost), and among those it chooses a match that is as long as possible. This so-called leftmost-longest matching is the same semantics that early regular expression implementations used and that POSIX specifies.
>
> However, there can be multiple leftmost-longest matches, with different submatch choices, and here this package diverges from POSIX. Among the possible leftmost-longest matches, this package chooses the one that a backtracking search would have found first, while POSIX specifies that the match be chosen to maximize the length of the first subexpression, then the second, and so on from left to right. The POSIX rule is computationally prohibitive and not even well-defined. See <https://swtch.com/~rsc/regexp/regexp2.html#posix> for details.

老實說我看不太懂，所以先略過

#### func [MustCompile](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=308)

```go
func MustCompile(str string) *Regexp
```

> MustCompile is like Compile but panics if the expression cannot be parsed. It simplifies safe initialization of global variables holding compiled regular expressions.

基本同Compile，但是不回傳err，有錯就直接跳panic

也有 [MustCompilePOSIX](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=319) 但是同樣不是很清楚所以以後補充

#### func (*Regexp) [Expand](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=912)

```go
func (re *Regexp) Expand(dst []byte, template []byte, src []byte, match []int) []byte
```

> Expand appends template to dst and returns the result; during the append, Expand replaces variables in the template with corresponding matches drawn from src. The match slice should have been returned by FindSubmatchIndex.
>
> In the template, a variable is denoted by a substring of the form $name or ${name}, where name is a non-empty sequence of letters, digits, and underscores. A purely numeric name like $1 refers to the submatch with the corresponding index; other names refer to capturing parentheses named with the (?P<name>...) syntax. A reference to an out of range or unmatched index or a name that is not present in the regular expression is replaced with an empty slice.
>
> In the $name form, name is taken to be as long as possible: $1x is equivalent to ${1x}, not ${1}x, and, $10 is equivalent to ${10}, not ${1}0.
>
> To insert a literal $ in the output, use $$ in the template.

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	content := []byte(`
	# comment line
	option1: value1
	option2: value2

	# another comment line
	option3: value3
`)

	// Regex pattern captures "key: value" pair from the content.
	pattern := regexp.MustCompile(`(?m)(?P<key>\w+):\s+(?P<value>\w+)$`)

	// Template to convert "key: value" to "key=value" by
	// referencing the values captured by the regex pattern.
	template := []byte("$key=$value\n")

	result := []byte{}

	// For each match of the regex in the content.
	for _, submatches := range pattern.FindAllSubmatchIndex(content, -1) {
		// Apply the captured submatches to the template and append the output
		// to the result.
		result = pattern.Expand(result, template, content, submatches)
	}
	fmt.Println(string(result))
}
```

```
Output:

option1=value1
option2=value2
option3=value3
```

看不太懂，以後補充 ，後面[ExpandString](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=919)也是

#### func (*Regexp) [Find](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=815)

```go
func (re *Regexp) Find(b []byte) []byte
```

> Find returns a slice holding the text of the leftmost match in b of the regular expression. A return value of nil indicates no match.

簡單的說就是找byte slice中第一個符合`*Regexp`的內容並回傳

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
    re := regexp.MustCompile(`foo.?`) // "foo"+'.'(任意字元)'?'(0~1個，1個優先)
	fmt.Printf("%q\n", re.Find([]byte(`seafood fool`))) //"food"
}
```

#### func (*Regexp) [FindAll](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=1076)

```go
func (re *Regexp) FindAll(b []byte, n int) [][]byte
```

同[Find](#func (*Regexp) Find)，但回傳全部符合條件的內容

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	re := regexp.MustCompile(`foo.?`)
	fmt.Printf("%q\n", re.FindAll([]byte(`seafood fool`), -1)) //["food" "fool"]
}
```

#### func (*Regexp) [FindIndex](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=828)

```go
func (re *Regexp) FindIndex(b []byte) (loc []int)
```

> FindIndex returns a two-element slice of integers defining the location of the leftmost match in b of the regular expression. The match itself is at b[loc[0]:loc[1]]. A return value of nil indicates no match.

同[Find](#func (*Regexp) Find) ，但是回傳的是index [起始位置(包含) 結束位置(不包含)]

Example

```go
import (
	"fmt"
	"regexp"
)

func main() {
	content := []byte(`
	# comment line
	option1: value1
	option2: value2
`)
	// Regex pattern captures "key: value" pair from the content.
	pattern := regexp.MustCompile(`(?m)(?P<key>\w+):\s+(?P<value>\w+)$`)

	loc := pattern.FindIndex(content)
	fmt.Println(loc) //[18 33]
	fmt.Println(string(content[loc[0]:loc[1]])) //option1: value1
}
```

#### func (*Regexp) [FindAllIndex](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=1094)

```go
func (re *Regexp) FindAllIndex(b []byte, n int) [][]int
```

> FindAllIndex is the 'All' version of FindIndex; it returns a slice of all successive matches of the expression, as defined by the 'All' description in the package comment. A return value of nil indicates no match.

[FindIndex](#func (*Regexp) FindIndex)的ALL版本，比較特別的就是多了一個參數n

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	content := []byte("London")
	re := regexp.MustCompile(`o.`)
	fmt.Println(re.FindAllIndex(content, 1))
	fmt.Println(re.FindAllIndex(content, -1))
}
```

```
Output:

[[1 3]]
[[1 3] [4 6]]
```

看完範例還是不知道n在幹嘛，只好繼續找下去了

方法內容

```go
func (re *Regexp) FindAllIndex(b []byte, n int) [][]int {
	if n < 0 {
		n = len(b) + 1
	}
	var result [][]int
	re.allMatches("", b, n, func(match []int) {
		if result == nil {
			result = make([][]int, 0, startSize)
		}
		result = append(result, match[0:2])
	})
	return result
}
```

其中找到allMatches的方法內容，並從他的註解中看到n代表他會被呼叫的次數

```go
// allMatches calls deliver at most n times
// with the location of successive matches in the input text.
// The input text is b if non-nil, otherwise s.
func (re *Regexp) allMatches(s string, b []byte, n int, deliver func([]int))
```

#### func (*Regexp) [FindString](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=841)

```go
func (re *Regexp) FindString(s string) string
```

同[Find](#func (*Regexp) Find)，但是目標和回傳都變成`string`，沒找到會回傳空字串`""`

後面還有 FindAllString FindStringIndex FindAllStringIndex等等都大同小異不提了。

#### func (*Regexp) [FindSubmatch](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=880)

```go
func (re *Regexp) FindSubmatch(b []byte) [][]byte
```

> FindSubmatch returns a slice of slices holding the text of the leftmost match of the regular expression in b and the matches, if any, of its subexpressions, as defined by the 'Submatch' descriptions in the package comment. A return value of nil indicates no match.

找submatch(就是放在`()`裡面的內容)，並且會把符合條件的內容分別回傳

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	re := regexp.MustCompile(`foo(.?)`)
	fmt.Printf("%q\n", re.FindSubmatch([]byte(`seafood fool`))) //["food" "d"]

}
```

同樣有String Index All 等等版本，這邊略過不提

#### func (*Regexp) [Match](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=530)

```go
func (re *Regexp) Match(b []byte) bool
```

有任意內容符合`*Regexp`則回傳`true`

MatchString MatchReader 以此類推

#### func (*Regexp) [NumSubexp](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=335)

```go
func (re *Regexp) NumSubexp() int
```

回傳`*Regexp`中帶括號表達式的數量

Example

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	re0 := regexp.MustCompile(`a.`)
	fmt.Printf("%d\n", re0.NumSubexp()) // 0

	re := regexp.MustCompile(`(.*)((a)b)(.*)a`)
	fmt.Println(re.NumSubexp()) // 4
}
```

#### func (*Regexp) [ReplaceAllString](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=570)

```go
func (re *Regexp) ReplaceAllString(src, repl string) string
```

> ReplaceAllString returns a copy of src, replacing matches of the Regexp with the replacement string repl. Inside repl, $ signs are interpreted as in Expand, so for instance $1 represents the text of the first submatch.

將符合`*Regexp`的內容以`repl`取代並回傳，在`repl`中`$`代表expand而非原本的`end of text`的意思

Example

```go
package main

import (
	"fmt"
	"regexp"https://pkg.go.dev/regexp#example-Regexp.ReplaceAllString
)

func main() {
	re := regexp.MustCompile(`a(x*)b`)
	fmt.Println(re.ReplaceAllString("-ab-axxb-", "T"))
	fmt.Println(re.ReplaceAllString("-ab-axxb-", "$1"))
	fmt.Println(re.ReplaceAllString("-ab-axxb-", "$1W"))
	fmt.Println(re.ReplaceAllString("-ab-axxb-", "${1}W"))
}
```

```
Output:

-T-T-
--xx-
---
-W-xxW-
```

這東西比較複雜，看了[StackOverFlow](https://stackoverflow.com/questions/34673039/go-replaceallstring)才略懂一二

將四次執行的結果分別看:

1. 這個最好理解，就是將符合``a(x*)b``的內容`"ab"`和`"axxb"`分別取代成`"T"`，最後變為`"-T-T-"`

2. `$1`會反向獲取第一個被捕獲的內容，也就是符合`(x*)`的內容，也就是在`"axxb"`中的 `"xx"`

   `"ab"`的部分因為不包含符合`(x*)`的內容所以會以空字串取代

   例如改成`re.ReplaceAllString("-axxxb-axxb-", "$1")`則會回傳 `"-xxx-xx-"`

3. 根據expand的規則`"$1W"`會被視為`"${1W}"`，由於這個東西未定義，所以會以空字串取代

4. 綜合第一個和第二個結果

ReplaceAll系列都是同理，不多談了

#### func (*Regexp) [Split](https://cs.opensource.google/go/go/+/go1.17:src/regexp/regexp.go;l=1244)

```go
func (re *Regexp) Split(s string, n int) []string
```

就是以`*Regexp`作為split的規則，n代表要拆成多少個內容(由左而右，多的就保持原樣)

Example:

```go
s := regexp.MustCompile("a*").Split("abaabaccadaaae", 5)
// s: ["", "b", "b", "c", "cadaaae"]
```

The count determines the number of substrings to return:

```
n > 0: at most n substrings; the last substring will be the unsplit remainder.
n == 0: the result is nil (zero substrings)
n < 0: all substrings
```
