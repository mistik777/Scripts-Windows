#Borra historial cmdlets PowerShell
$historyFile = (Get-PSReadlineOption).HistorySavePath
if (Test-Path $historyFile) {Remove-Item $historyFile -Force}

#Cierra PowerShell
exit
