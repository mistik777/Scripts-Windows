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
 Write-Host "HOLA SER SUPREMO QUE TE LLAMAN ADMIN" -ForegroundColor Green

 } 
