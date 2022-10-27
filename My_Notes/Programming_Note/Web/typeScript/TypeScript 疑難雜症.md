# 疑難雜症

## constructor overload

constructor 有別於其他方法，雖然允許overload但只能有一個實作

![](https://i.imgur.com/cHe2d8X.png)

具體可以參考 [Constructor overload in TypeScript - Stack Overflow](https://stackoverflow.com/questions/12702548/constructor-overload-in-typescript)

至於為什麼不支援的原因，我有在github的討論串找到

> Because Javascript itself does not allow, and TS does not want to add more runtime behavior (see [TS design goal](https://github.com/Microsoft/TypeScript/wiki/TypeScript-Design-Goals#non-goals)).
