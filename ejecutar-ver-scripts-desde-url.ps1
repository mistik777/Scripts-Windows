# Definir la URL del script
$url = "https://raw.githubusercontent.com/mistik777/Scripts-Windows/main/broma-pantallazo-actualizacion.ps1"

# Ejecutarlo directamente
iex (Invoke-WebRequest -Uri $url)

# También se podría hacer
iex (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mistik777/Scripts-Windows/main/broma-pantallazo-actualizacion.ps1")

# O más resumido aún...
iex (iwr https://raw.githubusercontent.com/mistik777/Scripts-Windows/main/broma-pantallazo-actualizacion.ps1)

# Para ver el código
clear
(iwr -uri "https://raw.githubusercontent.com/mistik777/Scripts-Windows/main/broma-pantallazo-actualizacion.ps1").content
