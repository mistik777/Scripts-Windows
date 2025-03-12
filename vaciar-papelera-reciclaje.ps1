#vaciar papelera de reciclaje en windows
Write-Host "Vaciando la papelera de reciclaje..." -ForegroundColor Yellow

try {  Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Host "Papelera vaciada." -ForegroundColor Green
     } catch {

Write-Host "Error al vaciar la papelera $($_.Exception.Message)" -ForegroundColor Red
        }
