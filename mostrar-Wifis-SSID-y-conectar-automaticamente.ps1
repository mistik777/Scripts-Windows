
# Definicion de redes Wi-Fi (SSID y contraseñas)
$wifiNetworks = @{
    "Wifi-1"      = 'ContraseñadeWifi-1'
    "Wifi-2"   = 'ContraseñadeWifi-2'
}

# Mostrar las opciones de SSID
Write-Host "Seleccione la red Wi-Fi a la que desea conectarse:" -ForegroundColor Cyan
$i = 1
$ssidList = @()
foreach ($key in $wifiNetworks.Keys) {
    Write-Host "$i. $key"
    $ssidList += $key
    $i++
}

# Solicitar la seleccion de la red Wifi
$selection = Read-Host "Ingrese el numero de la red Wi-Fi"
if ($selection -notmatch '^\d+$' -or [int]$selection -lt 1 -or [int]$selection -gt $wifiNetworks.Count) {
    Write-Host "Seleccion NO valida. Saliendo del script." -ForegroundColor Red
    exit
}

$selectedSSID = $ssidList[[int]$selection - 1]
$wifiPassword = $wifiNetworks[$selectedSSID]

# Configurar la conexion a la red Wi-Fi
Write-Host "Configurando la red Wi-Fi '$selectedSSID'..." -ForegroundColor Yellow

# Crear el perfil de red XML
$profileXML = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$($selectedSSID)</name>
    <SSIDConfig>
        <SSID>
            <name>$($selectedSSID)</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$($wifiPassword)</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"@

# Guardar el perfil en un archivo temporal
$profilePath = "$env:TEMP\WiFiProfile_$($selectedSSID).xml"
$profileXML | Out-File -FilePath $profilePath -Encoding UTF8

# Agregar el perfil de red
netsh wlan add profile filename="$profilePath" user=all | Out-Null

# Conectar a la red seleccionada
Write-Host "Intentando conectar a '$selectedSSID'..." -ForegroundColor Green
netsh wlan connect name="$selectedSSID" | Out-Null

# Verificar la conexion
Start-Sleep -Seconds 5
$status = netsh wlan show interfaces

if ($status -match "SSID\s*:\s*$selectedSSID") {
    Write-Host "Conexion exitosa a '$selectedSSID'." -ForegroundColor Green
} else {
    Write-Host "Error al conectar a '$selectedSSID'." -ForegroundColor Red
	Pause
}

# Eliminar el archivo temporal
Remove-Item -Path $profilePath -Force | Out-Null
