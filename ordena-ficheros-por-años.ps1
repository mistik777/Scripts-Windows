# Solicitar al usuario que ingrese el directorio de trabajo
$directorio = Read-Host "Por favor, ingrese la ruta del directorio de trabajo"

# Verificar si la ruta ingresada es válida
if (Test-Path $directorio) {
    # Establecer la ruta del directorio
    Set-Location -Path $directorio
    Write-Host "Ahora trabajando en el directorio: $directorio"
    
    # Obtener todos los archivos (incluyendo subdirectorios) en el directorio
    $archivos = Get-ChildItem -Recurse -File

    # Organizar los archivos en carpetas por año de creación
    foreach ($archivo in $archivos) {
        # Obtener el año de creación del archivo
        $anio = $archivo.CreationTime.Year

        # Crear un directorio con el año si no existe
        $directorioAnio = Join-Path -Path $directorio -ChildPath $anio
        if (-not (Test-Path $directorioAnio)) {
            New-Item -Path $directorioAnio -ItemType Directory
            Write-Host "Creado directorio para el año $anio."
        }

        # Mover el archivo al directorio correspondiente
        $destino = Join-Path -Path $directorioAnio -ChildPath $archivo.Name
        if (-not (Test-Path $destino)) {
            Move-Item -Path $archivo.FullName -Destination $destino
            Write-Host "Movido archivo '$($archivo.Name)' al directorio $anio."
        } else {
            Write-Host "El archivo '$($archivo.Name)' ya existe en el destino, no se movió."
        }
    }

    Write-Host "Archivos organizados por año."
} else {
    Write-Host "La ruta especificada no es válida."
}
