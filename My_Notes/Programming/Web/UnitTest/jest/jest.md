# jest

## Abstract

雖然說是筆記，但主要用於紀錄些踩過的坑(包含有些還沒爬出來的orz)。

## 疑難雜症

### jest.mock 要一次重寫全部內容

不能只抽換其中一個方法，其他沒重寫的也都會變成`undefined`

### 只要呼叫 jest.unmock 不論順序為何，mock都會失效

目前還沒找到解法

例如

```typescript
import { sample } from 'sampleModule'

jest.mock('sampleModule');

describe('',()=>{
    (sample as jest.Mock).mockReturnValue("mock value");
    test('',()=>{
          expect(sample()).toBe("mock value");
    });
});
```

假設如上做法是可行的，則

```typescript
import { sample } from 'sampleModule'

jest.mock('sampleModule');

describe('',()=>{
    (sample as jest.Mock).mockReturnValue("mock value");
    test('',()=>{
          expect(sample()).toBe("mock value");
    });
});


jest.unmock('sampleModule');
```

則會測試失敗，`sample()`方法也會執行未抽換的版本。

目前仍不確定原因為何，即使寫在teardown(`afterEach` 或者 `afterAll`)裡面也是一樣的情況

### jest.mock 抽換需要在最外層執行。

單就 `jest.mock()` 方法而言，只有在最外層執行才起作用，寫在`beforeEach` `beforeAll` 或者直接寫在describe裡面都不起作用。目前仍不知原因為何。

### expect 在 then 或 catch 中執行失敗並不會被算成測試未通過。

這應該算bug?

情況就是debug console 裡面會顯示 

```bash
Expected: OOO
Received: XXX
```

但是測試依然通過了

雖然說describe本來就不支援非同步執行測試了，用 then catch 感覺確實有點偷吃步，所以有Bug也正常...嗎?

### vue-jest 在.vue檔案中的 breakpoint 於 debug 時位置會偏移。

目前觀察下來，debug階段時，我的source code會發生變化，多了一些原本沒有的內容，導致中斷點的位置無法指到我想要的地方。

[Break points not working / pointing to wrong line numbers in Vue.js?](https://www.nightprogrammer.com/vue-js/break-points-not-working-pointing-to-wrong-line-numbers-vue-js/)

試著照這篇文章加入source map type 的設定，但情況依然沒有改善。

目前只能先用不得已的作法，先跑一次debug，查看被修改後的 source code ，找到想要中斷的位置，並在該處下中斷點。

## Property 'XXX' does not exist on type ...

搞定jest之後，雖然測試可以通過，但vue反而會run失敗。

![img](https://i.imgur.com/o47nXFo.png)

在[這篇文章](https://github.com/kulshekhar/ts-jest/issues/2834)中找到解決辦法。

簡單的做法就是把wrapper.vm轉成any讓型別確認可以通過

例如原本是

```typescript
wrapper.vm.xxx
```

改成

```typescript
(wrapper.vm as any).xxx
```