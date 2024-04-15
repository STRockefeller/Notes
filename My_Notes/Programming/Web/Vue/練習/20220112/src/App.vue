<template>
  <top v-if="!connect" />
  <middle />
  <bottom />
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import Top from "./components/Top.vue";
import Middle from "./components/Middle.vue";
import Bottom from "./components/Bottom.vue";

@Options({
  components: {
    Top,
    Middle,
    Bottom,
  },
  data() {
    return {
      connect: false,
    };
  },
})
export default class App extends Vue {}
</script>


<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
