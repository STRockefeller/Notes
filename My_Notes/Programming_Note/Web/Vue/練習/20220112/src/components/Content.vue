<template>
  <div class="bg-green-100 ml-1 w-full">
    <content-nav />
    <router-view></router-view>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import ContentNav from "./Content/ContentNav.vue";

@Options({
  components: {
    ContentNav,
  },
})
export default class App extends Vue {}
</script>
