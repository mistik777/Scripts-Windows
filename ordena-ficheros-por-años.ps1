Add-Type -AssemblyName System.Windows.Forms

# Crear formulario
$form = New-Object System.Windows.Forms.Form
$form.Text = "Seleccione o Ingrese un Directorio"
$form.Size = New-Object System.Drawing.Size(500,150)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Crear cuadro de texto
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(350,20)
$textBox.Location = New-Object System.Drawing.Point(20,20)
$form.Controls.Add($textBox)

# Crear botón para seleccionar carpeta
$buttonSelect = New-Object System.Windows.Forms.Button
$buttonSelect.Text = "Seleccionar Carpeta"
$buttonSelect.Location = New-Object System.Drawing.Point(380,18)
$buttonSelect.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Seleccione el directorio de trabajo"
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBox.Text = $folderBrowser.SelectedPath
    }
})
$form.Controls.Add($buttonSelect)

# Crear botón de aceptar
$buttonOK = New-Object System.Windows.Forms.Button
$buttonOK.Text = "Aceptar"
$buttonOK.Location = New-Object System.Drawing.Point(200,60)
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $buttonOK
$form.Controls.Add($buttonOK)

# Mostrar formulario y obtener resultado
if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $directorio = $textBox.Text.Trim()
    
    if (-not [string]::IsNullOrWhiteSpace($directorio) -and (Test-Path $directorio)) {
        Write-Host "Directorio seleccionado: $directorio" -ForegroundColor Green
        Set-Location -Path $directorio
        Write-Host "Ahora trabajando en el directorio: $directorio"
        
        # Obtener archivos y organizar por año
        $archivos = Get-ChildItem -Path $directorio -File -Recurse
        foreach ($archivo in $archivos) {
            $anio = $archivo.CreationTime.Year
            $directorioAnio = Join-Path -Path $directorio -ChildPath $anio
            if (-not (Test-Path $directorioAnio)) {
                New-Item -Path $directorioAnio -ItemType Directory
                Write-Host "Creado directorio para el año $anio." -ForegroundColor Yellow
            }
            $destino = Join-Path -Path $directorioAnio -ChildPath $archivo.Name
            if (-not (Test-Path $destino)) {
                Move-Item -Path $archivo.FullName -Destination $destino
                Write-Host "Movido archivo '$($archivo.Name)' al directorio $anio." -ForegroundColor Cyan
            } else {
                Write-Host "El archivo '$($archivo.Name)' ya existe en el destino, no se movió." -ForegroundColor Red
            }
        }
        Write-Host "Archivos organizados por año." -ForegroundColor Green
    } else {
        Write-Host "La ruta especificada no es válida o está vacía." -ForegroundColor Red
    }
} else {
    Write-Host "No se seleccionó ningún directorio. El script se cerrará." -ForegroundColor Red
}
