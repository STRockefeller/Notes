# Vue.js 基礎 筆記

[Reference:重新認識 Vue.js](https://book.vue.tw/)

[Reference:「小孩才做選擇，我全都要。」小白也能輕鬆瞭解的 Vue.js 與 D3.js](https://ithelp.ithome.com.tw/users/20119062/ironman/2242) 

[Reference:vuejs.org](https://vuejs.org/)

[Reference:Mozilla Tutorial](https://developer.mozilla.org/zh-TW/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/Vue_getting_started)



## CDN

```html
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
```

或

```html
<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
```

老樣子CDN的東西比較少，用下面的方法進行安裝才可以體驗到最完整的Vue



## installation

下`npm install --global @vue/cli`或`yarn global add @vue/cli`

我這邊使用npm安裝

```powershell
PS C:\Users\rockefel> npm install --global @vue/cli
npm WARN deprecated urix@0.1.0: Please see https://github.com/lydell/urix#deprecated
npm WARN deprecated har-validator@5.1.5: this library is no longer supported
npm WARN deprecated @hapi/bourne@1.3.2: This version has been deprecated and is no longer supported or maintained
npm WARN deprecated @hapi/topo@3.1.6: This version has been deprecated and is no longer supported or maintained
npm WARN deprecated resolve-url@0.2.1: https://github.com/lydell/resolve-url#deprecated
npm WARN deprecated apollo-tracing@0.15.0: The `apollo-tracing` package is no longer part of Apollo Server 3. See https://www.apollographql.com/docs/apollo-server/migration/#tracing for details
npm WARN deprecated graphql-extensions@0.15.0: The `graphql-extensions` API has been removed from Apollo Server 3. Use the plugin API instead: https://www.apollographql.com/docs/apollo-server/integrations/plugins/
npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
npm WARN deprecated @hapi/address@2.1.4: Moved to 'npm install @sideway/address'
npm WARN deprecated apollo-cache-control@0.14.0: The functionality provided by the `apollo-cache-control` package is built in to `apollo-server-core` starting with Apollo Server 3. See https://www.apollographql.com/docs/apollo-server/migration/#cachecontrol for details.
npm WARN deprecated request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
npm WARN deprecated @hapi/hoek@8.5.1: This version has been deprecated and is no longer supported or maintained
npm WARN deprecated @hapi/joi@15.1.1: Switch to 'npm install joi'
npm WARN deprecated graphql-tools@4.0.8: This package has been deprecated and now it only exports makeExecutableSchema.\nAnd it will no longer receive updates.\nWe recommend you to migrate to scoped packages such as @graphql-tools/schema, @graphql-tools/utils and etc.\nCheck out https://www.graphql-tools.com to learn what package you should use instead

added 952 packages, and audited 953 packages in 2m

67 packages are looking for funding
  run `npm fund` for details

11 vulnerabilities (4 moderate, 7 high)

Some issues need review, and may require choosing
a different dependency.

Run `npm audit` for details.
npm notice
npm notice New major version of npm available! 7.24.0 -> 8.3.0
npm notice Changelog: https://github.com/npm/cli/releases/tag/v8.3.0
npm notice Run npm install -g npm@8.3.0 to update!
npm notice
```



## Initialization

按照Mozilla的初始化步驟

> 為了探索 Vue 各式各樣的功能，我們將會製作一個待辦事項應用程式。我們將使用 Vue CLI 來創造一個新專案框架來建構我們的應用程式。請跟著以下步驟：
>
> 1. 在終端機 `cd` 切換到你想要創建應用程式的資料夾，然後執行 `vue create moz-todo-vue` 。
> 2. 使用方向鍵以及 Enter 鍵，選擇「 Manually select features 」
> 3. 第一個呈現在你眼前的選單讓你選擇想要加入到專案的功能。確認「 Babel 」和「 Linter / Formatter 」都已選取。如果沒有的話，使用方向鍵及空白鍵來切換選取，當它們都已被選取，按下 Enter 鍵進行下一步。
> 4. 接下來，你要選擇 linter / formatter 的設定。切換到「 Eslint with error prevention only 」然後按下 Enter 。這個設定會進行報錯提醒，但不會強制你修改。
> 5. 然後，你將會被詢問需要哪種自動化的 linting 設定。選擇「 Lint on save 」。這樣每當我們儲存專案檔案時，就會自動幫我們檢查錯誤。按下 Enter 鍵進行下一步。
> 6. 現在，你將要選擇如何管理你的組態檔案。「 In dedicated config files 」將會把你的組態設定放在專門的檔案裡，像是 ESLint 的組態設定會放在它們專門的檔案裡。「 In package.json 」，會把你的組態設定放在應用程式的 `package.json` 檔案裡。選擇「 In dedicated config files 」然後按下 Enter 。
> 7. 最後，你將會被問到是否要將以上設定存為預設值。你可以自行決定，如果未來想要再使用這組設定，請按下 y ， 否則按 n 。
>
> CLI 會開始建構你的專案，並且安裝所需的相依套件。
>
> 如果你之前沒有執行過 Vue CLI ，你將會被問一個問題－請選擇套件管理員。你可以使用方向鍵來選擇你想使用的套件管理員，Vue CLI 將會把這個套件管理員設為預設值。之後如果你想要使用不同的套件管理員，可以在執行 `vue create` 時傳入一個標幟 `--packageManager=<package-manager>` 。舉例來說，如果你現在想要用 npm 來創建 `moz-todo-vue` 專案，但是之前是使用 yarn ，你可以執行 `vue create moz-todo-vue --packageManager=npm` 。



## 專案結構

試著對剛初始化的專案下 `tree` ，結果跑了3239行出來，也太笨重了吧

不可能看完三千多個項目，那就先從最外層開始看吧

```powershell
PS D:\Rockefeller\Projects_Test\Vue_20211213\vue-20211213> Get-ChildItem|Select-Object Mode, Name     

Mode   Name
----   ----
d----- node_modules
d----- public
d----- src
-a---- .gitignore
-a---- babel.config.js
-a---- package-lock.json
-a---- package.json
-a---- README.md
```



* node_modules

  略

* public

  差不多等同於dotnet系列的wwwroot資料夾，放靜態資源

* src

  精華都在這裡

  * main.js

    程式進入點

  * App.vue

    這是 Vue 應用程式的根節點元件

  * components

    放元件的資料夾

  * assets

    放其他靜態資源



### .vue file

先來看看專案預設的App.vue

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

其中:

`<template>` 包含所有的標記結構以及元件的呈現邏輯。

`<script>` 包含元件中所有非顯示的邏輯。最重要的是，你的` <script> `標籤必須輸出一個 JS 物件。這個物件是你在本地端註冊的元件，包含定義屬性、處理本地狀態、定義方法等等。在建置步驟這個物件會被處理及轉換（包含 template 模板），變成一個有 render() 函數的 Vue 元件。

在script中也可以使用typescript語法

> **注意**：如果你想要使用 [TypeScript](https://www.typescriptlang.org/) 語法，你必須把 `<script>` 標籤的 `lang` 屬性設定成 `<script lang="ts">` 來告訴編譯器你要使用 TypeScript 。

`<style>` 是你撰寫元件的 CSS 的地方。如果你加上 scoped 屬性，例如 `<style scoped>` ， Vue 會把樣式的範圍限制在這個單一檔案元件裡。這類似 CSS-in-JS 的解決方案，但是它允許你寫單純的 CSS 。



回頭看看程式進入點 `main.js`

```javascript
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#app')

```

可以看到他是把App.vue引用進來作為`createApp()`的參數了

在網路上的其他教學中可以看到main.js的全貌(可能他們不是使用vue/cli來創建預設專案，亦或者版本不同吧?)

```javascript
const vm = Vue.createApp({
    data(){
        return{
            message: 'Helllo Vue 3.0!'
        }
    }
});

vm.mount('#app')
```

這邊2.x版本和3.x版本會有些許不同

| 2.x         | 3.x             |
| ----------- | --------------- |
| new Vue()   | Vue.createApp() |
| vm.$mount() | vm.mount()      |







## 在Local端執行

執行 npm run serve 或 yarn serve (要停止的話直接<kbd>Ctrl</kbd>+<kbd>C</kbd>中斷就行了)

```powershell
PS D:\Rockefeller\Projects_Test\Vue_20211213\vue-20211213> yarn serve
yarn run v1.22.5
$ vue-cli-service serve
 INFO  Starting development server...
98% after emitting CopyPlugin

 DONE  Compiled successfully in 6110ms                                                                                                                   上午8:20:45

  App running at:
  - Local:   http://localhost:8080/
  - Network: unavailable

  Note that the development build is not optimized.
  To create a production build, run npm run build.
```

打開連結可以看到

![](https://upload.cc/i1/2021/12/16/vpTmol.png)

如果這時試著修該元件內容並儲存，可以看到網頁會跟著hot reload





## 題外話

### Tailwind css

ref : https://medium.com/coding-hot-pot/%E5%A6%82%E4%BD%95%E7%94%A8vue-cli-%E6%90%AD%E9%85%8Dtailwind-css%E9%96%8B%E7%99%BC-42c0f0dc3d3a

同樣是我一直很想嘗試的東西，順便試試在vue project裡面安裝

安裝方式很簡單在專案目錄下`vue add tailwind`就可以了

```powershell
PS D:\Rockefeller\Projects_Test\Vue_20211213\vue-20211213> vue add tailwind
 WARN  There are uncommitted changes in the current repository, it's recommended to commit or stash them first.
? Still proceed? Yes

📦  Installing vue-cli-plugin-tailwind...


added 1 package, and audited 1348 packages in 7s

90 packages are looking for funding
  run `npm fund` for details

30 vulnerabilities (19 moderate, 11 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
✔  Successfully installed plugin: vue-cli-plugin-tailwind

? Generate tailwind.config.js minimal

🚀  Invoking generator for vue-cli-plugin-tailwind...
📦  Installing additional dependencies...


added 99 packages, and audited 1447 packages in 9s

96 packages are looking for funding
  run `npm fund` for details

30 vulnerabilities (19 moderate, 11 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
⚓  Running completion hooks...

✔  Successfully invoked generator for plugin: vue-cli-plugin-tailwind
```

他會幫妳改一些東西

```bash
rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects_Test/Vue_20211213/vue-20211213 (master)
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   package-lock.json
        modified:   package.json
        modified:   src/main.js
        modified:   tree.out

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        postcss.config.js
        src/assets/tailwind.css
        tailwind.config.js

no changes added to commit (use "git add" and/or "git commit -a")
```

比較神奇的是不知道為甚麼要改我的tree.out，那是我為了看專案結構生成出來的東西= =

![](https://upload.cc/i1/2021/12/16/j8uqx7.png)

然後給我一堆亂碼是怎樣



好先不管他，看看其他檔案的改動

main.js

多了tailwind的引用

```js
import './assets/tailwind.css'
```

package.json 和 package-lock.json也是多了一些tailwind的引用

在src/assets多了tailwind.css

```css
@tailwind base;

@tailwind components;

@tailwind utilities;

```







---

這段我不確定是不是一定要做，待確認

執行

```bash
./node_modules/.bin/tailwind init tailwind.js
```

```powershell
PS D:\Rockefeller\Projects_Test\Vue_20211213\vue-20211213> .\node_modules\.bin\tailwind init tailwind.js

Created Tailwind CSS config file: tailwind.js
```

編輯tailwind.js

```javascript
plugins: [
    require('tailwindcss')('tailwind.js'),
    require('autoprefixer')(),
  ]
```

完整看起來像這樣

```javascript
module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('tailwindcss')('tailwind.js'),
    require('autoprefixer')(),
  ]
}

```

---



接著重新啟動vue應該就看的到變化了(如果正在執行中無法透過hot-reload呈現變化，安裝完tailwind後還需要重新yarn run serve一次)



先這樣，再多就離題了，剩下的留到tailwind的筆記再談。
