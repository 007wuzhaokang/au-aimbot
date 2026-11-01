@echo off
rem ============================================================
rem  Au Aimbot 启动脚本
rem  用法: 双击运行，或以管理员身份运行（推荐，注入更稳定）
rem ============================================================
setlocal

set "EXE=%~dp0release\Au.exe"

if not exist "%EXE%" (
    echo [错误] 未找到 %EXE%
    echo 请确认 release\Au.exe 存在。
    pause
    exit /b 1
)

echo 正在启动 Au Aimbot ...
echo 若需注入硬件盒/驱动，建议以管理员身份运行本脚本。
echo.

"%EXE%"

if errorlevel 1 (
    echo.
    echo [提示] 程序异常退出，退出码 %errorlevel%
    echo 常见原因：VC++ 运行库缺失 / 缺少管理员权限 / 网络授权失败
    echo 请查阅 docs\TROUBLESHOOTING.md
    pause
)

endlocal
