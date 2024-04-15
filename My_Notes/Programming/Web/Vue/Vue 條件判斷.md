# 條件判斷

先來一個測試用Component

```vue
<template>
    <div class="bg-indigo-900 text-red-100">
        Message
    </div>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
    })
    export default class Conditions extends Vue{}
</script>

```



## v-if

當條件達成時顯示tag



example:

利用v-model和checkbox來控制message的顯示

```vue
<template>
    <input type="checkbox" value="if" v-model="show">
    <label for="if">v-if test</label>
    <div v-if="show" class="bg-indigo-900 text-red-100">
        Message
    </div>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
        data(){
            return {
                show: true,
            }
        }
    })
    export default class Conditions extends Vue{}
</script>

```

![](https://i.imgur.com/NNFCWOp.png)





不意外的，也有else if 和 else

```vue
<template>
    <input type="checkbox" value="if" v-model="show">
    <label for="if">v-if test</label>
    <br/>
    <input type="checkbox" value="elseif" v-model="elseIfShow">
    <label for="elseif">v-else-if test</label>
    <div v-if="show" class="bg-indigo-900 text-red-100">
        Message
    </div>
    <div v-else-if="elseIfShow" class="bg-indigo-900 text-red-100">
        Message2
    </div>
    <div v-else class="bg-indigo-900 text-red-100">
        Message3
    </div>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
        data(){
            return {
                show: true,
                elseIfShow: false
            }
        }
    })
    export default class Conditions extends Vue{}
</script>

```

![](https://i.imgur.com/1osQ5OL.png)

![](https://i.imgur.com/lKLg49c.png)

![](https://i.imgur.com/ui2cDRR.png)



## v-show

用起來和單用v-if相似，差別在於v-if在condition為false時，是將該元素完全刪去，而v-show則是添加`display: none`的屬性



## v-for

顧名思義，可以重複建立一些元素



### array

```vue
<template>
    <ul>
        <li v-for="elem in array" :key="elem">{{elem}}</li>
    </ul>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
        data(){
            return {
                array: [1,3,5,7,9]
            }
        }
    })
    export default class Conditions extends Vue{}
</script>

```

![](https://i.imgur.com/ZVnGDSc.png)

記得要指定key，不然編譯器會警告，[參考](https://eslint.vuejs.org/rules/require-v-for-key.html)



也可以取index

```vue
<template>
    <ul>
        <li v-for="(elem,index) in array" :key="elem">index:{{index}} value:{{elem}}</li>
    </ul>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
        data(){
            return {
                array: [1,3,5,7,9]
            }
        }
    })
    export default class Conditions extends Vue{}
</script>

```

注意 index 和 value 的順序和 golang正好相反

![](https://i.imgur.com/bfBfq4l.png)



### object

也可以把物件中的屬性輸出出來

```vue
<template>
    <ul>
        <li v-for="elem in cat" :key="elem">{{elem}}</li>
    </ul>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
        data(){
            return {
                cat:{
                    name : 'princess',
                    color : 'black and white',
                    age: 2
                }
            }
        }
    })
    export default class Conditions extends Vue{}
</script>

```

![](https://i.imgur.com/wyjgjbL.png)



**連屬性名稱一起輸出**

```vue
<template>
    <ul>
        <li v-for="(elem,key) in cat" :key="elem">{{key}}:{{elem}}</li>
    </ul>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
        data(){
            return {
                cat:{
                    name : 'princess',
                    color : 'black and white',
                    age: 2
                }
            }
        }
    })
    export default class Conditions extends Vue{}
</script>

```

![](https://i.imgur.com/CF7H0Bl.png)



**連index一起輸出**

```vue
<template>
    <ul>
        <li v-for="(elem,key,index) in cat" :key="elem">{{index}}:{{key}}:{{elem}}</li>
    </ul>

</template>
<script lang="ts">
    import {Options, Vue} from "vue-class-component";
    @Options({
        data(){
            return {
                cat:{
                    name : 'princess',
                    color : 'black and white',
                    age: 2
                }
            }
        }
    })
    export default class Conditions extends Vue{}
</script>

```

![](https://i.imgur.com/flVHZp5.png)





### 1~n



```vue
<template>
    <ul>
        <li v-for="i in 10" :key="i">{{i}}</li>
    </ul>
</template>
```

![](https://i.imgur.com/j5Lobw9.png)

注意是從1開始



### template

想要渲染多個elements可以用`<template>`打包起來，這個方法在上面的[v-if](#v-if)也適用



```vue
<template>
    <ul>
        <template v-for="i in 5" :key="i">
            <li>{{i}}</li>
            <li>hello</li>
        </template>
    </ul>
</template>
```

![](https://i.imgur.com/xuZKjpp.png)