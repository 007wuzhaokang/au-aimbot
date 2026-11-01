# 技术架构与逆向分析

本文记录对 `Au.exe` 的逆向分析结论，供研究学习。

## 一、文件整体结构

`Au.exe` 是一个**三层嵌套**的 PE 结构：

```
┌─────────────────────────────────────────────────┐
│ Au.exe (外层)                                   │
│  - 名称: Ki.UuycDeployer ("Ki uuyc Bridge      │
│    Deployer")                                    │
│  - 导入: USER32 / ADVAPI32 / WINTRUST /         │
│    KERNEL32 / SHELL32                            │
│  - 角色: 加载器/部署器 stub                      │
│  - .rsrc 占 74MB，其中 RCDATA (ID 122)          │
│    内嵌了真正的 payload                          │
└──────────────┬──────────────────────────────────┘
               │ 解包 + WinVerifyTrust 签名校验
┌──────────────▼──────────────────────────────────┐
│ 内层 PE (主程序)                                │
│  - C++ 编写，命名空间 ui::ki，类 KiUI            │
│  - 8 个节，.text 13MB 代码                       │
│  - 导入: d3d11/d3d12/dxgi/d2d1/DWrite/dcomp/    │
│    dwmapi (图形+覆盖层)                          │
│  - HID/SETUPAPI (输入设备)                       │
│  - WS2_32 (网络) bcrypt (加密)                   │
│  - .rsrc 56MB，内嵌 DirectML.dll + ONNX 模型     │
└──────────────┬──────────────────────────────────┘
               │ 运行时
┌──────────────▼──────────────────────────────────┐
│ 功能子系统                                      │
│  1. 屏幕采集   DXGI Desktop Duplication         │
│  2. AI 推理    ONNX Runtime + DirectML          │
│  3. ESP 渲染   Direct2D + DirectWrite + DComp   │
│  4. 输入注入   HID / 鼠标驱动 / 硬件盒          │
│  5. 授权认证   网络 + bcrypt + clock_skew       │
└─────────────────────────────────────────────────┘
```

## 二、关键特征字符串

### 程序标识
- `Ki.UuycDeployer` / `Ki uuyc Bridge Deployer`
- `KiUI::loadUi`、命名空间 `ui::ki`
- 类 `RootSurface`、`ComboBox`、`CD2DControlBaseUI`、`WidgetRegistry`、`UiLoader`

### 自瞄 (AimBot) 生命周期
```
AimBot initialized
AimBot thread started
AimBot stopped
AimBot::init: DXGI capture initialization failed
AimBot::init: detector initialization failed
AimBot::init: preview window initialization failed
AimBot::init: preview window opened
AimBot: preview window opened/closed
```

### 注入通道枚举
```
Aupx|UU|GHUB|Razer|TTBOX|Maku
```
设备探测日志：`[TTBOX] Connect() failed`、`[TTBOX] Device not found or not ready after 5s`

### 授权与反检测
- `WinVerifyTrust`（加载器校验 payload 签名）
- `[auth] clock_skew response had invalid server_time`（时钟偏移校验）
- `deploy begin: staged payload verified`（分阶段部署校验）

### 配置序列化（JSON）
```
{"game_sensitivity":%.2f,"aim_fov":%.0f,"aim_speed_x":%.2f,
 "aim_speed_y":%.2f,"aim_speed_x2":%.2f,"aim_speed_y2":%.2f,
 "aim_pos1":"%s","aim_pos2":"%s"}
```

### UI 控件名
```
sensitivitySlider / sensitivityReadout / summaryFovValue
bodyHeadButton / bodyNeckButton / bodyChestButton
hotkeyA / hotkeyB / targetH / targetV
```

## 三、AI 视觉自瞄原理

1. **采集**：DXGI Desktop Duplication API 截取屏幕帧。
2. **检测**：将帧送入 ONNX 目标检测模型（DirectML 在 GPU 上推理），
   输出人物边界框 + 部位关键点（头/颈/胸）。
3. **瞄准**：计算目标部位与屏幕准星的像素偏移，通过鼠标驱动/硬件盒
   注入相对鼠标移动事件，实现自动瞄准。
4. **ESP**：将检测结果叠加绘制到 DirectComposition 透明覆盖层。

## 四、编译信息

- 内层 PE 构建路径：`C:\__w\1\s\build\x64-win-redist-release\bin\`
  （`__w\1\s` 为 GitHub Actions 经典工作目录，说明由 CI 构建）
- 内嵌 `DirectML.pdb` 引用，DirectML 为微软 DirectX 机器学习运行时
- 架构：x64（PE32+，Machine 0x8664）

## 五、目标游戏（字符串逆向确认）

- COD（使命召唤系列）
- CF（穿越火线）
- R6（彩虹六号：围攻）

> 注：目标游戏支持范围以实际检测模型与适配为准，以上为字符串证据。
