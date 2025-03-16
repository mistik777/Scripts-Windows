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

# Mostrar formulario
if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $workingDir = $textBox.Text
    if (!(Test-Path $workingDir -PathType Container)) {
        Write-Host "La ruta ingresada no es válida." -ForegroundColor Red
        exit
    }
    Write-Host "Directorio seleccionado: $workingDir" -ForegroundColor Green
} else {
    Write-Host "No se seleccionó ningún directorio." -ForegroundColor Red
    exit
}

# Solicitar al usuario que ingrese el año
$year = Read-Host "Ingrese el año a filtrar (YYYY)"

# Validar que el año sea un número válido
if ($year -match "^\d{4}$") {
    # Obtener todos los archivos en el directorio y subdirectorios
    $files = Get-ChildItem -Path $workingDir -File -Recurse
    
    # Configurar barra de progreso
    $totalFiles = $files.Count
    $counter = 0
    
    # Filtrar los archivos que no sean del año especificado y agrupar por año
    $groupedFiles = @{}
    foreach ($file in $files) {
        $counter++
        Write-Progress -Activity "Filtrando archivos" -Status "Procesando: $counter de $totalFiles" -PercentComplete (($counter / $totalFiles) * 100)
        
        $fileYear = $file.LastWriteTime.Year
        if ($fileYear -ne [int]$year) {
            if (-not $groupedFiles.ContainsKey($fileYear)) {
                $groupedFiles[$fileYear] = @()
            }
            $groupedFiles[$fileYear] += "$($file.FullName)`t$($file.LastWriteTime)"
        }
    }
    
    # Crear el archivo de informe
    $reportFile = "$workingDir\INFORME_FICHEROS_OTRO_ANO.txt"
    
    # Escribir en el archivo con la ruta completa, agrupando por año
    $output = ""
    foreach ($group in $groupedFiles.Keys | Sort-Object) {
        $output += "# $group`n"
        $output += ($groupedFiles[$group] -join "`n") + "`n`n"
    }
    
    $output | Out-File -FilePath $reportFile -Encoding UTF8
    
    Write-Host "Informe generado en: $reportFile" -ForegroundColor Yellow
} else {
    Write-Host "Error: Ingrese un año válido en formato YYYY." -ForegroundColor Red
}
