$outputPath = "$env:USERPROFILE\Desktop\WiFiProfiles.xml"

# Exportar todos los perfiles Wi-Fi a un archivo XML
netsh wlan export profile folder="$env:USERPROFILE\Desktop" key=clear

Write-Host "Perfiles Wi-Fi exportados a: $outputPath" -ForegroundColor Cyan

# Obtener y mostrar un resumen de SSID y contraseñas
$xmlFiles = Get-ChildItem "$env:USERPROFILE\Desktop" -Filter "*.xml"

foreach ($file in $xmlFiles) {
    [xml]$xmlContent = Get-Content $file.FullName
    $ssid = $xmlContent.WLANProfile.SSIDConfig.SSID.name
    $password = $xmlContent.WLANProfile.MSM.Security.sharedKey.keyMaterial
    Write-Host "SSID: $ssid | $password" -ForegroundColor Yellow
}
