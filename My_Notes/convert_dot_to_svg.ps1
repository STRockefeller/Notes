$directory = "./"

$files = Get-ChildItem -Path $directory -Recurse -Filter *.dot

foreach ($file in $files) {
    dot -Tsvg $file.FullName > $file.FullName.Replace(".dot", ".svg")
}
