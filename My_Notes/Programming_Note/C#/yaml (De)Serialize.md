# Yaml Serialize

tags: #c_sharp #yaml #serialize #marshal

參考

https://blog.no2don.com/2021/02/c-yaml-json.html



使用套件 YamlDotNet



Sample

```C#
            CommandStruct cs = new CommandStruct() { symbol="s s",command="go test ./...",check=true};
            List<CommandStruct> lcs = new List<CommandStruct>
            {
                new CommandStruct() { symbol = "go fmt", command = "go fmt ./...", check = false },
                new CommandStruct() { symbol = "go vet", command = "go vet ./...", check = true }
            };

            YamlDotNet.Serialization.ISerializer serializer = new YamlDotNet.Serialization.SerializerBuilder().Build();
            var yamlString1 = serializer.Serialize(lcs);
            Console.WriteLine(yamlString1);

            var deSerializer = new YamlDotNet.Serialization.DeserializerBuilder().Build();
            var res = deSerializer.Deserialize<List<CommandStruct>>(yamlString1);
```

