# Vue 疑難雜症



## 先重 Run 一次試試看

寫在最前面，因為發現Vue的 hot reload 真的時常不管用，常常找了半天不知道自己哪裡寫錯，隔天再run一次才發現原來本來就沒寫錯...



## Q&A

### Q1.在Vue2專案加入TS產生的shims.tsx.ts是做什麼用的?

內容如下

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

完全找不到參考，然後Vue3專案完全沒有這玩意兒

### A1

[StackOverFlow](https://stackoverflow.com/questions/54622621/what-does-the-shims-tsx-d-ts-file-do-in-a-vue-typescript-project)



### Q2. export defineComponent or class extends Vue?

怎麼export比較合適?

和App.vue一樣的寫法

```vue
<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({})
export default class MyComponent extends Vue {}
</script>
```



省略class name

```vue
<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({})
export default class extends Vue {}
</script>
```



vsc 套件生成的寫法

[官方文件](https://v3.vuejs.org/api/global-api.html#definecomponent)有說明

```vue
<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
    setup() {
    },
})
</script>
```



官方[這個頁面](https://v3.vuejs.org/guide/single-file-component.html#introduction)的寫法(還是說js都這樣寫?)

```vue
<script>
export default {
  data() {
    return {
      greeting: 'Hello World!'
    }
  }
}
</script>
```

