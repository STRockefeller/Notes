# Code generation

目前有兩個主要的做法，一個是使用template，另一個是使用jennifer套件

前者用法滿簡單的，只需花點時間熟悉template使用的語法就可以了。這邊主要紀錄後者的使用方式。

## 坑

### 關於程式碼重用

一般來說有些重複的片段，可能會使用套件中的Code或Statement結構來達成重用的目的

關於`*jen.Statement`使用上其實必須特別小心，因為如果你在他後方加入其他jen的method會汙染到它的內容

例如，下面這個寫法是OK的，因為後方沒有再加入更多Statement的method

```go
predicateCode := jen.Id("predicate").Func().Call(jen.Id(typeName)).Id("bool")
//...
jenFile.Func().Call(jen.Id("si").Id(linqableTypeName)).Id("Where").Call(predicateCode).Id(linqableTypeName).
//...
```

但如果是下面這種情形

```go
defaultValueCode = jen.Id("var defaultValue " + typeName)
//...
defaultValueCode.Line().
//...
```

就會對該變數造成汙染，第一次使用時可以正常輸出，但是接著第二次第三次使用就會夾帶越來越多非預期的statement

Code結構目前我比較多用在整理而非重複使用，但大概也會有相同的狀況。
