# Tailwind Basic

Helpful links:

* [ITHELP 排版神器 Tailwind CSS～和兔兔一起快速上手漂亮的元件開發！ 系列](https://ithelp.ithome.com.tw/users/20138853/ironman/3928)
* [Playground](https://play.tailwindcss.com/)
* [Documents](https://tailwindcss.com/docs/)



## Installation

```bash
C:\Users\rockefel>npm install -D tailwindcss

added 96 packages, and audited 97 packages in 7s

20 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```







## Features

### Utility-First

也是Tailwind最核心的使用方式

官方舉了個例子可以很好的看出差異

同樣是一個訊息方塊，這是傳統的寫法

**Using a traditional approach where custom designs require custom CSS**

```html
<div class="chat-notification">
  <div class="chat-notification-logo-wrapper">
    <img class="chat-notification-logo" src="/img/logo.svg" alt="ChitChat Logo">
  </div>
  <div class="chat-notification-content">
    <h4 class="chat-notification-title">ChitChat</h4>
    <p class="chat-notification-message">You have a new message!</p>
  </div>
</div>

<style>
  .chat-notification {
    display: flex;
    max-width: 24rem;
    margin: 0 auto;
    padding: 1.5rem;
    border-radius: 0.5rem;
    background-color: #fff;
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  }
  .chat-notification-logo-wrapper {
    flex-shrink: 0;
  }
  .chat-notification-logo {
    height: 3rem;
    width: 3rem;
  }
  .chat-notification-content {
    margin-left: 1.5rem;
    padding-top: 0.25rem;
  }
  .chat-notification-title {
    color: #1a202c;
    font-size: 1.25rem;
    line-height: 1.25;
  }
  .chat-notification-message {
    color: #718096;
    font-size: 1rem;
    line-height: 1.5;
  }
</style>
```

而這是Tailwind的寫法

**Using utility classes to build custom designs without writing CSS**

```html
<div class="p-6 max-w-sm mx-auto bg-white rounded-xl shadow-md flex items-center space-x-4">
  <div class="flex-shrink-0">
    <img class="h-12 w-12" src="/img/logo.svg" alt="ChitChat Logo">
  </div>
  <div>
    <div class="text-xl font-medium text-black">ChitChat</div>
    <p class="text-gray-500">You have a new message!</p>
  </div>
</div>
```



其實把下面那些class定義去掉，只看html裡面的部分，tailwind的寫法並沒有比較精簡，但即便如此還是能很明顯的看出tailwind的特色: utility-first

`chat-notification-content` 和 `text-xl font-medium text-black` 哪邊比較一目瞭然，似乎沒甚麼好比較的了

tailwind 捨棄了傳統把css包裝成一個又一個class的作法，反過來提倡看到甚麼就是什麼

