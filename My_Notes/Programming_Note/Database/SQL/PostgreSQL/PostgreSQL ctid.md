# PostgreSQL 中的 `ctid` 字段解析

本文檔提供了對 PostgreSQL 數據庫中 `ctid` 字段的詳細解析，包括其定義、使用場景以及與主鍵查詢的比較等。

## `ctid` 定義

在 PostgreSQL 中，每條記錄（行）都有一個特殊的系統列 `ctid`，這個字段代表了該行在物理存儲中的位置。`ctid` 的值由兩部分組成：頁面編號（Block number）和頁面內的項目索引。具體來說：

- 第一部分是頁面編號，它指向表中的一個特定數據塊。
- 第二部分是項目索引，它指示該數據塊中的具體行位置。

## `ctid` 的使用效率和限制

儘管 `ctid` 可以被用於直接訪問表中的特定行，但它的使用效率和應用場景相對有限，主要因為：

- `ctid` 查詢不能與正式索引（如 B-tree 索引）的效率相比。
- `ctid` 的值可能會因為行的移動（如 VACUUM 操作後）而改變，導致其不穩定。
- `ctid` 不反映行的插入或修改順序。

## `ctid` 的應用場景

`ctid` 主要用於以下幾種特定的技術場景：

1. 解決表中無唯一標識符時的重複數據問題。
2. 進行系統級別的維護和調試。
3. 在極少數特定性能優化情況下使用。
4. 進行臨時查詢，特別是在開發或測試階段。
5. 與低級功能或插件結合使用。

## 更新操作和 `ctid` 變化

當對表中的一條記錄進行更新時，PostgreSQL 會標記原有記錄為無效並插入一條新記錄，導致 `ctid` 值變化。被更新的記錄的舊 `ctid` 位置暫時被標記為不可見，直到 `VACUUM` 操作釋放並可能重用該空間。

## `ctid` 和空間重用

如果在 `VACUUM` 操作後向表中插入新的資料，該操作有可能會重用之前被更新記錄所佔用的空間（例如 `(0,3)`）。然而，新記錄占用的具體位置取決於當前的空間分配策略和可用性。

## 總結

雖然 `ctid` 在 PostgreSQL 中提供了對記錄物理位置的直接訪問，但由於其限制和特定的使用場景，日常應用中應更傾向於使用主鍵或其他索引進行數據查詢和操作，以確保查詢效率和數據的穩定性。

## References

- <https://www.postgresql.org/docs/current/ddl-system-columns.html>
- <https://www.dbrnd.com/2016/10/postgresql-how-the-rows-are-stored-physically-using-ctid-offset-length-disk-mvcc-internal-storage-architecture/>
- <https://nidhig631.medium.com/ctid-field-in-postgresql-d26977de7b58>
