## ⚠️ SOLO FUNCIONA SI TIENES HABILITADO QUE ESTÉ COMO FONDO: **CONTENIDO DESTACADO DE WINDOWS** ⚠️
## ⚠️ SOLO FUNCIONA SI TIENES HABILITADO QUE ESTÉ COMO FONDO: **CONTENIDO DESTACADO DE WINDOWS** ⚠️
## ⚠️ SOLO FUNCIONA SI TIENES HABILITADO QUE ESTÉ COMO FONDO: **CONTENIDO DESTACADO DE WINDOWS** ⚠️


# Obtener la ruta completa de la imagen de fondo de pantalla
$wallpaperPath = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop").Wallpaper

# Obtener el directorio del fondo de pantalla
$wallpaperDirectory = Split-Path -Path $wallpaperPath -Parent

# Obtener el directorio padre del directorio del fondo de pantalla
$parentDirectory = Split-Path -Path $wallpaperDirectory -Parent

# Mostrar ruta
$parentDirectory

$destinationPath = "$env:USERPROFILE\Pictures\FONDOS DE WINDOWS 11"

# Crea el directorio de destino si no existe
if (!(Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath
}

# Encuentra y copia todas las imágenes
Get-ChildItem -Path $parentDirectory -Recurse -Include *.jpg, *.jpeg, *.png | ForEach-Object {
    # Copia la imagen al destino
    $destFile = Join-Path -Path $destinationPath -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $destFile -Force
    Write-Output "Imagen copiada: $($_.FullName)"
}
exit
