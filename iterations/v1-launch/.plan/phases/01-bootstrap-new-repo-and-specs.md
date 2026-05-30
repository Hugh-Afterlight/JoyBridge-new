# Phase 01 · bootstrap-new-repo-and-specs

Status: in progress

## Goal

建立独立重构仓库，导入原 JoyBridge 源码作为只读参考后的重构基线，并补齐 First Flight 完整规格文档。

## Tasks

- [x] 创建独立 GitHub 仓库 `Hugh-Afterlight/JoyBridge-Refactor`。(command: `gh repo create Hugh-Afterlight/JoyBridge-Refactor`)
- [x] 初始化本地 Git 仓库并绑定新 remote。(command: `git remote -v`)
- [x] 只读克隆原仓库到临时目录用于参考。(command: `git clone --depth 1 https://github.com/Hugh-Afterlight/JoyBridge.git /tmp/JoyBridge-source-reference`)
- [x] 将原仓库源码复制到当前新仓库作为重构基线。(README.md:1, JoyBridge/JoyBridgeApp.swift:1)
- [x] 整理 BRIEF 长期纲领。(BRIEF.md:1)
- [x] 将 PRD 整理到 First Flight 标准位置。(iterations/v1-launch/PRD.md:1)
- [x] 保留根目录 PRD 导航，避免旧路径误读。(PRD.md:1)
- [x] 补齐 ARCHITECTURE 技术架构。(ARCHITECTURE.md:1)
- [x] 补齐 CONTENT 内容索引。(iterations/v1-launch/CONTENT.md:1)
- [x] 生成 AGENTS 和 CLAUDE 入口文档。(AGENTS.md:1, CLAUDE.md:1)
- [x] 建立 v1-launch phase 计划目录。(iterations/v1-launch/.plan/plan.md:1)
- [ ] 初始 commit/push 到新仓库。(waiting: 需要用户确认是否由 AI 提交，或用户自行提交)

## Acceptance

- `git remote -v` 只显示 `JoyBridge-Refactor`。
- 原仓库没有任何远端变化。
- First Flight 六份文档齐全：BRIEF、PRD、DESIGN、ARCHITECTURE、CONTENT、AGENTS。
- `xcodebuild -list -project JoyBridge.xcodeproj` 可以读取项目。
- 用户确认是否进入 Phase 02。

## Notes

当前 phase 不直接进入代码重构。Phase 02 才开始抽领域模型和测试。
