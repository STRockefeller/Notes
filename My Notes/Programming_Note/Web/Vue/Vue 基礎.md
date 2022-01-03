# Vue Basic

更基礎的部分，如環境建置、專案結構等等，請參閱另一篇筆記(Vue 前置)



## Version

目前(2021.12)，Vue 有兩個主流的版本，分別是Vue 2和 Vue 3，基本上我在筆記中會盡量把兩種都記錄下來(如果能夠比較的話)



## TS or JS ?

個人而言比較習慣使用TS開發，不過各大社群資源都會以JS為主，為求方便，筆記也會以JS為主，並且視情況補上TS的版本



## Initialization

雖然在前置筆記已經有大略提過了，不過這邊就再補充一些細節吧。

這邊我做兩次初始化專案，分別為Vue2 和 Vue3 的專案，也方便我之後筆記寫範例做使用

### Vue 3

首先Vue3 ，不管是初始化哪個版本的專案，都是下`vue create`就可以了，後面可以選擇preset，挑選對應的版本就能夠成功建立專案。

如果preset選擇Maually還是可以看到版本選擇的選項:

```powershell
? Choose a version of Vue.js that you want to start the project with (Use arrow keys)
> 2.x
  3.x
```

不過我這邊圖個方便直接使用預設的Vue 3 preset

```powershell
PS D:\Rockefeller\Projects_Test\Vue_test> vue create 20211223v3


Vue CLI v4.5.15
? Please pick a preset: Default (Vue 3) ([Vue 3] babel, eslint)


Vue CLI v4.5.15
✨  Creating project in D:\Rockefeller\Projects_Test\Vue_test\20211223v3.
🗃  Initializing git repository...
⚙️  Installing CLI plugins. This might take a while...


added 1276 packages, and audited 1277 packages in 1m

84 packages are looking for funding
  run `npm fund` for details

28 vulnerabilities (17 moderate, 11 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
🚀  Invoking generators...
📦  Installing additional dependencies...


added 73 packages, and audited 1350 packages in 11s

91 packages are looking for funding
  run `npm fund` for details

30 vulnerabilities (19 moderate, 11 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
⚓  Running completion hooks...

📄  Generating README.md...

🎉  Successfully created project 20211223v3.
👉  Get started with the following commands:

 $ cd 20211223v3
 $ npm run serve
```



### Vue 2

打鐵趁熱把Vue 2也建立出來

```powershell
PS D:\Rockefeller\Projects_Test\Vue_test> vue create 20211223v2


Vue CLI v4.5.15
? Please pick a preset: Default ([Vue 2] babel, eslint)


Vue CLI v4.5.15
✨  Creating project in D:\Rockefeller\Projects_Test\Vue_test\20211223v2.
🗃  Initializing git repository...
⚙️  Installing CLI plugins. This might take a while...


added 1276 packages, and audited 1277 packages in 29s

84 packages are looking for funding
  run `npm fund` for details

28 vulnerabilities (17 moderate, 11 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
🚀  Invoking generators...
📦  Installing additional dependencies...


added 55 packages, and audited 1332 packages in 3s

89 packages are looking for funding
  run `npm fund` for details

30 vulnerabilities (19 moderate, 11 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
⚓  Running completion hooks...

📄  Generating README.md...

🎉  Successfully created project 20211223v2.
👉  Get started with the following commands:

 $ cd 20211223v2
 $ npm run serve
```



### 專案結構

簡單比較一下專案結構，發現兩者是一模一樣的。(專案結構的說明在前置筆記有寫過，這裡不加贅述)



### 程式進入點

來比較一下main.js

Vue 3

```js
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#app')

```

createApp definition

```typescript
export declare const createApp: CreateAppFunction<Element>;
```

mount definition

```typescript
mount(rootContainer: HostElement | string, isHydrate?: boolean, isSVG?: boolean): ComponentPublicInstance;
```





Vue 2

```js
import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')

```

$mount definition

```typescript
$mount(elementOrSelector?: Element | string, hydrating?: boolean): this;
```



### App.vue

Vue 3

```vue
<template>
  <img alt="Vue logo" src="./assets/logo.png">
  <HelloWorld msg="Welcome to Your Vue.js App"/>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>

```



Vue 2

```vue
<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>

```



幾乎是一樣的，只差在Vue 3少了`<div id="app">`tag，不過把他run起來看網頁還是有`<div id="app">`

兩邊專案run起來外觀是沒有區別的。



## 安裝TypeScript

建立專案的時候如果選擇Manually也有TypeScript的選項在，不過這邊就用預設的preset再安裝一次

執行 `vue add typescript`

這次全部的選項都YES 我全都要

```powershell
? Use class-style component syntax? Yes
? Use Babel alongside TypeScript (required for modern mode, auto-detected polyfills, transpiling JSX)? Yes
? Convert all .js files to .ts? Yes
? Allow .js files to be compiled? Yes
? Skip type checking of all declaration files (recommended for apps)? Yes
```



### 比較版本差異

執行後比較，發現vue 2比 vue 3 還多了一個宣告檔，那就先來看它吧

#### shims-tsx.d.ts (vue 2 only)

```typescript
import Vue, { VNode } from 'vue'

declare global {
  namespace JSX {
    // tslint:disable no-empty-interface
    interface Element extends VNode {}
    // tslint:disable no-empty-interface
    interface ElementClass extends Vue {}
    interface IntrinsicElements {
      [elem: string]: any
    }
  }
}

```

這邊很尷尬的是我找不到這東西到底被用在哪裡...



#### shims-vue.d.ts

vue 3

```typescript
/* eslint-disable */
declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

```



vue 2

