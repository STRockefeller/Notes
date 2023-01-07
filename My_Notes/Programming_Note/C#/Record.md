# Record

#c_sharp

https://docs.microsoft.com/zh-tw/dotnet/csharp/whats-new/csharp-9

C#9.0版本引進的新型別



## 記錄類型

C # 9.0 引進了 ***記錄類型***。 您可以使用 `record` 關鍵字來定義參考型別，以提供用於封裝資料的內建功能。 您可以使用位置參數或標準屬性語法，建立具有不可變屬性的記錄類型：



```csharp
public record Person(string FirstName, string LastName);
```



```csharp
public record Person
{
    public string FirstName { get; init; } = default!;
    public string LastName { get; init; } = default!;
};
```

您也可以使用可變屬性和欄位來建立記錄類型：



```csharp
public record Person
{
    public string FirstName { get; set; } = default!;
    public string LastName { get; set; } = default!;
};
```

雖然記錄可以是可變動的，但主要是用於支援不可變的資料模型。 記錄類型提供下列功能：

- [使用不可變的屬性建立參考型別的簡潔語法](https://docs.microsoft.com/zh-tw/dotnet/csharp/whats-new/csharp-9#positional-syntax-for-property-definition)
- 適用于以資料為中心之參考型別的行為：
  - [值相等](https://docs.microsoft.com/zh-tw/dotnet/csharp/whats-new/csharp-9#value-equality)
  - [非破壞性變化的簡潔語法](https://docs.microsoft.com/zh-tw/dotnet/csharp/whats-new/csharp-9#nondestructive-mutation)
  - [顯示的內建格式](https://docs.microsoft.com/zh-tw/dotnet/csharp/whats-new/csharp-9#built-in-formatting-for-display)
- [支援繼承階層](https://docs.microsoft.com/zh-tw/dotnet/csharp/whats-new/csharp-9#inheritance)

您可以使用 [結構類型](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/builtin-types/struct) 來設計以資料為中心的型別，以提供實值相等且幾乎不會有任何行為。 但對於相對較大的資料模型，結構類型有一些缺點：

- 它們不支援繼承。
- 它們在判斷值是否相等時的效率較低。 如果是實值型別， [ValueType.Equals](https://docs.microsoft.com/zh-tw/dotnet/api/system.valuetype.equals) 方法會使用反映來尋找所有欄位。 若為記錄，編譯器會產生 `Equals` 方法。 在實務上，記錄中的實值相等顯著會更快。
- 在某些情況下，它們會使用更多的記憶體，因為每個實例都有所有資料的完整複本。 記錄類型是 [參考](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/builtin-types/reference-types)型別，因此記錄實例只包含資料的參考。

### 屬性定義的位置語法

您可以使用位置參數來宣告記錄的屬性，以及在建立實例時初始化屬性值：



```csharp
public record Person(string FirstName, string LastName);

public static void Main()
{
    Person person = new("Nancy", "Davolio");
    Console.WriteLine(person);
    // output: Person { FirstName = Nancy, LastName = Davolio }
}
```

當您使用屬性定義的位置語法時，編譯器會建立：

- 記錄宣告中所提供之每個位置參數的公用僅限初始自動執行屬性。 僅限初始化的屬性只能在函 [式](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/keywords/init) 中設定，或是使用屬性初始化運算式來設定。
- 主要的函式，其參數符合記錄宣告上的位置參數。
- `Deconstruct`具有 `out` 在記錄宣告中提供的每個位置參數之參數的方法。

如需詳細資訊，請參閱 c # 語言參考文章中有關記錄的 [位置語法](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/builtin-types/record#positional-syntax-for-property-definition) 。

### 不變性

記錄類型不一定是不可變的。 您可以使用非 `set` 的存取子和欄位來宣告屬性 `readonly` 。 但是雖然記錄可以是可變動的，但可讓您更輕鬆地建立不可變的資料模型。 您使用位置語法建立的屬性是不可變的。

當您想要以資料為中心的型別為安全線程，或雜湊程式碼在雜湊表中保持不變時，可能會很有用。 它可以防止您以傳址方式將引數傳遞給方法時所發生的錯誤，而且方法不會意外地變更引數值。

記錄類型獨有的功能是由編譯器合成的方法所執行，而且這些方法都不會藉由修改物件狀態來危及非可變性。

### 實值相等

值相等表示如果類型相符且所有屬性和域值相符，則記錄類型的兩個變數會相等。 對於其他參考型別，相等表示身分識別。 也就是說，如果參考型別的兩個變數參考相同的物件，就會相等。

下列範例說明記錄類型的實值相等：



```csharp
public record Person(string FirstName, string LastName, string[] PhoneNumbers);

public static void Main()
{
    var phoneNumbers = new string[2];
    Person person1 = new("Nancy", "Davolio", phoneNumbers);
    Person person2 = new("Nancy", "Davolio", phoneNumbers);
    Console.WriteLine(person1 == person2); // output: True

    person1.PhoneNumbers[0] = "555-1234";
    Console.WriteLine(person1 == person2); // output: True

    Console.WriteLine(ReferenceEquals(person1, person2)); // output: False
}
```

在 `class` 類型中，您可以手動覆寫等號比較方法和運算子來達成值的相等，但開發和測試該程式碼會相當耗時且容易出錯。 有了這項功能內建功能，可防止在新增或變更屬性或欄位時，忘記更新自訂覆寫程式碼所造成的錯誤。

如需詳細資訊，請參閱 c # 語言參考文章中有關記錄的 [值相等](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/builtin-types/record#value-equality) 。

### 非破壞性變化

如果您需要改變記錄實例的不可變屬性，您可以使用 `with` 運算式來達到非破壞性的 *變化*。 `with`運算式會建立新的記錄實例，此實例是現有記錄實例的複本，並已修改指定的屬性和欄位。 您可以使用 [物件初始化運算式](https://docs.microsoft.com/zh-tw/dotnet/csharp/programming-guide/classes-and-structs/object-and-collection-initializers) 語法來指定要變更的值，如下列範例所示：



```csharp
public record Person(string FirstName, string LastName)
{
    public string[] PhoneNumbers { get; init; }
}

public static void Main()
{
    Person person1 = new("Nancy", "Davolio") { PhoneNumbers = new string[1] };
    Console.WriteLine(person1);
    // output: Person { FirstName = Nancy, LastName = Davolio, PhoneNumbers = System.String[] }

    Person person2 = person1 with { FirstName = "John" };
    Console.WriteLine(person2);
    // output: Person { FirstName = John, LastName = Davolio, PhoneNumbers = System.String[] }
    Console.WriteLine(person1 == person2); // output: False

    person2 = person1 with { PhoneNumbers = new string[1] };
    Console.WriteLine(person2);
    // output: Person { FirstName = Nancy, LastName = Davolio, PhoneNumbers = System.String[] }
    Console.WriteLine(person1 == person2); // output: False

    person2 = person1 with { };
    Console.WriteLine(person1 == person2); // output: True
}
```

如需詳細資訊，請參閱 c # 語言參考文章中有關記錄的非 [破壞性變化](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/builtin-types/record#nondestructive-mutation) 。

### 顯示的內建格式

記錄類型具有編譯器產生的 [ToString](https://docs.microsoft.com/zh-tw/dotnet/api/system.object.tostring) 方法，可顯示公用屬性和欄位的名稱和值。 方法會傳回 `ToString` 下列格式的字串：

> <record type name> { <property name> = <value>, <property name> = <value>, ...}

若為參考型別，則會顯示內容參考之物件的類型名稱，而不是屬性值。 在下列範例中，陣列是參考型別，因此 `System.String[]` 會顯示，而不是實際的陣列元素值：

複製

```
Person { FirstName = Nancy, LastName = Davolio, ChildNames = System.String[] }
```

如需詳細資訊，請參閱 c # 語言參考文章中有關記錄的 [內建格式](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/builtin-types/record#built-in-formatting-for-display) 。

### 繼承

記錄可以繼承自另一個記錄。 但是，記錄無法繼承自類別，而且類別無法繼承自記錄。

下列範例說明使用位置屬性語法的繼承：



```csharp
public abstract record Person(string FirstName, string LastName);
public record Teacher(string FirstName, string LastName, int Grade)
    : Person(FirstName, LastName);
public static void Main()
{
    Person teacher = new Teacher("Nancy", "Davolio", 3);
    Console.WriteLine(teacher);
    // output: Teacher { FirstName = Nancy, LastName = Davolio, Grade = 3 }
}
```

如果兩個記錄變數相等，則執行時間類型必須相等。 包含變數的類型可能會不同。 下列程式碼範例將說明這一點：



```csharp
public abstract record Person(string FirstName, string LastName);
public record Teacher(string FirstName, string LastName, int Grade)
    : Person(FirstName, LastName);
public record Student(string FirstName, string LastName, int Grade)
    : Person(FirstName, LastName);
public static void Main()
{
    Person teacher = new Teacher("Nancy", "Davolio", 3);
    Person student = new Student("Nancy", "Davolio", 3);
    Console.WriteLine(teacher == student); // output: False

    Student student2 = new Student("Nancy", "Davolio", 3);
    Console.WriteLine(student2 == student); // output: True
}
```

在此範例中，所有實例都有相同的屬性和相同的屬性值。 但是 `student == teacher` `False` ，雖然這兩個都是類型變數，但卻會傳回 `Person` 。 和會傳回， `student == student2` `True` 雖然一個是 `Person` 變數，另一個是 `Student` 變數。

衍生和基底類型的所有公用屬性和欄位都會包含在 `ToString` 輸出中，如下列範例所示：



```csharp
public abstract record Person(string FirstName, string LastName);
public record Teacher(string FirstName, string LastName, int Grade)
    : Person(FirstName, LastName);
public record Student(string FirstName, string LastName, int Grade)
    : Person(FirstName, LastName);

public static void Main()
{
    Person teacher = new Teacher("Nancy", "Davolio", 3);
    Console.WriteLine(teacher);
    // output: Teacher { FirstName = Nancy, LastName = Davolio, Grade = 3 }
}
```

如需詳細資訊，請參閱 c # 語言參考文章中有關記錄的 [繼承](https://docs.microsoft.com/zh-tw/dotnet/csharp/language-reference/builtin-types/record#inheritance) 。



## 心得

目前看來定位在"struct 的上位替代"，有獨立的繼承體系，並且為參考型別，但又能以`==`運算子判別內容是否相等。在大多數的情況下可以做到取代`struct`的作用。