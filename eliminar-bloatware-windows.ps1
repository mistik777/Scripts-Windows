# Desinstalar aplicaciones preinstaladas de Windows para TODOS los usuarios
# Las comentadas con # no las desinstalo porque las uso

# Verificar si es usuario con permisos de administrador
if (-not $IsAdmin) {
    Write-Host "Este script debe ejecutarse como administrador. Adios!" -ForegroundColor Yellow
    pause
    exit
} else {
   
# Listado de Bloatware a desinstalar
$apps = @(
    "Microsoft.Advertising.Xaml", 
    "Microsoft.AsyncTextService", 
    "Microsoft.Bing*", 
    "Microsoft.BingWeather", 
    "Microsoft.BioEnrollment", 
    # "Microsoft.Clipchamp",
    # "Microsoft.Cortana", 
    # "Microsoft.DesktopAppInstaller", 
    # "Microsoft.GetHelp", 
    "Microsoft.Getstarted", 
    "Microsoft.Microsoft3DViewer", 
    # "Microsoft.MicrosoftEdge", 
    # "Microsoft.MicrosoftEdgeDevToolsClient", 
    "Microsoft.MicrosoftOfficeHub", 
    "Microsoft.MicrosoftSolitaireCollection", 
    # "Microsoft.MicrosoftStickyNotes", 
    "Microsoft.MixedReality.Portal", 
    "Microsoft.Office.OneNote", 
    # "Microsoft.Paint3D", 
    "Microsoft.People", 
    "Microsoft.ScreenSketch", 
    "Microsoft.Services.Store.Engagement", 
    "Microsoft.SkypeApp", 
    "Microsoft.StorePurchaseApp", 
    "Microsoft.Wallet", 
    # "Microsoft.WindowsAlarms", 
    # "Microsoft.WindowsCamera", 
    "Microsoft.WindowsFeedbackHub", 
    "Microsoft.WindowsMaps", 
    # "Microsoft.Windows.Photos", 
    # "Microsoft.WindowsSoundRecorder", 
    "Microsoft.Xbox*", 
    "Microsoft.XboxGameCallableUI", 
    "Microsoft.YourPhone", 
    "Microsoft.ZuneMusic", 
    "Microsoft.ZuneVideo", 
    "SpotifyAB.SpotifyMusic", 
    # "Windows.CBSPreview", 
    "microsoft.windowscommunicationsapps" 
    # "windows.immersivecontrolpanel"
)

# Eliminar aplicaciones para TODOS los usuarios
foreach ($app in $apps) {
    Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage -ErrorAction Continue
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction Continue
}

# Mensaje de finalización
Write-Host "Proceso de eliminación completado. Reinicia el sistema para aplicar los cambios."

}
