# Vue Directives

## v-bind

比較 blazor 的寫法 [[Data Binding]]

用於綁定屬性，寫法是 v-bind:+屬性名稱+屬性內容填寫想要套用的變數

```vue
<template>
  <div v-bind:class="my_button">v-bind test</div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
      my_button: "button1",
    };
  },
})
export default class App extends Vue {}
</script>
```

注意一般data binding的寫法是無法套用到屬性裡面的

```html
  <div class="{{my_button}}">v-bind test</div>
```

這種寫法是行不通的

另外 `v-bind:` 可以縮寫成 `:`

```html
  <div :class="my_button">v-bind test</div>
```

**補充**:

* 如果想要bind多個class，就把他們寫在一起就好了，不用想一堆有的沒有的方法

```typescript
@Options({
  data() {
    return {
      my_button: "class1 class2 class3",
    };
  },
})
```

* 經測試bind 一個回傳string的function是行不通的

## v-model

表單資料的雙向綁定，適用於像是 `<input>`、`<textarea>` 以及 `<select>` 等tag

### input

```vue
<template>
  <div class="test-v-model">
    <input v-model="message">
    <br>
    <b>the message is : {{message}}</b>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
      message:"",
    };
  },
})
export default class App extends Vue {}
</script>
```

![](https://i.imgur.com/AtqoFpM.png)

### textarea

[重新認識vue](https://book.vue.tw/CH1/1-4-directive.html#textarea-%E6%96%87%E5%AD%97%E6%96%B9%E5%A1%8A)這邊的範例寫的不錯，這邊就直接引用了。

```html
<div id="app">
  <p>試著修改看看兩者差異</p>
  
  <p>
    <span>Multiline message is:</span> {{ message }}
  </p>
    
  <textarea v-model="message" placeholder="add multiple lines"></textarea>
  
  <!-- 雖然會顯示，但不會同步更新 -->
  <textarea placeholder="add multiple lines">{{ message }}</textarea>
  
</div>
```

```javascript
const vm = Vue.createApp({
  data () {
   return {
      message: 'Hello'
    } 
  }
});

vm.mount('#app');
```

### input radio

```vue
<template>
  <div>
    <input type="radio"  value="1" v-model="radioValue">
    <label for="one">radio 1</label>
  </div>
  <div>
    <input type="radio"  value="2" v-model="radioValue">
    <label for="two">radio 2</label>
  </div>
  <p>radioValue: {{ radioValue }}</p>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
      radioValue: 1,
    };
  },
})
export default class App extends Vue {}
</script>
```

### input checkbox

```vue
<template>
  <input type="checkbox"  value="A" v-model="checkBoxValue">
  <label for="A">A</label>
  
  <input type="checkbox"  value="B" v-model="checkBoxValue">
  <label for="B">B</label>
  
  <input type="checkbox"  value="C" v-model="checkBoxValue">
  <label for="C">C</label>
  
  <input type="checkbox"  value="D" v-model="checkBoxValue">
  <label for="D">D</label>

  <br>
  <p>Checked value: {{ checkBoxValue }}</p>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
        checkBoxValue: [],
    };
  },
})
export default class App extends Vue {}
</script>
```

題外話，那個陣列的順序還會跟checkbox的勾選順序一樣

另外 checkbox 也可以綁bool

```vue
<template>
  <input type="checkbox"  value="A" v-model="checkBoxValue">
  <label for="A">A</label>

  <br>
  <p>Checked value: {{ checkBoxValue }}</p>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
        checkBoxValue: false,
    };
  },
})
export default class App extends Vue {}
</script>
```

### select

```vue
<template>
  <select v-model="selectValue">
    <option value="hahaha">hihihi</option>
    <option >hehehe</option>
  </select>
  <p>select value : {{selectValue}}</p>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
        selectValue: "",
    };
  },
})
export default class App extends Vue {}
</script>
```

滿有趣的一點就是如果我有給value那綁定到的值就是value，如果沒有，就會綁定到tag裡面的文字

### v-model modifiers

官方提供了一些修飾詞給v-model

#### .lazy

讓v-model不再時時更新資料的變化，改成focus變化時才更新資料

```html
<input v-model.lazy="message">
```

#### .number

嘗試把數值轉換為number型別

#### .trim

過濾前方及後方的空白

## v-text

取代tag內容

Vue2

```vue
<template>
  <div id="app">
    <div class="v-text-test">
      <div v-text="text"></div>
      <div>{{ text }}</div>
      <div v-text="text">world!</div>
      <div>{{ text }} world!</div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";

@Component({
  data() {
    return {
      text: "hello",
    };
  },
})
export default class App extends Vue {}
</script>
```

印出的內容是

```
hello
hello
hello
hello world!
```

第三行的"world"被`text`取代掉了

同樣的內容把它搬到Vue3

Vue3

```vue
<template>
  <div class="v-text-test">
    <div v-text="text"></div>
    <div>{{ text }}</div>
    <div v-text="text">world!</div>
    <div>{{ text }} world!</div>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
 
  data() {
    return {
      text: "hello",
    };
  },
})
export default class App extends Vue {}
</script>
```

會發生 compile error

```bash
 ERROR  Failed to compile with 1 error                                                                                                                   下午2:28:40
 error  in ./src/App.vue?vue&type=template&id=7ba5bd90&ts=true

Module Error (from ./node_modules/vue-loader-v16/dist/templateLoader.js):

VueCompilerError: v-text will override element children.
```

他會認為在v-text的tag裡面有內容是不正常的。

## v-html

基本上和`v-text`差不多，差別在`v-html`裡面的html tag會被渲染出來。

## v-once

基本上和`v-text`差不多，差別在只渲染一次

## v-pre

如果你想印出大括號{{}}，就必須用他

```html
<p v-pre>{{text}}</p>
```

就會印出{{text}}
