#Cambia DNS de equipos windows del Campus Digital FP para acceder por contexto local a campusvdi.es
# El siguiente script es válido para WINDOWS y debe ejecutarse como ADMINSITRADOR en PowerShell
# Muestra una lista con los adaptadores de red del equipo. Selecciona y cambia por:
#DNS primario `192.168.15.91`    DNS secundario `8.8.8.8`


# Función para mostrar información de red
function Mostrar-InfoRed($alias) {
    $ipInfo = Get-NetIPAddress -InterfaceAlias $alias | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -ne 'WellKnown' }
    $dnsInfo = Get-DnsClientServerAddress -InterfaceAlias $alias

    Write-Host "`n--- Información de red para: $alias ---"
    Write-Host "Dirección IP: $($ipInfo.IPAddress)"
    Write-Host "Servidores DNS: $($dnsInfo.ServerAddresses -join ', ')"
}

# DNS a aplicar
$dnsServers = @("192.168.15.91", "8.8.8.8")

# Obtener adaptadores activos
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

clear

if (-not $adapters) {
    Write-Host "No se encontraron adaptadores de red activos."
    exit
}

# Mostrar adaptadores activos numerados
Write-Host "Adaptadores de red activos:"
$index = 1
$adapterMap = @{}
foreach ($adapter in $adapters) {
    Write-Host "$index) $($adapter.Name)"
    $adapterMap[$index] = $adapter.Name
    $index++
}

# Solicitar selección al usuario

$selectedIndex = Read-Host "`nIngresa el número del adaptador que deseas configurar"

if ($adapterMap.ContainsKey([int]$selectedIndex)) {
    $alias = $adapterMap[[int]$selectedIndex]

    # Mostrar configuración antes
    Write-Host "`n[ANTES] Configuración actual de: $alias"
    Mostrar-InfoRed -alias $alias

    # Cambiar DNS
    Write-Host "`nAplicando DNS $($dnsServers -join ', ') a $alias..."
    Set-DnsClientServerAddress -InterfaceAlias $alias -ServerAddresses $dnsServers

    # Limpiar caché DNS
    Write-Host "Limpiando la caché DNS..."
    Clear-DnsClientCache
    Write-Host "Caché DNS limpiada."

    # Mostrar configuración después
    Write-Host "`n[DESPUÉS] Configuración de red actualizada:"
    Mostrar-InfoRed -alias $alias
} else {
    Write-Host "Selección inválida. Saliendo del script."
}
