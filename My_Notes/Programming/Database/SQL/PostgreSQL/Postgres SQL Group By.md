
tags: #database/sql/postgresql

簡單介紹一下我遇到的狀況，假設我有table A，裡面包含三個columns 分別是 a,b,c 其中 a 是 pk。
我想找出裡面b欄位重複的資料，於是我組出了如下sql

```postgresql
SELECT * , COUNT(*) FROM A GROUP BY b HAVING COUNT(*) > 1;
```

卻得到錯誤如下

```
ErrorMessage: 42803: column "a" must appear in the GROUP BY clause or be used in an aggregate function
```

如果我將sql改為

```postgresql
SELECT b , COUNT(*) FROM A GROUP BY b HAVING COUNT(*) > 1;
```

或

```postgresql
SELECT * , COUNT(*) FROM A GROUP BY a HAVING COUNT(*) > 1;
```

則可以正常執行

```postgresql
SELECT b, c , COUNT(*) FROM A GROUP BY b HAVING COUNT(*) > 1;
```

則會提示需要把 "c" 放到group by clause 裡面。

目前看來，可以做個結論就是，一般來說 `select` clause 中出現的項目，會被要求在 `group by` clause 中出現，但有個例外，就是如果 `group by` clause 中包含 pk 的話，就不在此限。

另外，我最開始想做的行為可以用以下sql來完成

```postgresql
SELECT * FROM A WHERE b IN (SELECT b, COUNT(*) FROM A GROUP BY b HAVING COUNT(*) > 1);
```

或者如果只要看到每個GROUP的第一筆資料的話，以下方法也可以

```postgresql
WITH temp AS(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num FROM A
) SELECT * FROM temp WHERE row_num > 1;
```

還有一些其他的做法，例如 select b group by b 之後再 join 原本的table。
詳細可以參考: [stackoverflow](https://stackoverflow.com/questions/39816069/select-all-columns-with-group-by-one-column)