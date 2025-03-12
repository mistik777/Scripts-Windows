# Solicitar al usuario que seleccione un directorio
Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Seleccione el directorio de trabajo"

if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $directorio = $folderBrowser.SelectedPath
    
    # Establecer la ruta del directorio y mostrar confirmación
    Write-Host "Directorio seleccionado: $directorio" -ForegroundColor Green
    
    # Verificar si la ruta ingresada es válida
    if (Test-Path $directorio) {
        # Establecer la ruta del directorio
        Set-Location -Path $directorio
        Write-Host "Ahora trabajando en el directorio: $directorio"
        
        # Obtener todos los archivos (incluyendo subdirectorios) en el directorio
        $archivos = Get-ChildItem -Path $directorio -File -Recurse
        
        # Organizar los archivos en carpetas por año de creación
        foreach ($archivo in $archivos) {
            # Obtener el año de creación del archivo
            $anio = $archivo.CreationTime.Year
            
            # Crear un directorio con el año si no existe
            $directorioAnio = Join-Path -Path $directorio -ChildPath $anio
            if (-not (Test-Path $directorioAnio)) {
                New-Item -Path $directorioAnio -ItemType Directory
                Write-Host "Creado directorio para el año $anio." -ForegroundColor Yellow
            }
            
            # Mover el archivo al directorio correspondiente
            $destino = Join-Path -Path $directorioAnio -ChildPath $archivo.Name
            if (-not (Test-Path $destino)) {
                Move-Item -Path $archivo.FullName -Destination $destino
                Write-Host "Movido archivo '$($archivo.Name)' al directorio $anio." -ForegroundColor Cyan
            } else {
                Write-Host "El archivo '$($archivo.Name)' ya existe en el destino, no se movió." -ForegroundColor Red
            }
        }
        
        Write-Host "Archivos organizados por año." -ForegroundColor Green
    } else {
        Write-Host "La ruta especificada no es válida." -ForegroundColor Red
    }
} else {
    Write-Host "No se seleccionó ningún directorio. El script se cerrará." -ForegroundColor Red
}
