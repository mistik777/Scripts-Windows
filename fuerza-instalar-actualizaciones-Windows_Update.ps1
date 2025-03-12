# "FUERZA ACTUALIZAR WINDOWS UPDATE"
# Verificar si el script se ejecuta como administrador
	if (-not (Test-Path "HKU\S-1-5-19")) {

Write-Host "Este script debe ejecutarse como administrador." -ForegroundColor Yellow
		pause
	}

# Instalar el modulo PSWindowsUpdate y actualizar el sistema

Install-Module PSWindowsUpdate -Force
Get-WindowsUpdate -AcceptAll -Install -AutoReboot
