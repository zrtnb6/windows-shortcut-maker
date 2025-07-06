@echo off
chcp 65001 > nul
setlocal

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%快捷方式.ps1"
set "INPUT_FILE=%SCRIPT_DIR%网站.txt"

echo 正在准备创建网站快捷方式...
echo 输入文件: %INPUT_FILE%

if not exist "%INPUT_FILE%" (
    echo 错误：找不到网站列表文件！
    echo 请确保在脚本同目录存在"网站.txt"文件
    pause
    exit /b 1
)

echo 正在执行 PowerShell 脚本...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PS_SCRIPT%' -InputFile '%INPUT_FILE%'"

echo.
echo 处理完成！按任意键退出...
pause > nul