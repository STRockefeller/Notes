# Online IDEs

這邊整理一些好用的線上IDE



## 類VSCode

### vscode.dev

[vscode.dev](https://vscode.dev)

[特色說明](https://code.visualstudio.com/blogs/2021/10/20/vscode-dev)

微軟自家的線上版vscode

可以直接開啟local files

可以連到 azure 或 github 開啟遠端 repo (可編輯，需要授權)

可以裝extension，但實測發現目前超過一半的extension不支援網頁版

可以使用liveshare



實測找定義/實作/參考的功能僅限於同專案，不確定是因為網頁版的關係還是extension有缺漏的關係。



假如我有一個 github repo : https://github.com/github_user/repo_name

則我可以透過 https://vscode.dev/github/github_user/repo_name 來開啟



### github.dev

基本上和vscode.dev很接近，多支援了一些github相關的功能，使用上只要把 github repo 網址中的 github.com 改成 github.dev 就可以了

extesion的支援程度和vscode.dev差不多，目前有待加強。



### github1s

把 github repo 網址中的 github.com 改成 github1s.com 可以用類似 vscode 的樣式查看，無法編輯。

只是想查看的時候比較方便，不需要登入github





## 綜合

### CS50 IDE

https://ide.cs50.io/

老實說我不太確定這東西拿來做線上IDE是否合適。

原本就是為了配合課程使用的工具，用來練習自然是綽綽有餘。

但是裡面的一些lib用習慣了換到其他開發環境反而會覺得不適應...

Console 指令好像也不是很完整



### CodeAnyWhere

https://codeanywhere.com/

可以直些把Code同步到雲端硬碟或git平台

支援的程式語言種類超過70種



版本比較功能要付費版才比較完整





### StackBlitz

https://stackblitz.com/

支援的項目

![](https://i.imgur.com/4ZeRrJS.png)

介面是類似vscode的介面



特色是在這邊寫的東西會自動部屬到他們的伺服器上，但速度世界慢

可以連接github repo

支援 hot-reloaded

支援 npm



### AWS Cloud9

https://aws.amazon.com/tw/cloud9/

要綁AWS使用，功能算是很齊全。

特色是影片式回放功能。



### Codeready-workspaces

https://developers.redhat.com/products/codeready-workspaces/overview

原CodeEnvy 現在是 redhat 的產品之一，特色是使用docker container



### Gitpod

https://www.gitpod.io/

綁gitlab/github/bitbucket 帳號

特色是自動跑ci/cd



### Coder

https://coder.com/

特色是在docker container下運作



## Front-Ended

### JSFiddle

https://jsfiddle.net/

顧名思義前端專用的編輯器

據說能夠共同編輯(目前沒試過)

不支援git



### CodeSandBox

https://codesandbox.io/

也是前端編輯器，功能相當完善

支援npm Typescript hot-reloaded github相關功能等等

付費版才提供 private code 支援



### PlayCode

https://playcode.io/

還不錯用，但是行數過多會一直跳訂閱廣告，適合拿來做題目