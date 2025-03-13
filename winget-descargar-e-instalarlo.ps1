#Establecer variables para identificar rol del usuario
$Principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$IsAdmin = $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Verificar si es usuario con permisos de administrador
if (-not $IsAdmin) {
    Write-Host "Este script debe ejecutarse como administrador. Adios!" -ForegroundColor Yellow
    pause
    exit
} else {

#Ejecutas o escribes lo que quieras entre estas llaves

# URL del archivo a descargar
$url = "https://github.com/microsoft/winget-cli/releases/download/v1.10.340/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundlee"

# Descargar el archivo
Invoke-WebRequest -Uri $url -OutFile $tempPath

# Instalar el paquete MSIX
Add-AppxPackage -Path $tempPath

Write-Host "El paquete se ha instalado, esta ventana se cerrará en 5,4,3,2,1..."

# Esperar 5 segundos antes de cerrar
Start-Sleep -Seconds 5
Write-Host "Adios"

exit
 } 
