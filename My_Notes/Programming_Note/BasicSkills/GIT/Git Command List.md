# Command List

tags: #git

From [ITHELP](https://ithelp.ithome.com.tw/articles/10241407)

## Git 指令表

### config

|                     Git                      | zsh  |     do     | Remark |
| :------------------------------------------: | :--: | :--------: | :----: |
|             `git config --list`              |      |  查看設定  |        |
| `git config --local user.name "(userName)"`  |      |  設定帳號  |        |
|  `git config --local user.email "(e-mail)"`  |      | 設定E-mail |  全域  |
| `git config --global user.name "(userName)"` |      |  設定帳號  | 單專案 |
| `git config --global user.email "(e-mail)"`  |      | 設定E-mail | 單專案 |

### init / clone

|      Git      | zsh  |        do        | Remark |
| :-----------: | :--: | :--------------: | :----: |
|  `git clone`  |      | 抓遠端儲存庫下來 |        |
|  `git init`   |      |    Git 初始化    |        |
| `rm -rf .git` |      |     移除 Git     |        |

### remote

|                    Git                    | zsh  |        do         | Remark |
| :---------------------------------------: | :--: | :---------------: | :----: |
|   `git remote add (origin) (git@~.git)`   |      |     遠端連結      |        |
| `git remote set-url (origin) (git@~.git)` |  -   |   修改遠端連結    |        |
|       `git remote remove (origin)`        |  -   |   移除遠端連結    |        |
|              `git remote -v`              |      | 查詢遠端連結(URL) |        |
|      `git push -u (origin) (master)`      |      |  推上遠端並綁定   |        |

### 基本版更（ pull / push / add / commit / status）

|                  Git                  |     zsh     |      do      | Remark |
| :-----------------------------------: | :---------: | :----------: | :----: |
|             `git status`              |     gst     |              |        |
|           `git add (file)`            |   ga (~)    |              |        |
|              `git add .`              |    ga .     |              |        |
|       `git commit -m'message'`        | gcmsg '(~)' |              |        |
|              `git pull`               |     gl      |              |        |
|     `git push (remote) (branch)`      | gp (~) (~)  |              |        |
|    `git push -u (remote) (branch)`    |             |              |        |
|     `git restore --staged (file)`     |             | 取消 git add |        |
| `git pull --rebase (remote) (branch)` |     gl      |              |        |

### 檔案變更版更操作

|          Git          | zsh  |           do           |             Remark              |
| :-------------------: | :--: | :--------------------: | :-----------------------------: |
|    `git clean -fd`    |  -   | 清除未被追蹤的所有檔案 |  已編輯的會恢復,新增的不會變動  |
| `git checkout (file)` |  -   |  當前目錄回復前次存檔  | (已編輯的會恢復,新增的不會變動) |
| `git restore (file)`  |  -   |  當前目錄回復前次存檔  |         (含被刪除的檔)          |

### Branch 分支應用

|                 Git                 | zsh  |           do           |       Remark       |
| :---------------------------------: | :--: | :--------------------: | :----------------: |
|            `git branch`             |  -   |    查詢所有本地分支    |                    |
|           `git branch -a`           |  -   |    查詢所有遠端分支    |                    |
|      `git branch (newBranch)`       |  -   |  當前 commit 新建分支  |                    |
| `git branch (newBranch) (commitID)` |  -   | 特定 commit 上新建分支 |                    |
|       `git checkout (branch)`       |  -   |      切換到某分支      |                    |
|    `git checkout -b (newBranch)`    |  -   |   新建分支並切換過去   |                    |
|      `git branch -d (branch)`       |  -   |       刪除某分支       |                    |
|      `git branch -D (branch)`       |  -   |     強制刪除某分支     |                    |
| `git branch -m (branch) (newName)`  |  -   |    將某 branch 更名    | 必須先切到不同分支 |

------

## Reset 切到某版本

|             Git              | zsh  |        do         |       Remark       |
| :--------------------------: | :--: | :---------------: | :----------------: |
|     `git reset (commit)`     |      |                   |   預設為'mixed'    |
| `git reset (commit) --mixed` |      |                   |  放回"1-工作目錄"  |
| `git reset (commit) --soft`  |      |                   |   放回"2-暫存區"   |
| `git reset (commit) --hard`  |      |                   | 都不留(直接被隱藏) |
|    `git reset (commit)^`     |      | 退回前1次的commit |   ^^ 退回前2版…    |
|    `git reset (commit)~5`    |      | 退回前5次的commit |    ~N 退至前N版    |

- (commit)可以是 branch / commit ID / HEAD

------

## Rebase & Merge 合併應用

|          Git          | zsh  |       do       | Remark |
| :-------------------: | :--: | :------------: | :----: |
| `git rebase (branch)` |      |  重接分支基底  |        |
| `git merge (branch)`  |      | 合併分支(平行) |        |

------

## 查詢

|                Git                | zsh  |           do           |    Remark     |
| :-------------------------------: | :--: | :--------------------: | :-----------: |
|        `git config --list`        |      |      查詢目前設定      |               |
|            `which git`            |      |     查詢 Git 位置      |               |
|          `git --version`          |      |      查詢Git版本       |               |
|           `git status`            |      |        查詢狀態        |               |
|             `git log`             |      |        查詢 Log        |               |
|        `git log --oneline`        |      |   查詢 Log(單行顯示)   |               |
| `git log --oneline --all --graph` |      |      樹狀顯示 Log      |               |
|       `git log -p FileName`       |      |      查詢檔案 Log      |               |
|       `git blame FileName`        |      | 查詢該檔案每行編輯資訊 | (上傳者&時間) |
|           `git reflog`            |      |      查詢 reflog       |               |
|            `git help`             |      |        查詢指令        |               |

- reflog：reflog　保留HEAD移動的軌跡，可以查詢到commit ID(用於尋找被隱藏的　commit　)