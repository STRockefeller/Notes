# Declare

Reference:

[TypeScript新手指南](https://willh.gitbook.io/typescript-tutorial/basics/declaration-files)



## Abstract

起因是vue在安裝ts後生成的`shims-vue.d.ts`

```typescript
/* eslint-disable */
declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

```

發現了一段我不認得的敘述`declare module`，雖然看Code大概就能知道他做了什麼，不過此時正是了解新技術的好機會。


索引：

- `declare var` 宣告全域變數

- `declare function` 宣告全域方法

- `declare class` 宣告全域類別

- `declare enum` 宣告全域列舉型別

- `declare namespace` 宣告（含有子屬性的）全域物件

- `interface` 和 `type` 宣告全域型別

- `export` 匯出變數

- `export namespace` 匯出（含有子屬性的）物件

- `export default` ES6 預設匯出

- `export =` commonjs 匯出模組

- `export as namespace` UMD 函式庫宣告全域變數

- `declare global` 擴充套件全域變數

- `declare module` 擴充套件模組

- `/// ` 三斜線指令



## 宣告檔(.d.ts)

通常情況下，我們會把宣告的內容放置於`.d.ts`檔案中。

一般來說，ts 會解析專案中所有的 `*.ts` 檔案，當然也包含以 `.d.ts` 結尾的檔案。所以當我們將 `shims-vue.d.ts` 放到專案中時，其他所有 `*.ts` 檔案就都可以獲得 `component` 的型別定義。

![](https://upload.cc/i1/2021/12/21/m2gIUz.png)

像是圖中的App就會帶有component型別



如果宣告沒有效果的話，可以檢查tsconfig裡面的include和exclude欄位，是否有涵蓋到目標檔案類型

例如我的vue專案中是長這樣

```json
  "include": [
    "src/**/*.ts",
    "src/**/*.tsx",
    "src/**/*.vue",
    "tests/**/*.ts",
    "tests/**/*.tsx"
  ],
  "exclude": [
    "node_modules"
  ]
```



## 宣告語句

假如我們在`.ts`中，猝不及防的給個jQuery語法，會像這樣子

```typescript
jQuery('#App'); // Cannot find name 'jQuery'.ts(2304)
```



這時若我們新增一個宣告檔案並且宣告`jQuery`是甚麼意思，編譯器就能認得啦

jquery.d.ts

```typescript
declare let jQuery:(selector:string) => any;
```

再回去看剛才出錯的地方，編譯器就能認得jQuery的型別了(當然因為沒有實作所以不會有jQuery的功能)



## 第三方宣告檔案

事實上，像是jQuery這種常用的工具，一般都能找到別人幫我們訂好的宣告檔

像是這個[jQuery.d.ts](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/jquery/JQuery.d.ts)多達13,024行，我想不會有人想自己寫一遍



@types是其中時常被推薦的宣告檔案管理方式

像是安裝jQuery的宣告檔案，通常會這麼做

```bash
npm install @types/jquery --save-dev
```

如果想找自己想用的框架有沒有ts宣告檔，可以到[這裡](https://www.typescriptlang.org/dt/search?search=)查詢(看網域名稱應該是官網吧)



## 宣告全域物件

宣告完成後可以在整個專使用

使用方法與一般宣告變數、方法等等十分接近，這邊就快速帶過



### 變數

看[前面](#宣告語句)jQuery的範例就是了。

另外視需求也可以用`var` `const`等等關鍵字

> 一般來說，全域變數都是禁止修改的常數，所以大部分情況都應該使用 `const` 而不是 `var` 或 `let`。



另外要注意的是，我們只能宣告型別，**不能包含實作(或實體)**，接下來提到的也都適用。

例如

```typescript
declare const cannotImplement:string = "Hello World!"; // nitializers are not allowed in ambient contexts.
```



### 方法

可以overload，一樣不能實作

```typescript
declare function func1():void;
declare function func1(param:number):void;
```



### 類別

再說一次，不能實作

```typescript
declare class Human {
    name: string;
    age: number;
    constructor(name: string, age: number);
}
```



### 列舉

不能有列舉值

```typescript
declare enum weather{
    sunny,
    rainy,
    cloudy
}
```



### 命名空間

```typescript
declare namespace Hello{
    function Say():string;
    const value:string;
}
```



### 介面

無須declare

例如在宣告檔中(XXX.d.ts)

```typescript
interface IHuman{
    dance():void;
}
```

使用的時候(XXX,ts)

```typescript
class Human implements IHuman{
    dance(): void {
        throw new Error('Method not implemented.');
    }
}
```

為了避免命名衝突，一般會建議把interface宣告在namespace裡面

改成

宣告:

```typescript
declare namespace Human{
    interface IHuman{
        dance():void;
    }
}
```

使用:

```typescript
class Human implements Human.IHuman{
    dance(): void {
        throw new Error('Method not implemented.');
    }
}
```





## Export 相關

主要是跟輸出宣告檔有關，目前沒有機會用到，**待補充**