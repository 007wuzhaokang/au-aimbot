# 配置项详解

`Au.exe` 通过 JSON 配置文件读取参数。配置文件默认路径为程序同目录或工作目录下的
`config/config.json`（首次运行若不存在，使用内置默认值）。

配置模板见 [`config/config.example.json`](../config/config.example.json)。

## 自瞄参数

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `game_sensitivity` | float | 1.0 | 游戏内鼠标灵敏度，用于像素→鼠标移动距离换算 |
| `aim_fov` | int | 25 | 自瞄视场角（度）。仅锁定准星中心 ±fov 范围内的目标 |
| `aim_speed_x` | float | 1.0 | X 轴瞄准速度系数 |
| `aim_speed_y` | float | 1.0 | Y 轴瞄准速度系数 |
| `aim_speed_x2` | float | 1.0 | 第二瞄准部位 X 轴系数（对应 `aim_pos2`） |
| `aim_speed_y2` | float | 1.0 | 第二瞄准部位 Y 轴系数 |
| `aim_pos1` | string | head | 主瞄准部位：`head` / `neck` / `chest` |
| `aim_pos2` | string | chest | 次瞄准部位（用于瞄准切换） |

## 平滑参数

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `smooth` | float | 4.0 | 平滑系数，越大移动越"缓"，越小越"生硬" |
| `framersmooth` | bool | true | 启用逐帧平滑（按帧插值） |

## 热键

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `hotkeyA` | string | VK_XBUTTON2 | 自瞄主热键（虚拟键码或名称） |
| `hotkeyB` | string | VK_XBUTTON1 | 自瞄备用热键 |

常用虚拟键：`VK_LBUTTON`(左键)、`VK_RBUTTON`(右键)、`VK_XBUTTON1`(侧键1)、`VK_XBUTTON2`(侧键2)、`VK_SHIFT`、`VK_CONTROL`。

## 目标与过滤

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `targetH` | string | head | 水平瞄准目标部位 |
| `targetV` | string | body | 垂直瞄准目标部位 |
| `team_check` | bool | true | 队友过滤（不瞄准队友） |
| `visibility_check` | bool | true | 可见性检查（忽略被遮挡目标） |
| `triggerbot` | bool | false | 扳机触发（目标进入准星时自动开火） |

## 检测模型

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `confidence_threshold` | float | 0.45 | 目标检测置信度阈值（0~1） |
| `ioU_threshold` | float | 0.4 | NMS 的 IoU 阈值 |

## 输入注入

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `input_channel` | string | auto | 注入后端，见下表 |

可选注入通道：

| 值 | 后端 | 前提 |
|----|------|------|
| `auto` | 自动探测 | 按可用性优先级自动选择 |
| `GHUB` | 罗技 G HUB | 安装罗技 G HUB 并连接罗技鼠标 |
| `Razer` | 雷蛇 Synapse | 安装雷蛇 Synapse 并连接雷蛇鼠标 |
| `TTBOX` | TTBOX 硬件盒 | 连接 TTBOX 硬件 |
| `KMBOX` | KMBOX 硬件盒 | 连接 KMBOX 硬件 |
| `UU` / `Maku` / `Aupx` | 其它后端 | 对应后端可用 |

> **注意**：驱动/硬件通道不可用时，自瞄无法移动鼠标，但 ESP 覆盖层仍可工作。

## 采集与覆盖层

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `capture_mode` | string | dxgi | 屏幕采集模式（`dxgi` 桌面复制） |
| `overlay_enabled` | bool | true | 是否启用覆盖层 |

## ESP

| 键 | 类型 | 默认 | 说明 |
|----|------|------|------|
| `esp_box` | bool | true | 敌人方框 |
| `esp_bone` | bool | false | 骨骼线 |
| `esp_health_bar` | bool | false | 血条 |
| `esp_distance` | bool | true | 距离显示 |
