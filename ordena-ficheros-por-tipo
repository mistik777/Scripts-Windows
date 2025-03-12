# Solicitar al usuario que seleccione un directorio
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
    
    # Definir categorías de archivos
    #$systemExtensions = @("sys", "dll", "exe", "ini", "bat", "log")
    $imageExtensions = @("jpg", "jpeg", "png", "gif", "bmp", "tiff", "svg")
    $documentExtensions = @("doc", "docx", "pdf", "txt", "rtf", "odt", "xls", "xlsx", "ppt", "pptx")
    
    #$systemFolder = Join-Path -Path $workingDir -ChildPath "sistema"
    $imageFolder = Join-Path -Path $workingDir -ChildPath "imgs"
    $documentFolder = Join-Path -Path $workingDir -ChildPath "docs"
    
    # Crear carpetas si no existen
    foreach ($folder in @($systemFolder, $imageFolder, $documentFolder)) {
        if (!(Test-Path -Path $folder)) {
            New-Item -ItemType Directory -Path $folder | Out-Null
        }
    }
    
    $unmovedExtensions = @()
    
    foreach ($file in $files) {
        $extension = $file.Extension.TrimStart('.')
        
        if ($systemExtensions -contains $extension) {
            $destinationFolder = $systemFolder
        } elseif ($imageExtensions -contains $extension) {
            $destinationFolder = $imageFolder
        } elseif ($documentExtensions -contains $extension) {
            $destinationFolder = $documentFolder
        } elseif (-not [string]::IsNullOrEmpty($extension)) {
            $destinationFolder = Join-Path -Path $workingDir -ChildPath $extension
        } else {
            $unmovedExtensions += $extension
            continue
        }
        
        # Crear la carpeta si no existe
        if (!(Test-Path -Path $destinationFolder)) {
            New-Item -ItemType Directory -Path $destinationFolder | Out-Null
        }
        
        # Mover el archivo a la carpeta correspondiente
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Movido: $($file.FullName) -> $destinationPath" -ForegroundColor Yellow
    }
    
    # Preguntar si se deben eliminar las carpetas vacías
    $deleteEmptyFolders = Read-Host "¿Desea eliminar las carpetas vacías? (S/N)"
    if ($deleteEmptyFolders -eq "S") {
        Get-ChildItem -Path $workingDir -Directory -Recurse | Where-Object { (Get-ChildItem -Path $_.FullName -Force).Count -eq 0 } | Remove-Item -Force -Recurse
        Write-Host "Carpetas vacías eliminadas." -ForegroundColor Green
    }
    
    # Mostrar extensiones no movidas
    if ($unmovedExtensions.Count -gt 0) {
        $uniqueUnmoved = $unmovedExtensions | Select-Object -Unique
        Write-Host "Extensiones no movidas: $($uniqueUnmoved -join ', ')" -ForegroundColor Red
    }
} else {
    Write-Host "No se seleccionó ningún directorio." -ForegroundColor Red
}
