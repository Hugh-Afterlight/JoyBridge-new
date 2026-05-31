# Phase 01 · dmg-local-test-package

Status: completed

## Goal

新增本地朋友测试 DMG，让作者和朋友可以用更自然的 macOS 安装方式测试 JoyBridge-new。

## Tasks

- [x] 新增 `Scripts/package-local-dmg.sh`。(`Scripts/package-local-dmg.sh:1-148`)
- [x] 更新 README 的本地测试包说明。(`README.md:95-138`)
- [x] 更新 FRIEND_TESTING.md 的安装步骤。(`FRIEND_TESTING.md:7-19`, `FRIEND_TESTING.md:73-85`)
- [x] 更新 RELEASE_CHECKLIST.md 和 CHANGELOG.md。(`RELEASE_CHECKLIST.md:1-16`, `CHANGELOG.md:3-47`)
- [x] 生成并验证 DMG。(`Scripts/package-local-dmg.sh v0.10.0`, `hdiutil verify`, `dmg-mount-contents-ok`)
- [x] 上传 DMG 到 GitHub Release。(`gh release upload v0.10.0 dist/JoyBridge-new-v0.10.0-local-test.dmg --repo Hugh-Afterlight/JoyBridge-new --clobber`, release `https://github.com/Hugh-Afterlight/JoyBridge-new/releases/tag/v0.10.0`)

## Acceptance

- DMG 能成功生成并通过 `hdiutil verify`。
- DMG 挂载后包含 `JoyBridge-new.app`、`Applications`、`READ-ME-FIRST.txt` 和说明文档。
- Release 中同时有 zip 和 dmg。
- 文档说明 DMG 未公证，仍需手动允许打开和授权辅助功能。

## Notes

本 phase 不改变 App 功能，不做 Developer ID 签名和 Apple 公证。

验证记录：

- `bash -n Scripts/package-local-dmg.sh && bash -n Scripts/package-local-release.sh && bash -n Scripts/check-release-readiness.sh && bash -n Scripts/run-domain-tests.sh` 通过。
- `Scripts/run-domain-tests.sh` 通过，输出 `DomainMappingTests passed`。
- `Scripts/package-local-dmg.sh v0.10.0` 成功生成 `dist/JoyBridge-new-v0.10.0-local-test.dmg`。
- `hdiutil verify dist/JoyBridge-new-v0.10.0-local-test.dmg` 通过。
- DMG 挂载检查通过：包含 `JoyBridge-new.app`、`Applications`、`READ-ME-FIRST.txt`、`FRIEND_TESTING.md`、`README.md`、`CHANGELOG.md`、`RELEASE_CHECKLIST.md`。
- `Scripts/check-release-readiness.sh v0.10.0 /private/tmp/JoyBridgeNewDmg-v0.10.0/JoyBridge-new.app` 可运行，剩余 7 个 warning 均属于未做 Developer ID / Apple 公证的本地测试阶段预期。
- GitHub Release `v0.10.0` 已出现 `JoyBridge-new-v0.10.0-local-test.dmg` 和 `JoyBridge-new-v0.10.0-local-test.zip` 两个附件。
