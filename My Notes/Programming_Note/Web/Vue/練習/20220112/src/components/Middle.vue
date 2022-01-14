<template>
    <div class="bg-green-100 h-screen pt-11 flex flex-row pb-7">
        <left-nav/>
        <content/>
    </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import LeftNav from "./LeftNav.vue"
import Content from "./Content.vue"

@Options({
    components:{
        LeftNav,
        Content,
    }
})

export default class App extends Vue {}
</script>
