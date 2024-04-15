# Reflect

tags: #golang #reflection

## Abstract

寫reflect遇到一些坑，把他們記下來，免得再次踩坑

## Traps

### interface reference

情境 要找interface裡面的方法

錯誤 會跳找不到參考的panic

```go
var targetInterface IMyInterface
reflect.TypeOf(targetInterface)

//or

reflect.TypeOf(IMyInterface)
```

正確 但不是所要的

```go
reflect.TypeOf(IMyInterface.Method1)
```

正確的作法 使用指定interface的nil指標傳入 (注意此時是指標所以要用.Elem()才可以取得內容)

```go
reflect.TypeOf((*IMyInterface)(nil)).Elem()
```

### Pointers

`typeOf(ptr)`會取得一大堆空的東西，通常不是我們要的，所以會使用`Elem()`方法取值再繼續下去

例如

```go
if m.Type.In(i).Name() == "" {
			newMethod.Arguments = append(newMethod.Arguments, "*"+m.Type.In(i).Elem().Name())
		} else {
			newMethod.Arguments = append(newMethod.Arguments, m.Type.In(i).Name())
		}
```

如果方法的引數是指標的話`m.Type.In().Name()`會得到空字串，所以反過來偵測空字串並使用`.Elem()`取值再回傳。
