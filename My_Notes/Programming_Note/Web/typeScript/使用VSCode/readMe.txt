先安裝node.js
如編譯時找不到路徑重開機

tsconfig.jason生成
目錄下 CommandLine:tsc --init
生成後開啟
"sourceMap": true,
"strictNullChecks": true,

launch.jason生成
編譯彈出視窗直接確認即可
於"Program"下方加入
"preLaunchTask": "tsc: build - tsconfig.json",
"sourceMaps": true,
"smartStep": true,

Js檔生成
上述設定成功後直接DEBUG即可
或目錄下COMMANDLINE:tsc
or COMMANDLINE:tsc xxxxx.ts


如果看到 No inputs were found in config file
就在目錄底下隨便建立一個.ts檔案他就會閉嘴了