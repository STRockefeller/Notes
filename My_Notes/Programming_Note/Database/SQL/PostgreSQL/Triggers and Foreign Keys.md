# Triggers & Foreign Keys

#database/sql/postgresql

References:

* [PostgreSQL sequence based on another column](https://stackoverflow.com/questions/6821871/postgresql-sequence-based-on-another-column)
* [PostgreSQL Foreign Key](https://www.postgresqltutorial.com/postgresql-foreign-key/)
* [Gorm override foreign key](https://gorm.io/docs/belongs_to.html#Override-Foreign-Key)
* [Gorm Override References](https://gorm.io/docs/belongs_to.html#Override-References)

## Abstract

結合PostgreSQL和Gorm package 達成根據另一個Column進行sequences排序的功能

## About Foreign Key

### Introduce

簡單來說就是建立兩個資料表中欄位的關聯。

像是[使用手冊](https://docs.postgresql.tw/tutorial/advanced-features/foreign-keys)中的範例

```SQL
CREATE TABLE cities (
        city     varchar(80) primary key,
        location point
);

CREATE TABLE weather (
        city      varchar(80) references cities(city),
        temp_lo   int,
        temp_hi   int,
        prcp      real,
        date      date
);
```

值得一提的是，這種關聯行為是有上下關係的，以上例來說

參考方是 `weather.city` 被參考方是 `cities.city`

此時資料庫就會限制參考方在新增資料時被參考方必須要有對應的資料在被參考的欄位

例如，我今天想要新增一筆weather資料內容是彰化的天氣，那麼此時`cities.city`必須先有一筆資料的城市名稱為彰化，我才可以順利新增。

另外還有一點要注意的是刪除被參考方資料的時候，若該筆資料正在被其他資料表參考中，則不被允許刪除

### Gorm Models

使用golang的gorm package新增 foreign key reference

不確定原因為何，但我使用官方([Gorm override foreign key](https://gorm.io/docs/belongs_to.html#Override-Foreign-Key)或[Gorm Override References](https://gorm.io/docs/belongs_to.html#Override-References))提供的方式撰寫model，migrate到資料庫後，foreign key相關的內容並沒有被生成

```go
type ModelA struct {
    Id string `gorm:"type:varchar(2);primaryKey"`
}

type ModelB struct {
  ModelAID string `gorm:"type:varchar(2);foreignKey:ModelA;primaryKey"`
}
```

後來在stack overflow 找到另一個寫法行的通

```go
type ModelA struct {
    Id string `gorm:"type:varchar(2);primaryKey"`
}

type ModelB struct {
    ModelAID string `gorm:"type:varchar(2) REFERENCES model_a(id);primaryKey"`
}
```

其實就是類似SQL的寫法，值得注意的部分:

* type 和 REFERENCE 之間沒有 `;`，我也不確定加`;`會不會有影響，要再嘗試
* model的名稱是使用資料庫裏面的樣式，而不是struct的名稱
* 和postgreSQL的寫法相同，如果參考的目標是該表格的PK則`()`的Column名稱可以不寫，例如`gorm:"type:varchar(2) REFERENCES model_a;primaryKey"`
* 如果connection string 裡面沒有設定預設的schema name在參考目標處必須標明schema name否則會有[找不到參考的問題](#XXX does not exists)

## About Trigger

trigger 會綁訂於table，當條件達成時執行指定的動作。

值得注意的一點是，PostgreSQL v14 之前的trigger 不支援 OR REPLACE 關鍵字，如果要避免重複創建，只能先執行DROP IF EXISTS

V13

```sql
CREATE [ CONSTRAINT ] TRIGGER name { BEFORE | AFTER | INSTEAD OF } { event [ OR ... ] }
    ON table_name
    [ FROM referenced_table_name ]
    [ NOT DEFERRABLE | [ DEFERRABLE ] [ INITIALLY IMMEDIATE | INITIALLY DEFERRED ] ]
    [ REFERENCING { { OLD | NEW } TABLE [ AS ] transition_relation_name } [ ... ] ]
    [ FOR [ EACH ] { ROW | STATEMENT } ]
    [ WHEN ( condition ) ]
    EXECUTE { FUNCTION | PROCEDURE } function_name ( arguments )

where event can be one of:

    INSERT
    UPDATE [ OF column_name [, ... ] ]
    DELETE
    TRUNCATE
```

V14

```sql
CREATE [ OR REPLACE ] [ CONSTRAINT ] TRIGGER name { BEFORE | AFTER | INSTEAD OF } { event [ OR ... ] }
    ON table_name
    [ FROM referenced_table_name ]
    [ NOT DEFERRABLE | [ DEFERRABLE ] [ INITIALLY IMMEDIATE | INITIALLY DEFERRED ] ]
    [ REFERENCING { { OLD | NEW } TABLE [ AS ] transition_relation_name } [ ... ] ]
    [ FOR [ EACH ] { ROW | STATEMENT } ]
    [ WHEN ( condition ) ]
    EXECUTE { FUNCTION | PROCEDURE } function_name ( arguments )

where event can be one of:

    INSERT
    UPDATE [ OF column_name [, ... ] ]
    DELETE
    TRUNCATE
```

## Implementation

**釐清需求**

需求: 根據另一個column的值分別自動累加的serial number

```go
type MyModel struct{
    Label string
    // SerialNumber 要根據 Label 自動累加
    SerialNumber int
}
```

例如我做如下操作

1. 新增資料Apple
2. 新增資料Orange
3. 新增資料Apple
4. 新增資料Apple
5. 新增資料Banana

想要得到資料如下

| Label  | Serial Number |
| ------ | ------------- |
| Apple  | 1             |
| Orange | 1             |
| Apple  | 2             |
| Apple  | 3             |
| Banana | 1             |

---

**自動累加**

透過PostgreSQL的Sequence以及`nextval()`方法，可以做到自動累加的功能。

先不考慮不同Label要分開計算的條件，Sequence的使用大概像這樣

```sql
CREATE SEQUENCE my_model_sequence;
```

```sql
CREATE TABLE my_model(
    label text,
    serial_number integer nextval(my_model_sequence)
    CONSTRAINT "my_model_pkey" PRIMARY KEY ("label", "serial_number")
)
```

這時我同樣執行以下操作

1. 新增資料Apple
2. 新增資料Orange
3. 新增資料Apple
4. 新增資料Apple
5. 新增資料Banana

應該會得到資料如下

| Label  | Serial Number |
| ------ | ------------- |
| Apple  | 1             |
| Orange | 2             |
| Apple  | 3             |
| Apple  | 4             |
| Banana | 5             |

補充: CREATE SEQUENCE 完整參數

```sql
CREATE [ TEMPORARY | TEMP ] SEQUENCE [ IF NOT EXISTS ] name [ INCREMENT [ BY ] increment ]
    [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
    [ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
    [ OWNED BY { table_name.column_name | NONE } ]
```

---

**區分累加值**

針對需求中各個Label必須要有獨立的SerialNumber累加序列，有一個比較直觀的想法就是創建很多不同的Sequence分別進行累加，這樣每個Label的進度就可以區分開來了。

舉個例子，假如上例的結構長成這個樣子

```C#
public class MyModel
{
    public string label;
    public int serialNumber;
    public MyModel(string label)
    {
        this.label = label;
        serialNumber = MyModelSequence.NextValue();
    }
}
```

現在我們希望他變成像這樣

```C#
public class MyModel
{
    public string label;
    public int serialNumber;
    private ISequence sequence;
    public MyModel(string label)
    {
        this.label = label;
        getSequence();
        serialNumber = sequence.NextValue();
    }
    
    //根據 label 取得或創建 ISquence 實例參考，並且存入 sequence
    private void getSequence ()
    {
        //...
    }
}
```

那麼問題來了

* 不太可能透過PostgreSQL的欄位標籤，去執行這種複雜的邏輯。
* 對一個已經創建完畢的table頻繁更換其參考的Sequence對象也很不切實際。

---

**Trigger**

資料在創建時執行某個邏輯，很適合使用trigger來達成

邏輯如下:

1. 確認新資料的label是否存在對應的sequence，如果沒有就創建一個新的
2. 根據label從對應的sequence找資料填入serial_number

用function實現邏輯，大概像這樣

```sql
CREATE FUNCTION myschema.build_sequence() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  execute format('CREATE SEQUENCE IF NOT EXISTS %s', NEW.label);
  return NEW;
end
$$;
```

```sql
CREATE FUNCTION myschema.fill_in_serial_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  NEW.serial_number := nextval(NEW.label);
  RETURN NEW;
end
$$;
```

其中`$$`被稱為`Dollar-Quote`，簡單來說是用來界定邏輯的起始/結束位置，詳細參考[這裡](https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-DOLLAR-QUOTING)

註: sequence命名的部分要留意，像上方的寫法由於sequence的名稱會被轉換為lowercase所以有時不一定可以找到一對一對應的名稱，比較合適的做法還是把字串處理後再進行命名。這邊是方便示意。

邏輯有兩個所以需要兩個trigger (一個trigger 只能觸發一個function ， [參考](https://dba.stackexchange.com/questions/54199/call-multiple-functions-from-trigger))

trigger 條件就設定為資料創建時，大概像是這樣

```sql
CREATE TRIGGER my_trigger1 AFTER INSERT ON myschema.my_model FOR EACH ROW EXECUTE PROCEDURE myschema.build_sequence();
```

```sql
CREATE TRIGGER my_trigger2 AFTER INSERT ON myschema.my_model FOR EACH ROW EXECUTE PROCEDURE myschema.fill_in_serial_number();
```

到這裡目標就差不多實現了，再次執行前一回的操作時，動作會像這樣:

1. 新增資料Apple
   * trigger1 發現Apple沒有對應的sequence於是進行創建
   * trigger2 找到Apple對應的sequence並且取值放入serial_number
2. 新增資料Orange
   * trigger1 發現Orange沒有對應的sequence於是進行創建
   * trigger2 找到Orange對應的sequence並且取值放入serial_number
3. 新增資料Apple
   * trigger1 發現Apple有對應的sequence於是不進行創建
   * trigger2 找到Apple對應的sequence並且取值放入serial_number
4. 新增資料Apple
   * trigger1 發現Apple有對應的sequence於是不進行創建
   * trigger2 找到Apple對應的sequence並且取值放入serial_number
5. 新增資料Banana
   * trigger1 發現Banana沒有對應的sequence於是進行創建
   * trigger2 找到Banana對應的sequence並且取值放入serial_number

---

**優化**

仔細觀察可能會發現上述的作法中有一件事情每次都執行顯得有點冗餘，就是trigger1的`CREATE SEQUENCE IF NOT EXISTS`動作，可能很多時候新資料的label和舊有的一樣，但還是必須去確認是否有對應sequence，就顯得很多餘。

話雖這麼說，但是trigger的condition也沒辦法細緻到偵測這筆資料有新的label才觸發。

針對這種情形，有一個不是很直覺的作法。

希望trigger1可以有更加嚴苛的觸發條件，但是在my_model中行不通 => 創建另一個table關聯my_model，並且它只會在我們希望trigger被觸發的時候變化。

具體像是

新table

```sql
CREATE TABLE myschema.my_model_label (
    label text primary key
);
```

my_model 用新的table作為foreign key

```sql
CREATE TABLE myschema.my_model(
    label text references myschema.my_model_label,
    serial_number integer,
    CONSTRAINT "my_model_pkey" PRIMARY KEY ("label", "serial_number")
)
```

trigger1改成在新的table資料被創建時觸發

```sql
CREATE TRIGGER my_trigger1 AFTER INSERT ON myschema.my_model_label FOR EACH ROW EXECUTE PROCEDURE myschema.build_sequence();
```

trigger2維持不變

最後執行的詳細情形會像這樣:

1. 新增資料Apple
   * my_model_label 新增一筆資料 Apple，trigger1觸發並創建對應的sequence
   * trigger2 找到Apple對應的sequence並且取值放入serial_number
2. 新增資料Orange
   * my_model_label 新增一筆資料 Orange，trigger1觸發並創建對應的sequence
   * trigger2 找到Orange對應的sequence並且取值放入serial_number
3. 新增資料Apple
   * my_model沒有資料創建(因為PK已存在)，trigger1沒有被觸發
   * trigger2 找到Apple對應的sequence並且取值放入serial_number
4. 新增資料Apple
   * my_model沒有資料創建(因為PK已存在)，trigger1沒有被觸發
   * trigger2 找到Apple對應的sequence並且取值放入serial_number
5. 新增資料Banana
   * my_model_label 新增一筆資料 Banana，trigger1觸發並創建對應的sequence
   * trigger2 找到Banana對應的sequence並且取值放入serial_number

### Troubles

#### XXX does not exists

透過gorm套件生成 table/function/trigger 等內容時，當內容包含對其他物件的參考時，可能會發生找不到參考目標的問題，這時可以留意兩個面向

1. 生成順序: 被參考目標必須先生成
2. schema name: 若connection string沒有包含schema name，則sql指令中必須包含目標的schema name否則無法正確找到參考目標

#### tuple concurrently updated

另外還有一個PK衝突的錯誤，因為發生的情景很接近所以一起講。

原本會設計讓資料庫而不是後端程式進行流水號的累加最主要的目的是想避免同時在多個設備進行資料新增時可能造成因為PK衝突而新增失敗的情形

但是採用這種寫法後，以golang的concurrent function做測試，發現goroutine當數量超過3個以後開始有機會出現錯誤，並且數量越多出錯率越高。

**原因和解決方法待補。**
