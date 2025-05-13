# Mostrar tabla de eventos comunes
Write-Host "`nID Evento`tDescripción`t`tCategoría"
Write-Host "---------`t-----------------------------`t-------------------------"
@"
4624    Inicio de sesión correcto                Inicio de sesión
4625    Error en el inicio de sesión             Inicio de sesión
4647    El usuario ha iniciado el cierre de sesión Cierre de sesión
4634    Se ha cerrado una sesión                 Cierre de sesión
4672    Inicio de sesión con privilegios especiales Inicio de sesión
4648    Se usaron credenciales explícitas        Autenticación
4688    Se ha creado un nuevo proceso            Control de procesos
4689    Se ha terminado un proceso               Control de procesos
4663    Se ha accedido a un objeto               Acceso a objetos
4660    Se ha eliminado un objeto                Acceso a objetos
4656    Se ha solicitado acceso a un objeto      Acceso a objetos
4658    Se ha cerrado el identificador de un objeto Acceso a objetos
4719    Se han cambiado las directivas de auditoría Configuración de seguridad
4720    Se ha creado una cuenta de usuario       Administración de cuentas
4722    Se ha habilitado una cuenta de usuario   Administración de cuentas
4723    Se intentó cambiar la contraseña         Administración de cuentas
4725    Se ha deshabilitado una cuenta de usuario Administración de cuentas
4726    Se ha eliminado una cuenta de usuario    Administración de cuentas
4732    Un usuario fue agregado a un grupo local Administración de grupos
4740    Una cuenta fue bloqueada                 Administración de cuentas
4768    Solicitud de ticket TGT (Kerberos)       Autenticación Kerberos
4769    Solicitud de ticket de servicio (Kerberos) Autenticación Kerberos
4776    Validación de credenciales               Autenticación
"@ | Write-Host

# Solicitar ID de evento al usuario
$eventId = Read-Host "`nIntroduce el ID de evento que deseas buscar"

# Validar si es un número
if (-not [int]::TryParse($eventId, [ref]0)) {
    Write-Host "El valor introducido no es un número válido." -ForegroundColor Red
    exit
}

# Opcional: permitir ajustar días hacia atrás
$days = Read-Host "¿Cuántos días atrás quieres buscar? (Por defecto: 1)"
if (-not [int]::TryParse($days, [ref]0)) {
    $days = 1
}

# Buscar eventos
Write-Host "`nBuscando eventos con ID $eventId en los últimos $days día(s)...`n"

try {
    Get-WinEvent -FilterHashtable @{
        LogName = 'Security';
        Id = [int]$eventId;
        StartTime = (Get-Date).AddDays(-[int]$days)
    } | Format-List TimeCreated, Message
} catch {
    Write-Host "Error al recuperar los eventos. Asegúrate de tener permisos de administrador y que el registro exista." -ForegroundColor Red
}
