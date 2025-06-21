#Guardar en carpeta del usuario
#Ejecuta wind+r  y escribe   shell:startup  eso abre la carpeta donde se ejecutan las cosas al iniciar windows
#Crear acceso directo a este script con parámetros
#Parámetros C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\TU-USUARIO\actualizacion-sw-silenciosa-al-inicio.ps1"


Add-Type -AssemblyName PresentationFramework

# Mostrar ventana de confirmación
$resultado = [System.Windows.MessageBox]::Show(
    "¿Deseas actualizar el software del sistema?",
    "Actualización del Sistema",
    "YesNo",
    "Question"
)

if ($resultado -eq "Yes") {
    Start-Transcript -Path "$env:LOCALAPPDATA\winget-update-log.txt" -Append
    Write-Output "Iniciando actualización de software con winget..."

    # Ejecutar actualización silenciosa
    winget upgrade --all --silent --accept-source-agreements --accept-package-agreements

    Write-Output "Actualización completada."
    Stop-Transcript

    # Mensaje final
    [System.Windows.MessageBox]::Show(
        "Se ha actualizado el software. Ya puedes cerrar esta ventana.",
        "Actualización finalizada",
        "OK",
        "Information"
    )
} else {
    Write-Output "Actualización cancelada por el usuario."
    exit
}
