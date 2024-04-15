# Query json/jsonb array

tags: #database/sql/postgresql

研究了一下發現有點複雜，先記下來免得以後又忘記。

目標是查詢 postgreSQL 裡面以 jsonb 形式儲存的資料內容。

參考:

* StackOverflow 兩篇:
  * <https://stackoverflow.com/questions/22736742/query-for-array-elements-inside-json-type>
  * <https://stackoverflow.com/questions/19568123/query-for-element-of-array-in-json-column?noredirect=1&lq=1>
* 官方文件: <https://www.postgresql.org/docs/current/functions-json.html#FUNCTIONS-JSON-TABLE>

假如我想在schema: my_schema 的 table: my_table 裡面的 jsonb 欄位 jsonb_column 找資料

該jsonb欄位長得像這樣

```json
{
    [
        {
            "name": "elem1",
                "index": 0
        },
        {
            "name": "elem2",
                "index": 1
        }
    //...
    ]
}
```

好吧，用程式語言表示可能比較好看..

```go
type MyTable struct{
    JsonbColumn []contents
}

// json marshable
type contents struct{
    Name string
    Index int
}
```

今天我想找 JsonbColumn含有name=="LaDiDa"的資料

可以下

```sql
SELECT * FROM my_shema.my_table table, jsonb_array_elements(table.jsonb_column #> '{}') contents
WHERE contents ->> 'name' = 'LaDiDa'
```

```sql
my_shema.my_table table
```

這邊的table和後面的contents 都是 SQL 中取的Alias

```sql
jsonb_array_elements()
```

是官方提供可以查詢 jsonb array 內容物的方法(如果要查json就改成用`json_array_elements()`)，方法的參數接收一個jsonb物件

`#>` 運算子官方的說明如下

> ```
> json` `#>` `text[]` → `json
> jsonb` `#>` `text[]` → `jsonb
> ```
>
> Extracts JSON sub-object at the specified path, where path elements can be either field keys or array indexes.
>
> ```
> '{"a": {"b": ["foo","bar"]}}'::json #> '{a,b,1}'` → `"bar"
> ```

簡單來說就是取json裡面某個欄位的value出來，該value型別同樣是json

假如今天我的結構改成

```go
type MyTable struct{
    JsonbColumn Properties
}

type Properties struct{
    Contents []contents
    OutSideProperty string
}

// json marshable
type contents struct{
    Name string
    Index int
}
```

一樣要找裡面的 Properties.Contents 中包含 name == "LaDiDa"  的物件

則要寫成

```sql
SELECT * FROM my_shema.my_table table, jsonb_array_elements(table.jsonb_column #> '{contents}') contents
WHERE contents ->> 'name' = 'LaDiDa'
```

回過頭來看最後的WHERE 條件

```sql
WHERE contents ->> 'name' = 'LaDiDa'
```

`->>`官方文件的描述如下

> ```
> json` `->>` `text` → `text
> jsonb` `->>` `text` → `text
> ```
>
> Extracts JSON object field with the given key, as `text`.
>
> ```
> '{"a":1,"b":2}'::json ->> 'b'` → `2
> ```

簡單來說就是取特定欄位的值，並以text形式呈現 (這裡要注意型別都是text)

於是我們就可以拿 `contents ->> 'name'` 和 `LaDiDa` 做比較

`->>` 運算子後面放 integer 會變成取向應index的value，算是不一樣的做法，要特別注意。

如果今天想要找的條件增加了，也可以寫成

```sql
SELECT * FROM my_shema.my_table table, jsonb_array_elements(table.jsonb_column #> '{}') contents
WHERE contents ->> 'name' = 'LaDiDa' AND contents ->> 'index' = '5'
```

---

同樣可以達成目的的另一個寫法

```sql
SELECT * FROM my_shema.my_table table, jsonb_array_elements(table.jsonb_column) col
WHERE col @> '{"name": "LaDiDa", "index": 5}'
```

`@>`運算子說明如下

