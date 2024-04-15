# Mega-linter

tags: #cross_language #lint #hooks #docker

https://github.com/nvuillam/mega-linter


## Abstract

無意間發現的工具卻意外令人驚豔。算是繼`cheat.sh`之後，挖到的一個寶。

下面算是把官方文件的內容簡化並且結合實際的使用經驗作紀錄


## Installation

[Reference](https://github.com/nvuillam/mega-linter#installation)

這邊紀錄的是assisted作法。手動的等以後有機會再來試試

開啟terminal，我是使用熟悉的powershell，切到專案目錄底下執行

```powershell
npx mega-linter-runner@beta --install
```

然後按照指示做可以了



### GitHub Actions

reference: [[Github actions]]

這邊拿一個將近半年前的side project做嘗試

```powershell
PS C:\Users\rockefel> cd D:\Rockefeller\Projects_Test\PicSearchChromeExtension
PS D:\Rockefeller\Projects_Test\PicSearchChromeExtension> npx mega-linter-runner@beta --install
npx: installed 447 in 73.578s
Yeoman generator used: C:\Users\rockefel\AppData\Roaming\npm-cache\_npx\15332\node_modules\mega-linter-runner\generators\mega-linter

     _-----_     ╭──────────────────────────╮
    |       |    │      Welcome to the      │
    |--(o)--|    │        Mega-Linter       │
   `---------´   │  configuration generator │
    ( _´U`_ )    │             !            │
    /___A___\   /│   When you don't know,   │
     |  ~  |     │    please use default    │
   __'.___.'__   │          values          │
 ´   `  |° ´ Y ` ╰──────────────────────────╯

? What is your project type ? Let Mega-Linter suggest me later (recommended)
? What CI/CD system do you use ? GitHub Actions
? Do you want to detect abusive copy-pastes ? Yes
? Do you want to detect spelling mistakes ? Yes
? Which Mega-Linter version do you want to use ? V4 (Latest stable version)
? What is the name of your repository default branch ? main
? Do you want Mega-Linter to validate all source code or only updated one ? Validate all sources
? Do you want to automatically apply formatting and auto-fixes (--fix option of linters) ? Yes
? Do you want Mega-Linter to upload reports on file.io ? (report is deleted after being downloaded once) Yes
? Do you want to see elapsed time by linter in logs ? Yes
   create .github\workflows\mega-linter.yml
   create .mega-linter.yml
   create .cspell.json
   create .jscpd.json

No change to package.json was detected. No package manager install will be executed.
You're all set !
Now commit, push and create a pull request to see Mega-Linter catching errors !
```

執行完畢後發現專案裡面多了四個檔案

![](https://i.imgur.com/E3h9Bls.png)

不對他們進行編輯直接切一個branch出來把他們commit出去接著push

創建一個pull request，接著等一段時間



![](https://i.imgur.com/sBEBO6s.png)

![](https://i.imgur.com/cYPapo3.png)



接著可以在github上瀏覽待改善項目，也可以下載下來

---

題外話

事實證明這個專案不適合開spell check，裡面有太多網站名稱了

copy paste 的部分當初寫的時候就有注意到了，但是chrome extension在popup和event是真的做不到共用資源

另外還有jquery語法報錯，chrome套件報錯等等

剩下的才是真正需要修改的(主要集中在違反命名慣例)

---


gitlab等其他平台的做法看起來差不多，以後有機會用到再來補充


### mega-linter runner

https://nvuillam.github.io/mega-linter/mega-linter-runner/

不用push的使用方法


先安裝node.js 和 docker


然後安裝npm套件

**Global installation**

```shell
npm install mega-linter-runner -g
```

**Local installation**

```shell
npm install mega-linter-runner --save-dev
```



```powershell
PS D:\Rockefeller\Projects\mcom> npm install mega-linter-runner -g
npm WARN deprecated request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
npm WARN deprecated har-validator@5.1.5: this library is no longer supported
npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
C:\Users\rockefel\AppData\Roaming\npm\mega-linter-runner -> C:\Users\rockefel\AppData\Roaming\npm\node_modules\mega-linter-runner\lib\index.js      
C:\Users\rockefel\AppData\Roaming\npm\mega-linter -> C:\Users\rockefel\AppData\Roaming\npm\node_modules\mega-linter-runner\lib\index.js
+ mega-linter-runner@4.46.0
added 447 packages from 314 contributors in 29.517s
```


接著沒意外應該就可以使用了(vscode裡面的terminal會無法辨識指令，原因不明)

```powershell
c:\>mega-linter-runner -h
mega-linter [options]

  -r, --release String     Mega-Linter version - default: v4
  -f, --flavor String      Mega-Linter flavor - default: all
  -d, --image String       Mega-Linter docker image
  -p, --path path::String  Directory containing the files to lint (default: current directory) - default: .
  -e, --env [String]       Environment variable (multiple)
  --fix                    Apply formatters and fixes in linted sources
  -j, --json               Outputs results as JSON string
  -n, --nodockerpull       Do not pull docker image before running it
  --debug                  See debug logs
  -h, --help               Show help (mega-linter --help OPTIONNAME to see option detail)
  -v, --version            Show version
  -i, --install            Generate Mega-Linter configuration in your project
```


#### Docker Connect Error

```powershell
PS D:\Rockefeller\Projects\mcom> mega-linter-runner.cmd --fix
Pulling docker image nvuillam/mega-linter:v4 ...
INFO: this operation can be long during the first use of mega-linter-runner
The next runs, it will be immediate (thanks to docker cache !)
error during connect: In the default daemon configuration on Windows, the docker client must be run with elevated privileges to connect.: Post http://%2F%2F.%2Fpipe%2Fdocker_engine/v1.24/images/create?fromImage=nvuillam%2Fmega-linter&tag=v4: open //./pipe/docker_engine: The system cannot find the file specified.
```

