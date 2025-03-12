# Define la ruta donde se van a guardar los perfiles Wifi que se ha conectado ese equipo
$outputPath = "$env:USERPROFILE\Desktop\WiFiProfiles.xml"

# Exportar todos los perfiles Wi-Fi a un archivo XML en el escritorio con la clave en claro
netsh wlan export profile folder="$env:USERPROFILE\Desktop" key=clear

Write-Host "Perfiles Wi-Fi exportados a: $outputPath" -ForegroundColor Cyan
