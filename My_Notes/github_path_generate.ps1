﻿$createFileName = "github_path_generate.md"
$linkPath="https://github.com/STRockefeller/Notes/tree/master/My_Notes"
$ignoreFolders = @("Temporary", "Personal", "Financial", "Diary")  # Add the folder names to ignore here

function isIgnoreFile($name)
{
    $ignoreFileExtension = @(".dll", ".exe", ".layout", ".out", ".doc", ".zip", ".chm", ".sln", ".csproj")
    $res = $false
    foreach($ext in $ignoreFileExtension)
    {
        $res = $res -or $name.Contains($ext)
    }
    return $res
}

function searchNote($location,[string]$header)
{
    if($header -eq ""){$header="##"}

    $files = $location|Get-ChildItem -File
    $dirs = $location|Get-ChildItem -Directory

    foreach($file in $files)
    {
        $name = $($file.Name)
        if(isIgnoreFile($name))
        {
            continue
        }

        $link=$file.PSpath.Replace($localPath,$linkPath).Replace("\","/").Replace(" ","%20").Replace("#","%23")

        "* [$name]($link)"
    }

    foreach($dir in $dirs)
    {
        $dirName = $($dir.Name)
        if ($dirName -in $ignoreFolders) {
            continue  # Skip the entire directory if it's in the ignore list
        }
        
        $name = $dirName
        "$header $name"
        $newLocation = Join-Path $location $name
        $newHeader = "#$header"
        if($newHeader.Length -gt 6)
        {
            $link=$dir.PSpath.Replace($localPath,$linkPath).Replace("\","/").Replace(" ","%20").Replace("#","%23")
            "* more files in [$name]($link)"
            continue
        }
        searchNote $newLocation $newHeader
    }
}

function startup()
{
    "# Github Note Path"
    Get-Date -Format "yyyy/MM/dd HH:mm K"
    "generated by github_path_generate.ps1"
    searchNote (pwd)
}

Set-Location $PSScriptRoot
$localPath = "Microsoft.PowerShell.Core\FileSystem::$pwd"
startup | Out-File $createFileName
