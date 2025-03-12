# Definir la URL a abrir: 
$url = "https://fakeupdate.net/windows98k/"
#$url = "https://fakeupdate.net/xp/"
#$url = "https://fakeupdate.net/vista"
#$url = "https://fakeupdate.net/win8"
#$url = "https://fakeupdate.net/win7"
#$url = "https://fakeupdate.net/apple"
#$url = "https://fakeupdate.net/steam"
#$url = "https://fakeupdate.net/wnc"

# Ocultar la barra de tareas
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Taskbar {
    [DllImport("user32.dll")] public static extern int FindWindow(string className, string windowName);
    [DllImport("user32.dll")] public static extern int ShowWindow(int hwnd, int command);
    public static void Hide() { ShowWindow(FindWindow("Shell_TrayWnd", ""), 0); }
    public static void Show() { ShowWindow(FindWindow("Shell_TrayWnd", ""), 1); }
}
"@ -PassThru
[Taskbar]::Hide()

# Abrir Microsoft Edge en modo quiosco a pantalla completa
Start-Process "msedge.exe" "--kiosk $url --edge-kiosk-type=fullscreen --no-first-run --disable-features=EdgeExperiments"

# Restaurar la barra de tareas
[Taskbar]::Show()
Write-Host "Saliendo del modo quiosco..."
