# LangDiDa

## 20221026

先從規劃開始

期從很久之前就一直有計畫做這東西，但考慮到各種麻煩就遲遲沒有動工

以下是當初紀錄的內容。

### 外語學習工具(規劃)

目標是取代lingQ，讓我每個月能省300NTD。(如果可以把lingQ現有的單字匯入就更好了)

以自己使用為主，但是依然希望可以盡可能的跨設備使用。

PC端的設備要能從文章中抓取並記錄單字。Android端的設備至少支援單字複習。

先以英文為主，但保留可以擴充的可能性。

儲存的資料分為三大類:單字、片語、句型。在儲存階段手動選擇。

自動查詢網路字典的功能。

設定複習頻率的功能

### 大方向

目前個人閱讀到外文文章的地方大多都在網頁上。所以做成Chrome Extension應該是滿方便的。並且過去也有開發過的經驗。大致上列一下優缺點和打算做的事情:

* +有開發Chrome Extension的經驗。

* +右鍵選單+彈出式視窗簡單好操作。

* -鎖右鍵或其他不給獲取內容的網站不好處理(不過這點應該用甚麼做法都難以處理)。

* -網頁以外的地方不能使用。

另外就是Local端的應用程式，目前有想到的就是在背景偵測clipboard，把純字串(長度會限制不能太長)的部分先暫存起來(有點類似免空下載器那種感覺)，開啟應用程式再來建立單字:

* +可以用在網頁以外的地方。

* +閱讀文章時可以不用中斷去建立單字，只要邊看邊<kbd>Ctrl</kbd>+<kbd>C</kbd>，告一段落之後再去建立單字就行了。

* -新設備需要下載甚至安裝應用程式才能使用，不如Chrome Extension方便。

(其實我寫到這邊才想到，似乎也可以選擇兩種都做。不過這樣好累，還是先挑其中一種來做就好了。)

### 資料庫選用

目前仍希望以sql db為主，暫時打算先找線上的免費server來用，反正存的都是些單字啥的沒什麼機密的東西。

---

老實說目前仍不肯定哪種作法更好，(或者其實都做更好?)，總之再想下去也不會有甚麼進展，不如直接動手。

姑且先選用local端應用來做，使用起來雖然會比較麻煩，但勝在可以玩出的花樣多?

db選擇上首先要能夠跨設備使用，理論上還是關聯資料庫最為理想，但是找server真的麻煩，姑且先以支援google sheets(最優先，但算是應急手段)，以及常用sql資料庫為目標吧。這部分先抽象處理方便擴充。

再來是開發語言的選擇，其實決定做local端之後大概就剩兩個選擇了C#和GO二選一，雖然我是很想選擇用go來做，它夠單純夠輕量可以很簡單的跨平台，並且我近期對它的熟悉度很高。但可惜的是我想要有UI，但Golang不擅長這個。反之C#可以包辦從UI到對資料庫的所有行為。

其實用golang寫純後端，然後畫面另外寫也不失為一種選擇，但這麼做就讓人很想重複利用它，想寫成api server給手機和網頁使用，然後就回到老問題，我需要租個server...

好吧，先選擇用最麻煩的做法，寫純後端程式。姑且先為這個連一行程式都還沒有的項目抱有最高期待，希望寫完之後我會想為它租個server

---

## 20221027

### Server 規劃

先從後端server開始，選用golang+gin+go-redis+gorm套件。另外還要找個google sheets api來用。

gorm套件沒支援泛型有點難用，我先新重把它包裝一次好了。

