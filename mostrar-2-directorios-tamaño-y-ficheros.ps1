# Función para mostrar tamaño y número de ficheros por subdirectorio

# Ruta de origen base
$origenBase = "\\server\Fotos"

# Ruta de destino base
$destinoBase = "D:\COPIA_SEG_FOTOS"

function Mostrar-Tamano-Subdirectorios {
    param (
        [string]$ruta
    )

    Write-Host "`n📂 Analizando: $ruta`n"

    Get-ChildItem -Path $ruta -Directory | ForEach-Object {
        $archivos = Get-ChildItem -Path $_.FullName -Recurse -File -ErrorAction SilentlyContinue
        $tamano = ($archivos | Measure-Object -Property Length -Sum).Sum
        $numArchivos = $archivos.Count
        $tamanoGB = "{0:N2}" -f ($tamano / 1GB)
        "{0,-50} {1,10} GB   {2,8} ficheros" -f $_.Name, $tamanoGB, $numArchivos
    }

    # También mostrar archivos sueltos en la raíz
    $archivosRaiz = Get-ChildItem -Path $ruta -File -ErrorAction SilentlyContinue
    $tamanoRaiz = ($archivosRaiz | Measure-Object -Property Length -Sum).Sum
    $numRaiz = $archivosRaiz.Count
    if ($tamanoRaiz -gt 0) {
        $tamanoGB = "{0:N2}" -f ($tamanoRaiz / 1GB)
        "Archivos en la raíz del directorio        {0,10} GB   {1,8} ficheros" -f $tamanoGB, $numRaiz
    }
}

# Mostrar resultados
Mostrar-Tamano-Subdirectorios $origenBase
Mostrar-Tamano-Subdirectorios $destinoBase
