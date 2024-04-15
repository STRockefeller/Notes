# Github Actions

tags: #git #github #cicd #hooks 

Reference :

* <https://medium.com/starbugs/%E5%AF%A6%E4%BD%9C%E9%96%8B%E6%BA%90%E5%B0%8F%E5%B7%A5%E5%85%B7-%E8%88%87-github-actions-%E7%9A%84%E7%AC%AC%E4%B8%80%E6%AC%A1%E7%9B%B8%E9%81%87-3dd2d70eeb>

gitlab 也有類似的功能[[Gitlab-ci]]

## Billing

注意，free plan 用戶在**私有** repo 每個月只有 2000 min 的執行時間(linux)，windows兩倍 apple十倍計價，公有repo則無限制

![image](https://i.imgur.com/SscV1YU.png)

## Practice

正好有個想法要用到github action，就一邊實作一邊紀錄下來好了。

想法是這樣的，我用githib創個repo專門跑action，頻率設置成每天觸發一次，執行某個npx script (可能需要用到docker)。

建立了一個 private repo 並使用官方提供的action template如下

```yaml
# This is a basic workflow to help you get started with Actions

name: CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the "main" branch
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v3

      # Runs a single command using the runners shell
      - name: Run a one-line script
        run: echo Hello, world!

      # Runs a set of commands using the runners shell
      - name: Run a multi-line script
        run: |
          echo Add other actions to build,
          echo test, and deploy your project.
```

根據[Events that trigger workflows - GitHub Docs](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)可以找到我需要的是schedule功能。

一天兩次，分別在0530和1730 UTC

```yaml
on:
  schedule:
    # * is a special character in YAML so you have to quote this string
    - cron:  '30 5,17 * * *'
```

為了可以手動測試，再加上`workflow_dispatch`

> To manually trigger a workflow, use the `workflow_dispatch` event. You can manually trigger a workflow run using the GitHub API, GitHub CLI, or GitHub browser interface. For more information, see "[Manually running a workflow](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow)."

因為是private repo，action有時間限制，所以runner就先用linux系統，維持原設定不變。

查找了一番之後發現，可以不用docker，直接在github action上執行npm script

[GitHub Action for npx · Actions · GitHub Marketplace · GitHub](https://github.com/marketplace/actions/github-action-for-npx)

到現在為止修改後如下，測試過也能正確執行

```yaml
# This is a basic workflow to help you get started with Actions

name: BahamutAutomation

# Controls when the workflow will run
on:
  schedule:
    # * is a special character in YAML so you have to quote this string
    - cron:  '30 5,17 * * *'

  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v3
      - uses: mikeal/npx@1.0.0

      # Runs a single command using the runners shell
      - name: do automation
        run: npx bahamut-automation --help
```

最後，因為我需要在設定檔裡面放一些機密資料。雖然是private repo，不過還是放在secret裡面比較安心。

但是，設定檔又不能直接使用secret。所以我繞了個彎，在執行action時才用程式生成設定檔。並透過flag把機密參數從secret傳進去。



secret的設置，就點點UI就完成了。程式的部分也很單純就不多提了。



使用起來像是

```yaml
      - name: generate config
        run: go run . -account ${{ secrets.B_ACCOUNT }} -password ${{ secrets.B_PASSWORD }}
```

執行的時候還會幫打碼，超貼心

![](https://i.imgur.com/oxVc9dk.png)

## Checkout

有踩過坑，所以特別記一下

預設的yaml中有這段

```yaml
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v3
```

對，就像上面說的，沒設定這個的話路徑會指不到repo中的檔案或資料夾。

假如沒設定這個，並且用下面這段去測試

```yaml
      - name: see env dir
        run: echo $env.GITHUB_WORKSPACE
```

就會拿到![](https://i.imgur.com/pS3lfnQ.png)
