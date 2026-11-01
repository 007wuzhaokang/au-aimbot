# Au Aimbot — 运行环境依赖清单

本文档说明 `Au.exe` 运行所需的环境与依赖。程序本体为**绿色单文件**（`release/Au.exe`），
大部分依赖已静态编译或内嵌，但首次运行仍需确认以下系统组件。

## 操作系统
- Windows 10 1809 (build 17763) 或更高版本
- **仅支持 64 位**（x64）
- 推荐 Windows 10 21H2 / Windows 11

## 必备前置软件：UU 远程

**本外挂需搭配 [UU 远程](https://uuyc.163.com)（网易 UU 云电脑 / 远程串流）使用。**

- 游戏画面通过 UU 远程串流到本机，外挂对串流画面做 DXGI 采集 + AI 目标检测，再输出自瞄移动。
- 使用前请先安装并登录 UU 远程，确认《无畏契约》串流画面正常显示后，再启动本外挂。
- 若 UU 远程未启动或串流画面异常，外挂将无法正常采集画面、检测目标与自瞄。

## 系统运行时（必备）

| 组件 | 是否内嵌 | 说明 |
|------|----------|------|
| Microsoft Visual C++ 2015-2022 运行库 (x64) | 部分内嵌 | 建议手动安装完整包，见下方下载 |
| DirectX 11 / DirectX 12 | 系统自带 | 屏幕采集与覆盖层渲染 |
| DirectML | 已内嵌 | ONNX 模型 GPU 推理运行时 |
| .NET Framework | 不需要 | 本程序为原生 C++，无 .NET 依赖 |

## 必装：VC++ 运行库

下载并安装最新版 **Microsoft Visual C++ 2015-2022 Redistributable (x64)**：

```
https://aka.ms/vs/17/release/vc_redist.x64.exe
```

若缺失，启动时会报 `VCRUNTIME140.dll` / `MSVCP140.dll` 缺失。

## 图形 API 支持
- 覆盖层基于 Direct2D + DirectWrite + DirectComposition（Win10+ 自带）
- 屏幕采集基于 DXGI Desktop Duplication（Win8+ 自带）
- 模型推理优先走 DirectML（GPU），无 GPU 时回退 CPU

## 输入注入通道（按需）

外挂通过鼠标驱动/硬件盒注入鼠标移动事件，支持以下通道：

- `GHUB` — 罗技 G HUB 鼠标驱动
- `Razer` — 雷蛇 Synapse 驱动
- `TTBOX` / `KMBOX` — 硬件盒子（需自备硬件）
- `UU` / `Maku` / `Aupx` — 其它注入后端（`UU` 同时对应 UU 远程串流注入通道）

程序默认 `auto` 自动探测可用通道；仅在有对应硬件/驱动时才会生效。
无任何通道可用时，自瞄无法移动鼠标（只能显示 ESP 覆盖层）。

## 网络
- 程序启动时需联网完成授权校验（`[auth]`）
- 校验服务器时钟偏移（`clock_skew`），系统时间需基本准确
