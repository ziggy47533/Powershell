# Foreach example to display the partitions size [GB]

$disk= Get-WmiObject Win32_LogicalDisk
"Drive Ltr: Size [GB]"
Foreach ( $drive in $disk ) { $drive.Name + "\" + `
" Size = " + [int]($drive.Size/1073741824) + " " +"GB" }