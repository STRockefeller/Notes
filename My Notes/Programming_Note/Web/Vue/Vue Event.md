# Event

[複習js的事件機制](https://ithelp.ithome.com.tw/articles/10191970)

參考

[重新認識Vue.js](https://book.vue.tw/CH1/1-5-events.html)



## v-on

透過 `v-on`我們可以把方法綁定到事件中



用法很簡單，假如我有一個data

```javascript
  data() {
    return {
      count: 1,
    };
  },
```

我想透過點擊按鈕讓data的數值變動

```html
<button v-on:click="count++">MyButton</button>
```



也可以call方法

```typescript
  methods: {
    Add: function (): void {
      this.count++;
    },
  },
```

```html
<button v-on:click="Add">MyButton</button>
```



`v-on:` 可以縮寫成 `@`

```html
<button @click="Add">MyButton</button>
```



完整範例

```vue
<template>
  <p>Count: {{ count }}</p>
  <button v-on:click="Add">function Add()</button>
  <button v-on:click="count--">count--</button>
  <button @click="count*=2">@</button>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
      count: 1,
    };
  },
  methods: {
    Add: function (): void {
      this.count++;
    },
  },
})
export default class Event extends Vue {}
</script>

```



## event object

沒有輸入參數時`v-on`會預設傳入event物件

```vue
<template>
  <button @click="GetEvent">Event</button>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  methods: {
    GetEvent:function(event:any):void{ // 這邊我曉得這個event的型別，所以先給any
      alert(event.target.tagName) // 會印出 BUTTON
    }
  },
})
export default class Event extends Vue {}
</script>

```



有其他參數要傳時，也可以透過`$event`傳入event



## Modifiers

### .stop

阻擋事件冒泡

### .prevent

阻擋預設行為

### .capture

改成Capturing事件(預設是Bubbling)

### .self

不會出發子層行為，例如

```html
<div id="outer" @click.self="DoSomething">
    <div id="inner">Hello</div>
</div>
```

點到inner的內容並不會觸發outer的click事件

### .once

事件只會觸發一次

### .passive

無視PreventDefault 或 .prevent



## keyboard event

先來個沒啥用的例子

```vue
<template>
  <input type="text" @keypress.enter="SayHello">
  <input type="text" @keypress="Alert">
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  methods: {
    Alert:function(event:any):void{
      alert(event.key);
    },
    SayHello:function():void{
      alert("Hello");
    }
  },
})
export default class Event extends Vue {}
</script>

```

第一個input會在使用者按下<kbd>Enter</kbd>的時候告訴使用者印出Hello

第二個input會在使用者按下任意案件的時候告訴使用者他剛才按下了什麼按鍵



### keyboard event modifiers

按下對應的案件會觸發

| Modifier | Keyboard                                |
| -------- | --------------------------------------- |
| .enter   | <kbd>Enter</kbd>                        |
| .tab     | <kbd>Tab</kbd>                          |
| .delete  | <kbd>Delete</kbd>或<kbd>Backspace</kbd> |
| .esc     | <kbd>Esc</kbd>                          |
| .space   | <kbd>Space</kbd>                        |
| .up      | <kbd>Up</kbd>                           |
| .down    | <kbd>Down</kbd>                         |
| .left    | <kbd>Left</kbd>                         |
| .right   | <kbd>Right</kbd>                        |
| .ctrl    | <kbd>Ctrl</kbd>                         |
| .alt     | <kbd>Alt</kbd>                          |
| .shift   | <kbd>Shift</kbd>                        |
| .meta    | <kbd>Windows</kbd>或<kbd>Command</kbd>  |

其他

.exact

只有完全符合的情況才會觸發，例如按下  <kbd>Ctrl</kbd>+  <kbd>Enter</kbd>不會觸發.exact.enter事件



## mouse event

基本上和鍵盤差不多，快速帶過

### mouse event modifiers

.left

.right

.middle
