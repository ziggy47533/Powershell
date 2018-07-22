# PowerShell Create Folder and Files

Clear-Host

New-Item C:\Temp\ExStuff -type directory -ErrorAction SilentlyContinue
    for ( $i = 1; $i -le 10; $i+=1 )
     {
        New-Item H:\PShell\TestFolders\CreateFiles\'Test File'$i.xlsx -type file -ErrorAction SilentlyContinue
     }
    Write-Host "$i Files created"