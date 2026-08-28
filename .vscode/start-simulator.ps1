$sdkRoot = (Get-Content "$env:APPDATA\Garmin\ConnectIQ\current-sdk.cfg" -Raw).Trim()

$running = $false
try {
    $client = New-Object Net.Sockets.TcpClient
    $client.Connect("localhost", 1234)
    $running = $client.Connected
    $client.Close()
} catch {}

if (-not $running) {
    Start-Process -FilePath (Join-Path $sdkRoot "bin\simulator.exe") -WorkingDirectory (Join-Path $sdkRoot "bin")
}
