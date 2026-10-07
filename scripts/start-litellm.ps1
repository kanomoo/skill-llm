# Start LiteLLM proxy
$ConfigPath = Join-Path $PSScriptRoot "..\litellm_config.yaml"
Write-Host "Starting LiteLLM Unified Proxy on http://127.0.0.1:4000..." -ForegroundColor Cyan
litellm --config $ConfigPath --port 4000 --host 127.0.0.1
