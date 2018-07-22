Clear-Host

# Find text file from report folder
$File = 'C:\Reports\*.txt'

# Get text file from previous day and then remove the file from Report folder.
Get-ChildItem $File | Where-Object{$_.LastWriteTime -ge (Get-Date).AddDays(-1)} | Remove-Item -WhatIf