@echo off
rem ============================================================
rem  Au Aimbot 依赖检查脚本
rem  检查 VC++ 运行库、DirectX 等运行环境是否就绪
rem ============================================================
setlocal

echo ============================================
echo  Au Aimbot 环境检查
echo ============================================
echo.

rem --- 检查 64 位系统 ---
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    if not "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
        echo [失败] 当前不是 64 位系统，本程序仅支持 x64
    ) else (
        echo [通过] 64 位系统
    )
) else (
    echo [通过] 64 位系统
)

rem --- 检查 VC++ 运行库 ---
set "VCRUNTIME_OK=0"
if exist "%SystemRoot%\System32\vcruntime140.dll" set "VCRUNTIME_OK=1"
if exist "%SystemRoot%\System32\vcruntime140_1.dll" set "VCRUNTIME_OK=1"
if "%VCRUNTIME_OK%"=="1" (
    echo [通过] VC++ 2015-2022 运行库
) else (
    echo [失败] 未检测到 vcruntime140.dll，请安装 VC++ 运行库:
    echo        https://aka.ms/vs/17/release/vc_redist.x64.exe
)

rem --- 检查 DirectX ---
if exist "%SystemRoot%\System32\d3d11.dll" (
    echo [通过] DirectX 11
) else (
    echo [失败] 未检测到 d3d11.dll
)
if exist "%SystemRoot%\System32\d3d12.dll" (
    echo [通过] DirectX 12
) else (
    echo [警告] 未检测到 d3d12.dll（Win10 以下系统可能无此组件）
)
if exist "%SystemRoot%\System32\dxgi.dll" (
    echo [通过] DXGI
) else (
    echo [失败] 未检测到 dxgi.dll
)

rem --- 检查可执行文件 ---
if exist "%~dp0..\release\Au.exe" (
    echo [通过] 找到 release\Au.exe
) else (
    echo [失败] 未找到 release\Au.exe
)

echo.
echo 检查完成。若存在 [失败] 项，请先修复后重试。
pause
endlocal
