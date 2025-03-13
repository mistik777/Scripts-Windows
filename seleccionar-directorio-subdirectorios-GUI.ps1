# Solicitar al usuario que seleccione un directorio mediante un cuadro de dialogo - GUI
Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Seleccione el directorio de trabajo"

if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $workingDir = $folderBrowser.SelectedPath
    
    # Establecer la ruta del directorio y sus subdirectorios
    Write-Host "Directorio seleccionado: $workingDir" -ForegroundColor Green
    
    # Obtener todos los subdirectorios
    $subdirectories = Get-ChildItem -Path $workingDir -Directory -Recurse
    
    Write-Host "Lista de subdirectorios:" -ForegroundColor Cyan
    $subdirectories | ForEach-Object { Write-Host $_.FullName }
    
    # Obtener todos los archivos en el directorio y subdirectorios
    $files = Get-ChildItem -Path $workingDir -File -Recurse
}
