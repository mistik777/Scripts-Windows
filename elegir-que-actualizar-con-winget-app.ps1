# Obtener lista de actualizaciones disponibles
$updates = winget upgrade --include-unknown | ForEach-Object {
    $line = $_.Trim() -split '\s{2,}'  # Divide la línea en columnas separadas por múltiples espacios
    if ($line.Count -ge 4) {
        [PSCustomObject]@{
            Nombre        = $line[0]
            Id            = $line[1]
            VersionActual = $line[2]
            VersionNueva  = $line[3]
        }
    }
} | Where-Object { $_ -ne $null }

# Verificar si hay actualizaciones disponibles
if ($updates.Count -eq 0) {
    Write-Host "No hay actualizaciones disponibles." -ForegroundColor Green
    exit
}

# Mostrar lista de programas con actualización disponible
Write-Host "Programas con actualizaciones disponibles:" -ForegroundColor Cyan
$updates | Format-Table Nombre, VersionActual, VersionNueva -AutoSize

# Preguntar por cada programa si se quiere actualizar
foreach ($app in $updates) {
    # Pregunta con opción por defecto "Sí"
    $respuesta = Read-Host "¿Quieres actualizar '$($app.Nombre)'? (Sí/no, por defecto Sí)"
    
    if ($respuesta -match "^(n|N|no|No)$") {
        Write-Host "Omitiendo actualización de $($app.Nombre)." -ForegroundColor Red
    } else {
        Write-Host "Actualizando $($app.Nombre) de manera silenciosa..." -ForegroundColor Yellow
        # Actualización silenciosa sin interacción
        winget upgrade --Name "$($app.Nombre)" --silent --accept-source-agreements --accept-package-agreements
        Write-Host "$($app.Nombre) actualizado correctamente." -ForegroundColor Green
    }
}

Write-Host "Proceso de actualización finalizado." -ForegroundColor Cyan
