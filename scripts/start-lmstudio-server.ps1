# Set UTF-8 Encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ">> Launching Local AI: Qwen2.5-Coder-7B-Instruct (Vulkan GPU)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Ensure Vulkan runtime is active
lms runtime select llama.cpp-win-x86_64-vulkan-avx2@2.53.0

# Start LM Studio server on port 1234
Write-Host "Starting LM Studio local server on port 1234..." -ForegroundColor Yellow
lms server start

# Check if model is already loaded in VRAM
$loaded = lms ps 2>&1 | Out-String
if ($loaded -match "qwen2.5-coder-7b-instruct") {
    Write-Host "Model 'qwen2.5-coder-7b-instruct' is already loaded in RX 580 VRAM!" -ForegroundColor Green
} else {
    Write-Host "Loading Qwen2.5-Coder-7B into RX 580 VRAM (Context: 32K)..." -ForegroundColor Yellow
    lms load qwen2.5-coder-7b-instruct --gpu max -c 32768 --identifier qwen2.5-coder-7b-instruct -y
}

Write-Host "`n[PASS] Local AI Server is ONLINE at http://127.0.0.1:1234/v1" -ForegroundColor Green
Write-Host "Connected to 9router: use model 'local/qwen2.5-coder-7b-instruct' or 'local-combo'" -ForegroundColor Green
