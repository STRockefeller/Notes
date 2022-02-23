# Query json/jsonb array



研究了一下發現有點複雜，先記下來免得以後又忘記。

目標是查詢 postgreSQL 裡面以 jsonb 形式儲存的資料內容。



參考:

* StackOverflow 兩篇:
  * https://stackoverflow.com/questions/22736742/query-for-array-elements-inside-json-type
  * https://stackoverflow.com/questions/19568123/query-for-element-of-array-in-json-column?noredirect=1&lq=1
* 官方文件: https://www.postgresql.org/docs/current/functions-json.html#FUNCTIONS-JSON-TABLE



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

`#> ` 運算子官方的說明如下

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



