# Type Annotation

Reference: https://ithelp.ithome.com.tw/articles/10214719



## [Maxwell Alexius](https://ithelp.ithome.com.tw/users/20120614/ironman)的分類

- **原始型別 Primitive Types**：包含 `number`, `string`, `boolean`, `undefined`, `null`, ES6 介紹的 `symbol` 與時常會在*函式型別*裡看到的 `void`
- 物件型別 Object Types，但我個人還會再細分成小類別，但這些型別的共同特徵是 ——從原始型別或物件型別組合出來的複合型態（比如物件裡面的 Key-Value 個別是`string`和`number`型別組合成的）：
  - **基礎物件型別**：包含 JSON 物件，陣列（`Array<T>`或`T[]`），類別以及類別產出的物件（也就是 Class 以及藉由 Class *`new`* 出來的 Instance）
  - **TypeScript 擴充型別**：即 Enum 與 Tuple，內建在 TypeScript
  - **函式型別 Function Types**：類似於 `(input) => (Ouput)` 這種格式的型別，後面會再多做說明
- **明文型別 Literal Type**：一個值本身也可以成為一個型別，比如字串 `"Hello world" —— 若成為某變數的型別的話，它只能存剛好等於`"Hello world"` 字串值；但通常會看到的是 Object Literal Type，後面也會再多做說明
- **特殊型別**：筆者自行分類的型別，即 `any`、`never`（TS 2.0釋出）以及最新的 `unknown` 型別（TS 3.0釋出），讀者可能覺得莫名其妙，不過這些型別的存在仍然有它的意義，而且很重要，*陷阱總是出現在不理解這些特殊型別的特性*
- **複合型別**：筆者自行分類的型別，即 `union` 與 `intersection` 的型別組合，但是跟其他的型別的差別在於：這類型的型別都是由邏輯運算子組成，分別為 `|` 與 `&`
- **通用型別 Generic Types**：留待進階的 TypeScript 文章介紹，一種讓程式碼可以變得更加通用的絕招



![](https://ithelp.ithome.com.tw/upload/images/20190914/20120614sgSyV2LjS0.png)



## Overload functions(?) test

主要是想測試輸入輸出中含有`|`運算子的function，暫時沒有找到這東西要怎麼稱呼，因為覺得與overloading有幾分相似之處，就先這樣暫稱。以後找到專有名詞再來改。



假設我有一個function如下

```typescript
function return20(param:boolean):string|number{
    if(param){
        return "20";
    }else{
        return 20;
    }
}
```

測試以下內容輸出

```typescript
var v = return20(true);
console.log(typeof v);
v = return20(false);
console.log(typeof v);
```

```
[LOG]: "string" 
[LOG]: "number" 
```

compiler會認定`v`是`string|number`型別

![](https://i.imgur.com/OhuU9lb.png)

如果要硬塞其他東西進去就會報錯

![](https://i.imgur.com/pyG8IHP.png)



如過把 `v`的型別設定為`string`或是`number`其中之一，即便`return20()`回傳正確的型別，還是會被編譯器報錯。

![](https://i.imgur.com/LXp2KL2.png)

當然如過寫成

```typescript
var v:string|number = return20(true);
```

或者

```typescript
var v:string = <string>return20(true);
```

就沒問題了。

不過第二個寫法要用到react，所以在playground行不通，我有另外在vscode中測試是可行的。

[Playground Link](https://www.typescriptlang.org/play?#code/FAMwrgdgxgLglgewgAgE4FMZlRATABgAoAHAQ1VIFsAuAIwQQBt1SIBKagZxlTggHMAPhDCVa6VAG9gyWcjggS5Km2lz1aTNhQAiAjoDcMuQF90jTujUbZGLDmQEj6k8FfAAbuWQeuPPkIiYhLIALya9nhEPGDobEZQSJxM6AB0jAj8hDAAnsToCCA+8Z5hEdoEhCCkFnEJSSnpmdl5BUUeJZ7eHrh+vAJlADzc-fwAfHYV0aix8UA)