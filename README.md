# Au Aimbot — AI 视觉自瞄外挂

> 基于 ONNX + DirectML 的 AI 目标检测视觉自瞄，支持 DXGI 屏幕采集、Direct2D 覆盖层 ESP、鼠标驱动级注入。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20x64-blue.svg)]()
[![Language](https://img.shields.io/badge/Language-C%2B%2B-f34b7d.svg)]()

---

## ⚠️ 免责声明

**本项目仅供技术研究、逆向分析、机器学习与计算机视觉学习使用。**

- 使用本软件在联网游戏中作弊**违反游戏服务条款**，可能导致**账号封禁**，后果自负。
- 部分功能涉及**驱动级输入注入**与**反检测**，仅用于理解 Windows 图形/输入子系统的技术原理。
- 作者不对任何因使用本软件产生的损失负责。

---

## 功能特性

| 类别 | 功能 | 说明 |
|------|------|------|
| 自瞄 | AI 目标检测自瞄 | DXGI 屏幕采集 → ONNX 模型识别人物 → 自动瞄准 |
| 自瞄 | 部位选择 | 头（head）/ 颈（neck）/ 胸（chest），支持双目标部位 |
| 自瞄 | 平滑度 | `smooth` 平滑系数 + `framersmooth` 帧平滑 |
| 自瞄 | FOV 限制 | `aim_fov` 视场角限制，只锁定准星附近目标 |
| 自瞄 | 灵敏度补偿 | `game_sensitivity` / `aim_speed_x/y` 与游戏内灵敏度换算 |
| 触发 | 按键触发 | `hotkeyA` / `hotkeyB` 双热键绑定 |
| ESP | 方框 | `esp_box` 敌人方框 |
| ESP | 骨骼 | `esp_bone` 骨骼线 |
| ESP | 血条 | `esp_health_bar` 血条 |
| ESP | 距离 | `esp_distance` 距离显示 |
| 注入 | 鼠标驱动注入 | 罗技 G HUB / 雷蛇 Synapse / 硬件盒（KMBOX/TTBOX） |
| 反检测 | 签名校验 | payload 加载前 WinVerifyTrust 签名校验 |
| 反检测 | 时钟偏移认证 | `clock_skew` 服务端时钟校验 |

---

## 技术架构

```
Au.exe (外层加载器 / Ki.UuycDeployer)
  └─ 内层 PE (主程序, C++, 命名空间 ui::ki)
       ├─ DXGI Desktop Duplication   ── 屏幕采集
       ├─ ONNX Runtime + DirectML    ── AI 目标检测 (GPU 推理)
       ├─ Direct2D + DirectWrite     ── 覆盖层 ESP 渲染
       ├─ DirectComposition          ── 透明窗口合成
       └─ HID / 鼠标驱动通道         ── 输入注入 (自瞄移动)
```

**推理引擎**：内嵌 ONNX Runtime（含 DirectML 执行提供程序），模型推理优先走 GPU（DirectML），无 GPU 时回退 CPU。

**输入注入通道**（字符串逆向确认）：`Aupx | UU | GHUB | Razer | TTBOX | Maku | KMBOX`

**目标游戏**（字符串逆向确认）：COD（使命召唤）、CF（穿越火线）、R6（彩虹六号）等 FPS 游戏。

---

## 快速开始

### 1. 环境要求

- Windows 10 1809+ / Windows 11（仅 64 位）
- [VC++ 2015-2022 运行库 x64](https://aka.ms/vs/17/release/vc_redist.x64.exe)
- 详见 [`docs/requirements.md`](docs/requirements.md)

### 2. 下载与校验

```bash
# 克隆仓库（含 release/Au.exe 完整二进制）
git clone https://github.com/<你的用户名>/au-aimbot.git
cd au-aimbot

# 校验文件完整性
python scripts/verify.py
```

或直接下载 [`release/Au.exe`](release/Au.exe)：

| 属性 | 值 |
|------|-----|
| 大小 | 77,716,480 字节 (~74 MiB) |
| SHA256 | `847fe9361927df2b204a07c8bd3967fd18f7ad3e5b58a921f587d0f13e693841` |
| MD5 | `bac16255f92289c937bbd0923d506b2b` |

### 3. 运行

```bash
# 双击或命令行启动（推荐管理员权限）
scripts\start.bat
```

首次运行前建议先跑环境检查：

```bash
scripts\check_env.bat
```

### 4. 配置

复制 `config/config.example.json` 为 `config/config.json`，按需修改：

```jsonc
{
  "game_sensitivity": 1.0,   // 与游戏内灵敏度一致
  "aim_fov": 25,             // 自瞄视场角（度）
  "aim_speed_x": 1.0,        // X 轴瞄准速度系数
  "aim_speed_y": 1.0,        // Y 轴瞄准速度系数
  "aim_pos1": "head",        // 主瞄准部位 head/neck/chest
  "aim_pos2": "chest",       // 次瞄准部位
  "smooth": 4.0,             // 平滑系数（越大越平滑）
  "hotkeyA": "VK_XBUTTON2",  // 自瞄热键
  "hotkeyB": "VK_XBUTTON1",  // 备用热键
  "confidence_threshold": 0.45,  // 检测置信度阈值
  "input_channel": "auto"    // 注入通道: auto/GHUB/Razer/TTBOX/KMBOX/UU/Maku/Aupx
}
```

完整配置说明见 [`docs/config.md`](docs/config.md)。

---

## 目录结构

```
au-aimbot/
├── release/
│   └── Au.exe              # 完整可运行二进制（含 AI 模型）
├── config/
│   └── config.example.json # 配置模板
├── scripts/
│   ├── start.bat           # 启动脚本
│   ├── check_env.bat       # 环境检查脚本
│   └── verify.py           # 文件完整性校验脚本
├── docs/
│   ├── requirements.md     # 运行环境依赖
│   ├── config.md           # 配置项详解
│   ├── troubleshooting.md  # 故障排查
│   └── architecture.md     # 技术架构与逆向分析
├── LICENSE
└── README.md
```

---

## 文档

- [运行环境依赖](docs/requirements.md)
- [配置项详解](docs/config.md)
- [技术架构与逆向分析](docs/architecture.md)
- [故障排查](docs/troubleshooting.md)

---

## License

[MIT](LICENSE)