> ```
> jsonb` `@>` `jsonb` → `boolean
> ```
>
> Does the first JSON value contain the second? (See [Section 8.14.3](https://www.postgresql.org/docs/current/datatype-json.html#JSON-CONTAINMENT) for details about containment.)
>
> ```
> '{"a":1, "b":2}'::jsonb @> '{"b":2}'::jsonb` → `t
> ```

回傳布林，檢查是否含有指定內容

速記表

![](https://i.imgur.com/QYNJuYi.png)

---

### 補充

#### X.Any(x=>(condition))

`@>`運算子用於找完全相符的物件，但如果要找一部份相符的就不適用了。

此時就能夠使用`jsonb_path_exists()`方法(postgres v10 之前不適用)

[PostgreSQL: Documentation: 15: 9.16. JSON Functions and Operators](https://www.postgresql.org/docs/current/functions-json.html)

> `jsonb_path_exists` ( *`target`* `jsonb`, *`path`* `jsonpath` [, *`vars`* `jsonb` [, *`silent`* `boolean` ]] ) → `boolean`
>
> Checks whether the JSON path returns any item for the specified JSON value. If the *`vars`* argument is specified, it must be a JSON object, and its fields provide named values to be substituted into the `jsonpath` expression. If the *`silent`* argument is specified and is `true`, the function suppresses the same errors as the `@?` and `@@` operators do.
>
> `jsonb_path_exists('{"a":[1,2,3,4,5]}', '$.a[*] ? (@ >= $min && @ <= $max)', '{"min":2, "max":4}')` → `t`

> $.track.segments
>
> To retrieve the contents of an array, you typically use the `[*]` operator. For example, the following path will return the location coordinates for all the available track segments:
>
> ```sql
> $.track.segments[*].location
> ```
>
> To return the coordinates of the first segment only, you can specify the corresponding subscript in the `[]` accessor operator. Recall that JSON array indexes are 0-relative:
>
> ```sql
> $.track.segments[0].location
> ```
>
> The result of each path evaluation step can be processed by one or more `jsonpath` operators and methods listed in [Section 9.16.2.2](https://www.postgresql.org/docs/current/functions-json.html#FUNCTIONS-SQLJSON-PATH-OPERATORS "9.16.2.2. SQL/JSON Path Operators and Methods"). Each method name must be preceded by a dot. For example, you can get the size of an array:

> ```sql
> ? (condition)
> ```
>
> Filter expressions must be written just after the path evaluation step to which they should apply. The result of that step is filtered to include only those items that satisfy the provided condition. SQL/JSON defines three-valued logic, so the condition can be `true`, `false`, or `unknown`. The `unknown` value plays the same role as SQL `NULL` and can be tested for with the `is unknown` predicate. Further path evaluation steps use only those items for which the filter expression returned `true`.
>
> The functions and operators that can be used in filter expressions are listed in [Table 9.50](https://www.postgresql.org/docs/current/functions-json.html#FUNCTIONS-SQLJSON-FILTER-EX-TABLE "Table 9.50. jsonpath Filter Expression Elements"). Within a filter expression, the `@` variable denotes the value being filtered (i.e., one result of the preceding path step). You can write accessor operators after `@` to retrieve component items.

譬如今天我有一個table如下

```sql
CREATE TABLE my_table (
    "id" text NOT NULL PRIMARY KEY,
    "materials" jsonb NOT NULL DEFAULT '[]'::jsonb,
)
```

`materials`的內容物如下

```json
[
 {
  "prop1": {
   "prop1-1": "A",
   "prop1-2": 0
  },
  "prop2": "ZXC",
  "prop3": [
   {
    "prop3-1": "A",
    "prop3-2": 1,
    "prop3-3": "ASD"
   }
  ]
 },
 {
  "prop1": {
   "prop1-1": "A",
   "prop1-2": 0
  },
  "prop2": "ZXC",
  "prop3": [
   {
    "prop3-1": "B",
    "prop3-2": 1,
    "prop3-3": "QWE"
   }
  ]
 }
]
```

我想找`my_table`裡面`material`中有包含任意一筆資料其中`prop3`裡面有包含任意一筆資料的`prop3-1`是"A"且`prop3-2`是1的id。

翻譯成linq就是

```C#
myTable.Where(t=>t.materials.Any(material=>material.prop3.Any(p3=>p3.prop3_1=="A"&&p3.prop3_2==1))).Select(t=>t.id)
```

就可以寫成

```sql
SELECT * FROM myTable
WHERE jsonb_path_exists(materials, '$[*].prop3[*] ? (@.prop3-1 == "A" && @.prop3-2 == 1)')
```
