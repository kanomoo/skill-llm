@echo off
echo Starting 9router background gateway in system tray...
start "" 9router --tray --no-browser --skip-update
echo 9router started on http://127.0.0.1:20128