```typescript
declare module '*.vue' {
  import Vue from 'vue'
  export default Vue
}

```



兩者定義的主要目的都是在main.ts建立vue實例，其中 vue 2 的 Vue 有更多的參考，不過我看其他就不是重點了。



#### main.ts

vue 3

```typescript
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#app')

```



vue 2

```typescript
import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')

```



基本上和js的版本沒兩樣。



#### App.vue

這個就直接貼比較圖好了

vue 3

![](https://upload.cc/i1/2021/12/23/qV2r3P.png)



vue 2

![](https://upload.cc/i1/2021/12/23/Ekg8pa.png)



基本上十分接近，最大的差異在於引用的套件 vue-property-decorator (vue 2) 和 vue-class-component ( vue 3)



## 安裝 tailwind

執行 `vue add tailwind`

vue 3 和 vue 2 的變化是一樣的，值得一提的是 兩邊的頁面顯示出來Vue的logo都跑到最左邊去了

只好手動把它掰回來，不然看了很不順眼，在img外面套一層div給一些tailwind

```html
<div class="flex justify-center">
	<img alt="Vue logo" src="./assets/logo.png" />
</div>
```

(flex 常常被我忘掉想說怎都沒反應...)



## @Options (Vue3) / @Component (Vue2)

### data()

在template新增，把變數用`{{}}`包起來

```html
<div class="data-test">{{data_test}}</div>
```

然後是script 的 @options裡面新增`data()`方法

```javascript
data(){
    return {
      data_test:'data test'
    }
  }
```

Vue2 或 Vue3都適用



---

在.net系列也有類似的功能，詳細可以翻以前的筆記。

Blazor

```C#
@page "/Bind"
<h3>@title</h3>

@code {
    string title = "BindTestComponent";
}
```

---



想試著改成ts的版本，但失敗了，最後什麼都沒印出來

```typescript
  data():Map<string,any>{
    var result:Map<string,any> = new Map<string,any>();
    result.set('data_test','data test');
    return result;
  }
```



### Template

在@Options/@Component裡面新增欄位`template`，可以直接在這邊寫`html`，不過有一些限制，目前看來還是寫在`<template></template>`裡面比較合適。

```typescript
// Vue2
@Component({
    template:`<div>template</div>` // Vue2 限制不多不少只能有一個最外層的tag
    //...
})

// Vue3
@Options({
    template:"template" // Vue3 的限制比較寬鬆
    //...
})
```



### methods

用法和data很像，Vue2和Vue3使用起來也沒有區別



Vue2

```vue
<template>
	<div class="method-test">{{SayHello()}} World !!</div>
</template>
<script lang="ts">
    import { Component, Vue } from "vue-property-decorator";
    @Component({
        methods: {
    		SayHello: function (): string {
      			return "Hello";
    		},
 		 },
    })
    export default class App extends Vue {}
</script>
```



Vue3

```vue
<template>
	<div class="method-test">{{SayHello()}} World !!</div>
</template>
<script lang="ts">
    import { Options, Vue } from "vue-class-component";
    @Options({
        methods: {
    		SayHello: function (): string {
      			return "Hello";
    		},
 		 },
    })
    export default class App extends Vue {}
</script>
```



以下都以Vue3示範

也可以在方法裡面呼叫相同實體的其他方法。

```vue
<template>
    <div class="method-test">{{ SayHelloWorld() }}!!</div>
</template>
<script lang="ts">
    import { Options, Vue } from "vue-class-component";
    @Options({
        methods: {
    		SayHello: function (): string {
      			return "Hello";
    		},
            SayHelloWorld: function (): string {
      			return this.SayHello() + " World";
    		},
 		 },
    })
    export default class App extends Vue {}
</script>
```



箭頭函式也是可以使用的

```typescript
SayHello: function (): string {
	return "Hello";
},
```
可以改成
```typescript
SayHello: ()=> {return "Hello"},
```

這種寫法要注意方法裡面的`this`代表的不是vue 實體，而是window

也可以改成

```typescript
SayHello: () {return "Hello"},
```

這種寫法的`this`就會對應到vue實體了

### Computed

跟methods很相似的東西

例如把上面的例子

```vue
<template>
	<div class="method-test">{{SayHello()}} World !!</div>
</template>
<script lang="ts">
    import { Options, Vue } from "vue-class-component";
    @Options({
        methods: {
    		SayHello: function (): string {
      			return "Hello";
    		},
 		 },
    })
    export default class App extends Vue {}
</script>
```

`SayHello()`改成`SayHello`，`methods`改成`computed`後

```vue
<template>
	<div class="method-test">{{SayHello}} World !!</div>
</template>
<script lang="ts">
    import { Options, Vue } from "vue-class-component";
    @Options({
        computed: {
    		SayHello: function (): string {
      			return "Hello";
    		},
 		 },
    })
    export default class App extends Vue {}
</script>
```

可以印出一樣的東西(這邊我是重新yarn run serve才顯示出來，hot reload沒有作用)

首先注意到在template呼叫computed方法的時候，不用寫`()`，因此需要傳入參數的方法就不適合放在computed



還有一點不同的是computed會在執行方法後將結果暫存，下次呼叫computed時，如果條件不變，就會直接取出上次的暫存值使用。

例如把剛剛的範例改成

```html
<template>
	<div class="method-test">{{SayHello}} World !!</div>
    <div class="method-test">{{SayHello}} World !!</div>
    <div class="method-test">{{SayHello}} World !!</div>
</template>
```

第二次和第三次的`{{SayHello}}`就不會執行方法而是直接取出先前暫存的`SayHello()`的輸出結果做使用。

如果方法執行條件有變化，computed會重新執行一次方法，所以不用擔心取得錯誤的值。

