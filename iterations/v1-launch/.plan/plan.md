# JoyBridge · v1-launch · Plan

> 本计划管理 JoyBridge 重构版从规格准备到可验收 MVP 的实施。每个 phase 完成后都需要停下来给用户验收。

## 背景

JoyBridge 已有可运行 MVP，但代码仍处在快速堆功能后的状态。重构目标不是扩大功能，而是把输入、映射、输出、权限、诊断、UI 和持久化职责拆清，让产品能稳定服务作者本人和朋友测试者。

本轮所有工作在新仓库 `Hugh-Afterlight/JoyBridge-Refactor` 进行。原仓库 `Hugh-Afterlight/JoyBridge` 只作为只读参考。

## 范围

本轮做：

- 建立 First Flight 完整规格。
- 复制原仓库源码作为重构基线。
- 重构核心领域模型、系统适配、状态服务和 SwiftUI 界面。
- 补充核心逻辑测试。
- 保留朋友测试和本地发布脚本。

本轮不做：

- Electron/Tauri/Node/Python 重写。
- 云同步、账号系统、插件系统。
- App Store、公证、自动更新。
- 鼠标控制、摇杆滚动、左右 Joy-Con 合并。

## 阶段总览

| Phase | 目标 | 状态 |
|---|---|---|
| 01-bootstrap-new-repo-and-specs | 新仓库、源码基线、First Flight 文档完整落地 | completed |
| 02-domain-and-store | 抽出领域模型、MappingProfile、MappingStore 和核心测试 | completed |
| 03-input-output-services | 解耦手柄输入、目标过滤、映射执行、键盘输出和权限检查 | completed |
| 04-runtime-diagnostics-ui | 重整运行状态、诊断信息、主窗口和菜单栏体验 | completed |
| 05-validation-and-friend-test | 构建验证、测试说明、发布准备脚本和朋友测试回归 | completed |

## 关键决策

- 保持原生 macOS 技术栈，避免引入跨平台壳。
- 不一次性大迁移 Xcode 文件引用，避免 `.xcodeproj` 变更失控。
- 优先测试纯领域逻辑和服务边界，UI 自动化暂不进入本轮。
- 每个 phase 都必须有可观察验收标准。

## Open Questions

- 新增 `JoyBridgeTests` target 时，是否顺手整理 Xcode group 结构。
- 朋友测试版本号是否继续沿用 `v0.10.0`，还是重构版改为 `v0.11.0`。
