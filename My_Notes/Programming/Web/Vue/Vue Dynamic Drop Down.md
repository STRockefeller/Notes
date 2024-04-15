# Dynamic Drop Down

reference: https://stackoverflow.com/questions/43193721/vue-js-dynamic-dropdown



```vue
new Vue({
    el: '#app',
    data: {
        filters: filters,
        selectedValue: null
    }
})

<div id="app">
     <select v-model="selectedValue">
         <option disabled value="">Please select one</option>
         <option v-for="item in filters" :value="item">{{item}}</option>
     </select>
</div>
```

