# Eliminar todos los perfiles Wi-Fi existentes
# OJO!!! BORRA TODAS LAS WiFis a las que te has conectado en ese equipo

netsh wlan delete profile name=*

Write-Host "Perfiles Wi-Fi eliminados: $profileName" -ForegroundColor Cyan
