<template>
  <div class="bg-white w-60 h-auto pt-4">
    <button
      @click="dropdown = !dropdown"
      id="dropdownButton"
      data-dropdown-toggle="dropdown"
      class="
        text-black
        bg-green-100
        hover:bg-green-200
        focus:ring-4 focus:ring-blue-300
        font-medium
        rounded-full
        text-sm
        px-4
        py-2.5
        text-center
        inline-flex
        items-center
        dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800
      "
      type="button"
    >
      vue_20220112
      <svg
        class="ml-2 w-4 h-4"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M19 9l-7 7-7-7"
        ></path>
      </svg>
    </button>

    <!-- Dropdown menu -->
    <div
      v-show="dropdown"
      id="dropdown"
      class="
        absolute
        z-10
        w-44
        text-base
        list-none
        bg-white
        rounded
        divide-y divide-gray-100
        shadow
        dark:bg-gray-700
      "
    >
      <ul class="py-1" aria-labelledby="dropdownButton">
        <li>
          <a
            href="#"
            class="
              block
              py-2
              px-4
              text-sm text-gray-700
              hover:bg-gray-100
              dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white
            "
            >新增/取消收藏</a
          >
        </li>
        <li>
          <a
            href="#"
            class="
              block
              py-2
              px-4
              text-sm text-gray-700
              hover:bg-gray-100
              dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white
            "
            >在編輯器中打開</a
          >
        </li>
        <li>
          <a
            href="#"
            class="
              block
              py-2
              px-4
              text-sm text-gray-700
              hover:bg-gray-100
              dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white
            "
            >重新命名</a
          >
        </li>
        <li>
          <a
            href="#"
            class="
              block
              py-2
              px-4
              text-sm text-gray-700
              hover:bg-gray-100
              dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white
            "
            >專案管理器</a
          >
        </li>
      </ul>
    </div>

    <div id="nav-list" class="mt-6">
      <ul>
        <template v-for="link in nav_list" :key="link.name">
          <li>
            <div class="h-11 hover:bg-green-50 grid content-center">
              <router-link :to="link.link">{{ link.name }}</router-link>
            </div>
          </li>
        </template>
      </ul>
    </div>

    <!-- footer button -->
    <div
      class="fixed bottom-8 flex justify-center w-48"
      :class="menu_class"
    >
      <button class="w-full" @click="OnMenuClick"><b>更多</b></button>
    </div>

    <!-- more menu -->
    <div
      class="
        fixed
        left-52
        bottom-8
        absolute
        z-10
        bg-white
        border-gray-300 border-2
      "
      v-show="more"
    >
      <ul>
        <template v-for="menu in more_menu" :key="menu">
          <li>
            <button class="hover:bg-green-50">{{ menu }}</button>
          </li>
        </template>
      </ul>
    </div>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

@Options({
  data() {
    return {
      dropdown: false,
      nav_list: [
        {
          name:"控制台",
          link:"/console"
          },
       {
         name:"插件",
         link:"/plugins"
         },
       {
         name:"依賴",
         link:"/dependencies"
         },
       {
         name:"設定",
         link:"/configuration"
         },
       {
         name:"任務",
         link:"/tasks"
         },
       ],
      more: false,
      more_menu: ["Vue專案管理器", "關於"],
      menu_class: 'bg-white hover:bg-green-50 text-black'
    };
  },
  methods: {
    OnMenuClick: function ():void {
      this.more = !this.more
      if(this.more){
        this.menu_class = 'bg-gray-700 hover:bg-gray-700 text-white'
      }
      else{
        this.menu_class = 'bg-white hover:bg-green-50 text-black'
      }
    },
  },
})
export default class App extends Vue {}
</script>