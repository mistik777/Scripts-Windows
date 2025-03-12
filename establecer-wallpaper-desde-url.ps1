# Definir la URL de la imagen a usar como fondo de escritorio
$url = "https://img.notionusercontent.com/s3/prod-files-secure%2Fb1ceb426-1bc4-4bba-bbd6-96b3d3c5c7fa%2F578b4609-e0aa-455c-a2ad-1f262b105bd1%2Ffondo-vengadores-black.jpg/size/w=2000?exp=1741872380&sig=IAKHom-nuCx6mYHvLmwofZ14nXOobqFIpuQ6jNCpsaQ"

# Definir la ruta donde guardar la imagen
$descargarRuta = "C:\Wallpaper\fondo.png"

# Crear la carpeta si no existe
if (-not (Test-Path "C:\Wallpaper")) {
    New-Item -Path "C:\Wallpaper" -ItemType Directory
}

# Descargar la imagen
Invoke-WebRequest -Uri $url -OutFile $descargarRuta

# Cambiar el fondo de escritorio a la imagen descargada
$claveRegistro = "HKCU:\Control Panel\Desktop"
$valor = "Wallpaper"
Set-ItemProperty -Path $claveRegistro -Name $valor -Value $descargarRuta

# Actualizar el fondo de escritorio
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

[Wallpaper]::SystemParametersInfo(20, 0, $descargarRuta, 0x01 -bor 0x02)