搞定，寫在 [GitHub - STRockefeller/generic-gorm: gorm package with generic types](https://github.com/STRockefeller/generic-gorm)

理論上我會希望不要呼叫到原生的gorm，如果有需要就盡量在這個package處理。

接著開設計server吧~

稍微考慮過把它寫成windows service，不過不能保證將來架設的環境一定是windows，所以還是先不這麼做。

這個server預計要能做到的事情:

* 透過設定檔決定資料存到甚麼地方(db,cache,google sheets...)

* 提供restful api以及swagger文件給呼叫端

* 資料的讀寫

* 共用度高的邏輯

* (優先度低)轉檔(ex: google sheets -> db)

* (優先度低)匯出及匯入(excel,csv,anki...)

* (優先度低)graceful shutdown

### configs

一步步來，先從設定檔開始

大概是

```yaml
server port: 1234

storage type: db # 選擇用哪種方式來讀寫資料

db:
    name: dbName
    address: ooo.xxx.ooxx
    port: 1234
    username: user
    password: pw
    schema: sch # 不確定是不是要放在設定檔

redis:
    host: ooo.xxx.ooxx

google sheets:
    credential: ooxx
```

好吧，很多東西沒摸過，實際上需要甚麼有點難猜測，決定先跳過這一塊等回頭再來寫了。

### server

```go
package server

import (
 "strconv"

 "github.com/gin-gonic/gin"
)

func Run(port int) {
 router := gin.Default()
 router.Run(":" + strconv.Itoa(port))
}

```

先這樣，實際上還需要其他參數，例如儲存方式的介面等等。這些晚點再補充

### model

先來決定最重要的地方，我希望這個系統可以區分單字、片語以及句型。而不是像LingQ那樣全部混在一起。
那麼問題來了，我要把他們存在一起(例如同一個table)好呢?
還是分開存比較好呢?

首先先來分析一下，對於每個項目我分別想要存什麼資訊，以及他們都必須要有的資訊。

共用:

* 什麼語言: 英文/日文/法文...，作為 PK 之一
* tags: string array，用來存一些額外資訊例如:動詞、名詞、陰性、陽性、五段動詞、過去分詞、肯定句、疑問句、重音、漢字、假名...等等。
* 例句
* 熟悉度
* 應複習日
* 關聯項目: 原型、變體、同義詞、反義詞、其他關連單字、關聯句型、跨語言關聯等等。

單字(ex: bonjour)

* 單字本身: 作為PK之一

片語(ex: count on)

* 片語本身: 作為PK之一(需要完善的查詢機制以確保不會重複存類似的項目)

句型(ex: ～てたまらない)

* 句型本身: 作為PK之一(需要完善的查詢機制以確保不會重複存類似的項目)

仔細分析下來，發現其實大多數的東西都可以共用，那就先存在一起好了。

考慮到我的model會被很多不同平台的不同程式用到，用protobuf message來定義它或許是個好主意。
本來想把它寫在另一個repo，丟到github上面，再一起引用。但是有些語言沒辦法直接參考github repo，像是C#就必須發布到nuget上。所以這麼做其實也沒有很方便。
先暫時用比較笨的方法，把message全部都定義在server專案。其他專案就直接copy paste再生成程式碼好了。

接著有兩個挑戰:語言辨識以及關聯項目

#### 語言辨識

這個項目是什麼語言，會關係到查字典的功能，但是如果每次都要輸入語言又有點麻煩，稍微查了一下用程式辨別的可能性。找到了[lingua](https://github.com/pemistahl/lingua-go)這個套件，不過上面寫說不擅長辨別短語，我這個以單字為主的項目更別說了。
仔細想想單就英文和法文，就有很多單字長的一樣。單憑單字辨別語言實在不太現實。
先放棄這塊，讓呼叫端自己輸入好了。

#### 關聯項目

如果不扯上資料儲存的話我會考慮用指標來關聯，不過實際情形明顯不適合這麼做，姑且就存PK吧。

#### card

暫定的樣子

```protobuf
syntax = "proto3";

package models;

import "google/protobuf/timestamp.proto";

message Card{
    CardIndex index = 1;
    repeated string labels = 2;
    repeated string example_sentence = 3;
    int32 familiarity = 4;
    google.protobuf.Timestamp review_date = 5;
}

message RelatedCards{
    repeated CardIndex synonyms = 1;
    repeated CardIndex antonyms = 2;
    CardIndex origin = 3;
    repeated CardIndex derivatives = 4;
    repeated CardIndex in_other_languages = 5;
    repeated CardIndex others = 6;
}

message CardIndex{
    string name = 1;
    Language language = 2;
}

enum Language{
    ENGLISH = 0;
    JAPANESE = 1;
    FRENCH = 2;
}
```

我現在有一股衝動想讓pk以外的部分都序列化後再儲存
以db來說，card就會像

| name   | language | data                     |
|--------|----------|--------------------------|
|  hello | 0        | fdjepofiowqjgJAISWODFJWe |

冷靜下來仔細一想其他然位也不是沒有作為查詢條件的機會，例如複習日，這麼做還是不太好。

---

## 20221028

### model-2

繼續完成model的部分。

題外話。我感覺nosql似乎不太適合這個專案，比起google sheets還要更不適合。到時候實作的時候先不考慮nosql好了。

我需要有一個model紀錄使用者的資訊。類似於lingq中會記錄每天、每周的學習單字量。還有設定學習目標等等的功能。目前不打算支援多人使用(身分認證)。所以只要存一份資訊即可。

```protobuf
syntax = "proto3";

package protomodels;

import "google/protobuf/timestamp.proto";

message Log{
    google.protobuf.Timestamp date = 1;
    int32 review_words = 2;
    int32 new_words    = 3;
    int32 streak = 4;
    bool streak_updated = 5;
}
```

```protobuf
syntax = "proto3";

package protomodels;

message UserSettings{
    int32 daily_goal = 1;
}
```

`review_words` `new_words` `daily_goal` 都不分語言，先寫的簡單點，而且我覺得憑當天的興致決定要學什麼感覺比較自由。
`streak` 指得是連續目標達成天數。想不到比較合適的命名，所以就拿lingq的先來用。
暫且先這樣。想到再補。

後悔了，每日目標感覺沒有必要存，改成使用設定檔來決定好了。`UserSettings` model 就可以刪除掉了。

### storage

```go
type Storage interface {
 ListCards(ctx context.Context, cardIndex []protomodels.CardIndex) ([]protomodels.Card, error)
 // upsert to logs NewCards++
 CreateCard(ctx context.Context, card protomodels.Card) error
 // zero values will NOT been updated
 UpdateCard(ctx context.Context, card protomodels.Card) error
 DeleteCard(ctx context.Context, cardIndex protomodels.CardIndex) error

 GetLog(ctx context.Context, date time.Time) (protomodels.Log, error)
 ListLogs(ctx context.Context, from time.Time, until time.Time) ([]protomodels.Log, error)

 // upsert to logs ReviewedCards++
 // update card review date
 ReviewCard(ctx context.Context, cardIndex protomodels.CardIndex) error
}
```

學習新的卡片被我歸類到`CreateCard`裡面了，複習則是獨立出來(因為它不一定會更新到卡片內容)。
`Log`沒有建立方法，應為預計會在`CreateCard`以及`ReviewCard`做upsert
註解是寫給我自己看得，提醒我這個方法應該做到甚麼事情。

## 20221031

今天參考了一些架構設計的文章，決定用這個架構來試試。
![img](https://i.imgur.com/oItfIfB.png)

## 20221101

### 修改架構

延續昨天的進度，先修改一下專案結構

```powershell
PS D:\OOO\XXX\langdida-server> TREE . /F
D:\OOO\XXX\LANGDIDA-SERVER
│  .gitignore
│  go.mod
│  go.sum
│  LICENSE
│  main.go
│  README.md
│
├─assets
├─delivery
│  └─ginserver
│          server.go
│
├─models
│  └─protomodels
│          card.pb.go
│          card.proto
│          log.pb.go
│          log.proto
│          protogen.go
│
├─service
│      service.go
│
└─storage
        storage.go
```

其中storage就代表repository層級。

接著再從業務邏輯的角度，幫我的功能分個類。

1. primary domain : 單字的建立以及複習
2. sub domain : 學習歷程追蹤記錄
3. sub domain: 問題集生成

然後來設計service (use cases)

#### CardService

首先是`CardService`，我需要的功能有:

* 取的項目的內容(確認是否存在)
* 學習新單字/片語/句型
* 編輯項目(新增例句、修改label、熟練度、應複習日等等)
* 關聯項目(包含如果項目不存在時，自動建立卡片的邏輯)
* 查詢應複習項目
* 以label查詢項目
* 以語言查詢項目
* 查字典功能(這個部分我還沒什麼具體的想法)

```go
type CardService interface {
 GetCard(ctx context.Context, condition protomodels.CardIndex) (protomodels.Card, error)
 CreateCard(ctx context.Context, card protomodels.Card) error
 EditCard(ctx context.Context, card protomodels.Card) error
 ListCardsShouldBeReviewed(ctx context.Context) ([]protomodels.Card, error)
 ListCardsByLabelsAndLanguage(ctx context.Context, labels []string, language protomodels.Language) ([]protomodels.Card, error)

 // return url
 SearchWithDictionary(ctx context.Context, cardIndex protomodels.CardIndex) (string, error)
}
```

稍微做了點調整，關聯項目的部分感覺比較像是技術細節，並且預計應該不會獨立使用，所以把它合併到編輯功能去了。

#### LogService

接著是`LogService`，我需要的功能有:

* 列出學習狀態，包含各個熟練程度的項目數量，連續達成目標的日數等等。
* ~~更新log(分為手動和自動觸發)~~(改在項目更動時更新)

```go
type LogService interface {
 GetLogStatus(ctx context.Context) (LogStatus, error)
}
```

#### ExerciseService

```go
type ExerciseService interface {
 CreateChoiceProblems(ctx context.Context, cards protomodels.CardIndex) (problems []string, answers []string, err error)
 CreateFillingProblems(ctx context.Context, cards protomodels.CardIndex) (problems []string, answers []string, err error)
}
```

選擇題跟填空題，命名暫定，晚點再去查正確的寫法。

#### IOService

用於import&export，目前暫時沒有想到內容，留待以後再補充

### 修改card model

現在才發現當初設計的model中，連解釋說明的欄位都沒有= =。
趕緊來補上...
