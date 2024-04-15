
tags: #database/sql/sqlite 

About PK (Primary Key) in SQLite, I have summarized the following characteristics:

1. Similar to PostgreSQL, SQLite allows specifying multiple PKs.
2. Some third-party database GUI tools may not display all PKs (only the first one).
3. When checking PKs, it is recommended to use "!= 0" instead of "= 1" to ensure that all PKs are listed.

![image](https://i.imgur.com/JrQqRoc.png)