# Ejecutar en powershell
# Verificar si el script se ejecuta como administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Este script debe ejecutarse como administrador."
    Pause
    exit
}

Write-Host "🔧 Configurando WinRM para Ansible..." -ForegroundColor Cyan

# Habilitar WinRM
winrm quickconfig -force

# Permitir autenticación básica
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true

# Permitir conexiones no cifradas (solo para entornos seguros)
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true

# Crear regla de firewall para puerto 5985 (HTTP)
If (-not (Get-NetFirewallRule -DisplayName "Allow WinRM for Ansible" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name "WinRM-Ansible" -DisplayName "Allow WinRM for Ansible" `
        -Protocol TCP -LocalPort 5985 -Action Allow -Direction Inbound
}

# Asegurar que el servicio WinRM se inicie automáticamente
Set-Service -Name WinRM -StartupType Automatic
Start-Service WinRM

# Mostrar configuración
Write-Host "`n✅ WinRM está listo para conexiones desde Ansible." -ForegroundColor Green
winrm get winrm/config

Pause
```
