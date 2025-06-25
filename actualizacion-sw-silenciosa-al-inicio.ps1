#Guardar en carpeta del usuario
#Ejecuta wind+r  y escribe   shell:startup  eso abre la carpeta donde se ejecutan las cosas al iniciar windows
#Crear acceso directo a este script con parámetros
#Parámetros C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\TU-USUARIO\actualizacion-sw-silenciosa-al-inicio.ps1"

Start-Transcript -Path "$env:LOCALAPPDATA\winget-update-log.txt" -Append

Write-Output ""
Write-Output "--- Iniciando actualización con winget ---"
Write-Output ""

if (Get-Command winget -ErrorAction SilentlyContinue) {
    try {
        winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
        Write-Output ""
        Write-Output "Actualización finalizada correctamente."
    } catch {
        Write-Output ""
        Write-Output "Error durante la actualización: $($_.Exception.Message)"
    }
} else {
    Write-Output ""
    Write-Output "El comando 'winget' no está disponible en este sistema."
}

Stop-Transcript

# Mostrar mensaje al finalizar
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show(
    "YA PUEDES CERRAR ESTA VENTANA",
    "Actualización finalizada",
    [System.Windows.MessageBoxButton]::OK,
    [System.Windows.MessageBoxImage]::Information
)

# Cerrar la terminal
exit
