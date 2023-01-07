# Transact-SQL

#database/sql/mssql

Reference:

<https://zh.wikipedia.org/wiki/Transact-SQL>

## Abstract

> **Transact-SQL**（又稱T-SQL），是在[Microsoft SQL Server](https://zh.wikipedia.org/wiki/Microsoft_SQL_Server)和[Sybase SQL Server](https://zh.wikipedia.org/wiki/Adaptive_Server_Enterprise)上的ANSI [SQL](https://zh.wikipedia.org/wiki/SQL)實作，與[Oracle](https://zh.wikipedia.org/wiki/Oracle)的[PL/SQL](https://zh.wikipedia.org/wiki/PL/SQL)性質相近（不只是實作ANSI SQL，也為自身資料庫系統的特性提供實作支援），目前在Microsoft SQL Server[1](https://zh.wikipedia.org/wiki/Transact-SQL#cite_note-1)和Sybase Adaptive Server[2](https://zh.wikipedia.org/wiki/Transact-SQL#cite_note-2)中仍然被使用為核心的查詢語言。
>
> Transact-SQL是具有批次與區塊特性的SQL指令集合，資料庫開發人員可以利用它來撰寫資料部份的商業邏輯（Data-based Business Logic），以強制限制前端應用程式對資料的控制能力。同時，它也是資料庫物件的主要開發語言。

## Structure

### Data Definition Language

簡稱DDL

是對於資料庫物件的控制語法，對資料庫物件（如資料表，預存程序，函式或自訂型別等）的新增，修改和刪除都使用此語法。

- CREATE（建立資料庫物件）
- ALTER（修改資料庫物件）
- DROP（刪除資料庫物件）

### Data Manipulation Language

簡稱DML

是一般開發人員俗稱的[CRUD](https://zh.wikipedia.org/wiki/CRUD)（Create/Retrieve/Update/Delete）功能，意指資料的新增／擷取／修改／刪除四個功能。

- SELECT（R）
- INSERT（C）
- UPDATE（U）
- DELETE（D）

### Data Control Language

簡稱DCL

是由資料庫所提供的保安功能，對於資料庫與資料庫物件的存取原則與權限，都由DCL定義之。

- GRANT（賦與權限）
- REVOKE（復原權限）
