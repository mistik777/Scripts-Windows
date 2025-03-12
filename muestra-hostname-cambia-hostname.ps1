# Obtener el nombre actual del PC
$nombreActual = hostname

# Mostrar el nombre actual y preguntar si desea cambiarlo
Write-Host "El nombre actual de tu PC es: $nombreActual" -ForegroundColor Yellow
$usuarioDeseaCambiar = Read-Host "Deseas cambiar el nombre del PC? (S/n)"

# Si el usuario elige cambiar el nombre (S)
if ($usuarioDeseaCambiar -eq "S") {

# Solicitar el nuevo nombre del PC
$nuevoNombre = Read-Host "Introduce el nuevo nombre del PC"

# Cambiar el nombre del PC
Rename-Computer -NewName $nuevoNombre -Force

Write-Host "El nombre de tu PC ha sido cambiado a: $nuevoNombre" -ForegroundColor Green
Write-Host "recuerda que para que se haga efectivo hay que reiniciar" -ForegroundColor Yellow
} else {
Write-Host "No se ha cambiado el nombre del PC." -ForegroundColor Green
}
