# Powershell script to move mouse smoothly across screen to random locations
#
# By liam-ob

# Get parameters
param (
    [string]$d,
    [string]$Do
)

# Exit if we dont have params
if (-not $d) {
    if (-not $Do) {
        Write-Host "you need to tell the program what to do with the -d or -Do command (you can start it or stop it)"
        Exit
    }
}

$processIdFile =  "blah"

# Check if we tried to stop
if ($d -eq "stop" -or $Do -eq "stop"){
    $processId = Get-Content -Path $processIdFile
    try {
        if (-not $processId) {
            Write-Host "Movem is not running"
        } elseif (Get-Process -Id $processId -ErrorAction SilentlyContinue) {
            Stop-Process -Id $processId
            Remove-Item -Path $processIdFile
            Write-Host -ForegroundColor Green "Stopped process successfully"
        } else {
            Stop-Process -Id $processId
            Remove-Item -Path $processIdFile
            Write-Host -ForegroundColor Magenta "Stopped process kind of successfully"
        }   
    } catch {
        Write-Host -ForegroundColor Red "bad thing happened"
    }
} elseif ($d -eq "start" -or $Do -eq "start") {
    try {
        # I would like to be able to identify this process in the future
        $PROCESS = Start-Process -FilePath "powershell" -ArgumentList "-File filepath" -NoNewWindow -PassThru
        Write-Host "process: "$PROCESS.Id" has started"
        
        $PROCESS.Id | Out-File -FilePath $processIdFile
    } catch {
        Write-Host -ForegroundColor Red "cant"
    }
}