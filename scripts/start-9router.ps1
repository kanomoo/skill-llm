# Start 9router in system tray
Write-Host "Starting 9router in background system tray mode..." -ForegroundColor Cyan
Start-Process -FilePath "9router" -ArgumentList "--tray", "--no-browser", "--skip-update" -WindowStyle Hidden
Write-Host "9router is running at http://127.0.0.1:20128" -ForegroundColor Green
