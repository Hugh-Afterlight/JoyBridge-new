# JoyBridge · AGENTS

> 这份文档是 Codex / Claude 进入本项目的入口。开始任何工作前，请先读完本文件，再按文档地图读取对应规格。

## 项目一句话

JoyBridge 是一款面向个人 Mac 用户的原生 macOS 工具，用于把蓝牙手柄等外部设备的按键稳定映射为键盘按键或快捷键。

## 仓库边界

- 原仓库：`https://github.com/Hugh-Afterlight/JoyBridge`，只读参考，不要 push、不要开分支、不要改远端状态。
- 新仓库：`https://github.com/Hugh-Afterlight/JoyBridge-Refactor`，本轮重构工作所在仓库。
- 在运行任何 `git push` 前，必须确认 `git remote -v` 指向 `JoyBridge-Refactor`。

## 文档地图

长期文档在项目根目录：

| 文档 | 内容 |
|---|---|
| `BRIEF.md` | 项目长期纲领：是什么、给谁、为什么做、边界 |
| `DESIGN.md` | macOS utility 视觉与 UX 风格 |
| `ARCHITECTURE.md` | 技术栈、分层、验证命令、风险 |
| `AGENTS.md` | 本文件，AI 入口和协作规则 |
| `CLAUDE.md` | 指向本文件 |

首版迭代文档在 `iterations/v1-launch/`：

| 文档 | 内容 |
|---|---|
| `PRD.md` | 本轮重构目标、场景、范围、验收 |
| `CONTENT.md` | App 内文案、状态文案、诊断字段 |
| `.plan/plan.md` | phase 总览 |
| `.plan/phases/` | 每个 phase 的实施和验收记录 |

## 项目本质边界

永远会是：

- 简洁的 macOS 本地工具。
- 外部设备到键盘动作的桥接器。
- 适合个人使用和朋友测试的可维护软件。

永远不会做：

- 复杂自动化平台。
- 游戏辅助作弊工具。
- 云同步账号系统。
- 插件市场。
- 让普通用户找不到入口的重型控制中心。

任何请求如果偏离这些边界，先停下来和用户确认，不要默认扩张范围。

## 技术栈

JoyBridge 使用 Swift + SwiftUI + AppKit + GameController.framework + CoreGraphics CGEvent。不要改成 Electron、Tauri、Python、Node.js 或 Web App。

本轮默认不新增第三方依赖。确实需要新依赖时，先说明原因、风险、替代方案，并更新 `ARCHITECTURE.md` 后再动手。

## 写代码前必须做

1. 读 `BRIEF.md`。
2. 读 `iterations/v1-launch/PRD.md`。
3. 读 `DESIGN.md`。
4. 读 `ARCHITECTURE.md`。
5. 读 `iterations/v1-launch/CONTENT.md`。
6. 读当前 `.plan/plan.md` 和活跃 phase 文档。
7. 跑 `git remote -v`，确认没有指向原仓库。

## 核心开发规则

- 小步修改，不做无关重写。
- SwiftUI View 只展示状态和触发操作，不承载复杂业务规则。
- Controller 输入、目标过滤、映射选择、键盘输出、权限检测、诊断生成必须逐步解耦。
- 目标手柄锁定是业务规则，不是单纯 UI 状态。
- 暂停映射只停止键盘输出，不停止输入监听和最近按键显示。
- 退出 App 前必须释放已按下的 modifier。
- UI 文案以 `CONTENT.md` 为准。
- 视觉和组件风格以 `DESIGN.md` 为准，不使用游戏化、霓虹、复杂控制台风格。

## Phase 管理规则

本项目重构跨多文件、多步骤，必须使用 First Flight phases。

- 当前实施目录：`iterations/v1-launch/.plan/`。
- 每个 phase 完成后停下来让用户验收。
- 任务完成必须在 phase 文档里附 evidence，例如文件路径、命令或 commit hash。
- AI 不自行跳过任务；需要跳过时先问用户。
- AI 不自行新增 scope；发现新任务时先说明原因。
- 默认不替用户 commit。只有用户明确要求提交/推送时，才可以在确认 remote 后操作。

## 常用命令

```bash
git remote -v
xcodebuild -list -project JoyBridge.xcodeproj
xcodebuild -project JoyBridge.xcodeproj -scheme JoyBridge -configuration Debug -destination 'platform=macOS' build
Scripts/check-release-readiness.sh v0.10.0
```

如果新增测试 target：

```bash
xcodebuild test -project JoyBridge.xcodeproj -scheme JoyBridge -destination 'platform=macOS'
```

## Spec Sync

- 长期定位变化：更新 `BRIEF.md`。
- 视觉或文案风格变化：更新 `DESIGN.md`。
- 技术栈、目录、依赖、验证命令变化：更新 `ARCHITECTURE.md`。
- 本轮重构范围变化：更新 `iterations/v1-launch/PRD.md`。
- UI 文案或诊断字段变化：更新 `iterations/v1-launch/CONTENT.md`。
- 实施进度变化：更新 `.plan/` 下的 plan 和 phase 文档。

不要把新功能需求塞回 v1 PRD。后续新功能应新建 `iterations/v2-{slug}/PRD.md`。

## 给非程序员用户的沟通方式

- 用普通话解释决策，少用术语。
- 每次改动后总结改了哪些文件、验证结果、剩余风险。
- 发现风险先说明，不把问题藏在代码里。
- 用户是项目 owner；范围、跳过、提交、发布这类决定由用户确认。
