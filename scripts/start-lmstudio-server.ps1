# Start LM Studio Local Server with Qwen2.5-Coder-7B-Instruct on Vulkan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "🚀 Launching Local AI: Qwen2.5-Coder-7B-Instruct (Vulkan GPU)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Ensure Vulkan runtime is active
lms runtime select llama.cpp-win-x86_64-vulkan-avx2@2.53.0

# Start LM Studio server on port 1234
Write-Host "Starting LM Studio local server on port 1234..." -ForegroundColor Yellow
lms server start

# Load Qwen2.5-Coder-7B with 100% GPU offload and 32K context
Write-Host "Loading Qwen2.5-Coder-7B into RX 580 VRAM (Context: 32K)..." -ForegroundColor Yellow
lms load bartowski/Qwen2.5-Coder-7B-Instruct-GGUF --gpu max -c 32768 --identifier qwen2.5-coder-7b-instruct -y

Write-Host "`n✅ Local AI Server is ONLINE at http://127.0.0.1:1234/v1" -ForegroundColor Green
Write-Host "Connected to 9router: use model 'local/qwen2.5-coder-7b-instruct' or 'local-combo'" -ForegroundColor Green
