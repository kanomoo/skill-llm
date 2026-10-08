@echo off
chcp 65001 >nul
echo ============================================================
echo Starting Local AI: Qwen2.5-Coder-7B-Instruct (Vulkan GPU)
echo ============================================================
powershell -ExecutionPolicy Bypass -File "%~dp0start-lmstudio-server.ps1"
pause
