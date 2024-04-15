# Vue Router

## installation

```bash
vue add router
```

或是在建立專案的時候選擇



---

題外話

每次`vue add`都會被提醒要先commit為儲存的內容，每次都不在意

直到這次add router App.Vue的內容直接整個被覆蓋掉，還不給<kbd>Ctrl</kbd>+<kbd>z</kbd>...

---



## Usage

使用方式很簡單，在安裝完成後新增的 `/router/index.js` 或 `/router/index.ts`裡面會看到一個array

```typescript
const routes: Array<RouteRecordRaw> = []
```

在裡面新增項目以指定route

```typescript
{
    path: '/', // 路徑 ex: '/home'
    name: 'Home', // 名稱
    component: Home // component所在位置 ex: () => import('./../components/Content/Console.vue')
},
```



在想要呈現的地方使用`<router-view></router-view>`這個tag就會把相應的component呈現出來啦



另外也有提供專屬的連結用tag

```html
<router-link to="/">Go to Home</router-link>
```



## Compare with .Net core MVC

跟.net的做法剛好是反過來的，.Net會把畫面中固定的部分寫在layout或partial view並且鑲嵌在每個頁面中。

Vue 則是把時常變動的內容根據router做切換。

實際上vue在切到不存在的route時，也不會變成404，只會在Console跳個警告而已

![](https://i.imgur.com/MeVWFpi.png)