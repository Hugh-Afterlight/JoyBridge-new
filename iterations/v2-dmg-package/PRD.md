# JoyBridge · PRD · v2-dmg-package

> 本文档定义 v1 重构完成后的一个小迭代：为 JoyBridge-new 增加本地 DMG 测试包，方便作者和朋友安装测试。根目录的 `BRIEF.md` 仍是长期纲领。

## 背景

v1-launch 已经完成 JoyBridge-new 的重构、朋友测试 zip 包和公共 GitHub Release。zip 可以使用，但对非技术朋友来说，DMG 更符合 macOS 安装习惯：打开磁盘映像，把 App 拖到 Applications，再授权辅助功能权限。

本迭代只改善分发包装，不改变 App 功能、不做正式 Developer ID 签名、不做 Apple 公证。

## 目标

- 生成 `JoyBridge-new-v0.10.0-local-test.dmg`。
- DMG 内包含 `JoyBridge-new.app`、`Applications` 快捷方式、`READ-ME-FIRST.txt` 和测试说明文档。
- 文档明确说明：这是本地朋友测试包，未公证，仍需手动允许打开并授权 Accessibility。
- GitHub Release 同时提供 zip 和 dmg，朋友优先下载 DMG。

## 范围

本轮做：

- 新增 DMG 打包脚本。
- 更新 README、FRIEND_TESTING、RELEASE_CHECKLIST、CHANGELOG。
- 生成并验证 DMG。
- 将 DMG 上传到 GitHub Release。

本轮不做：

- 正式 Developer ID 签名。
- Apple 公证。
- App Store 分发。
- 自动更新。
- App 功能变化。

## 验收

- `Scripts/package-local-dmg.sh v0.10.0` 可以生成 DMG。
- `hdiutil verify` 通过。
- DMG 可挂载，根目录能看到 `JoyBridge-new.app`、`Applications`、`READ-ME-FIRST.txt` 和文档。
- GitHub Release 中能下载 DMG。
- README 和朋友测试说明把 DMG 作为推荐路径。
