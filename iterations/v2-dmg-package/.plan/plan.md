# JoyBridge · v2-dmg-package · Plan

> 本计划管理 JoyBridge-new DMG 本地测试包迭代。这个迭代只改变分发包装和说明，不改变 App 功能。

## 背景

v1 重构版已经可以通过 zip 包给朋友测试。为了让安装体验更接近普通 macOS App，本迭代增加 DMG 包：朋友打开后把 `JoyBridge-new.app` 拖到 Applications，再按提示授权辅助功能。

## 范围

本轮做：

- 新增 DMG 打包脚本。
- 更新朋友测试和发布说明。
- 生成并验证 DMG。
- 上传 DMG 到 GitHub Release。

本轮不做：

- Developer ID 签名。
- Apple 公证。
- App Store 发布。
- 自动更新。
- App 功能变化。

## 阶段总览

| Phase | 目标 | 状态 |
|---|---|---|
| 01-dmg-local-test-package | 增加 DMG 打包、验证和 Release 附件 | completed |

## 关键决策

- 使用 macOS 自带 `hdiutil`，不引入第三方依赖。
- 保留 zip 包，新增 DMG 作为朋友测试推荐下载项。
- DMG 中放 Applications 快捷方式和 `READ-ME-FIRST.txt`，降低安装解释成本。

## Open Questions

- 后续正式公开发布时，是否升级为 Developer ID 签名和 Apple 公证 DMG。
