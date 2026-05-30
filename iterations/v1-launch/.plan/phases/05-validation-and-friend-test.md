# Phase 05 · validation-and-friend-test

Status: completed

## Goal

完成构建验证、朋友测试资料同步和本地发布路径检查，让重构版可以进入小范围测试。

## Tasks

- [x] 跑 `xcodebuild -list -project JoyBridge.xcodeproj`。（`DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -list -project JoyBridge.xcodeproj`：列出 target/scheme `JoyBridge`；裸跑因当前 `xcode-select` 指向 CommandLineTools 不可用）
- [x] 跑 Debug build。（`DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project JoyBridge.xcodeproj -scheme JoyBridge -configuration Debug -destination 'platform=macOS' build`：`BUILD SUCCEEDED`）
- [x] 如已新增测试 target，跑测试。（未新增 Xcode test target；`Scripts/run-domain-tests.sh`：`DomainMappingTests passed`）
- [x] 更新 README 中和重构行为不一致的部分。（`README.md:11`, `README.md:99-139`, `README.md:168-181`, `README.md:386-426`, `README.md:456-478`）
- [x] 更新 FRIEND_TESTING.md 的测试步骤和反馈模板。（`FRIEND_TESTING.md:3-19`, `FRIEND_TESTING.md:23-30`, `FRIEND_TESTING.md:75-96`, `FRIEND_TESTING.md:100-127`）
- [x] 确认 RELEASE_CHECKLIST.md 和 release readiness script 仍可用。（`RELEASE_CHECKLIST.md:9-38`, `RELEASE_CHECKLIST.md:112-141`, `Scripts/check-release-readiness.sh:18-25`, `Scripts/check-release-readiness.sh:122-235`, `Scripts/check-release-readiness.sh v0.10.0 /private/tmp/JoyBridgeNewPackage-v0.10.0/JoyBridge-new.app`：退出码 0，8 个本地测试预期 warning）
- [x] 确认 `.gitignore` 排除 build、dist、DerivedData、.DS_Store、xcuserdata。（`.gitignore:1-9`，逐项 grep 均为 `OK`）
- [x] 准备用户验收清单。（本文件 `User Acceptance Checklist`）

## Acceptance

- 构建命令通过，或失败原因被清楚记录。
- 朋友测试说明和 App 当前行为一致。
- 发布准备检查脚本可以运行，预期 warning 被记录。
- 用户可以按清单完成一轮手动测试。

## Notes

本 phase 不做正式 Developer ID 签名、公证、App Store 或自动更新。

环境备注：当前 shell 的默认 `xcode-select` 指向 CommandLineTools，裸跑 `xcodebuild` 会失败；脚本和验证命令使用 `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`。`Scripts/check-release-readiness.sh` 已在 Xcode 存在时自动设置该环境变量。

发布准备检查预期 warning：当前工作区未提交、HEAD 未打 `v0.10.0` tag、没有 Developer ID Application 证书、未设置 `JOYBRIDGE_NOTARY_PROFILE`、本地测试包不是 Developer ID 签名、带 `get-task-allow=true`、Gatekeeper 未接受、没有 stapled 公证票据。这些都符合“本地朋友测试，不做正式公证发布”的本 phase 边界。

本地打包验证：`Scripts/package-local-release.sh v0.10.0` 成功，生成 `dist/JoyBridge-new-v0.10.0-local-test.zip`。`zipinfo -1` 确认包内包含 `JoyBridge-new.app`、`README.md`、`FRIEND_TESTING.md`、`RELEASE_CHECKLIST.md`、`CHANGELOG.md`、`READ-ME-FIRST.txt` 和 `Scripts/check-release-readiness.sh`。

只读 QA 子智能体已完成 Phase 05 文档/脚本一致性检查并关闭。它指出的 `JoyBridge-new` 操作文案和 `/Users/hugh/Applications/JoyBridge-new.app` 路径说明已修正。

## User Acceptance Checklist

- 打开 `README.md`，确认本地测试包名是 `JoyBridge-new-v0.10.0-local-test.zip`，App 名是 `JoyBridge-new.app`，bundle id 是 `cc.afterlight.JoyBridgeNew`。
- 打开 `FRIEND_TESTING.md`，按“快速安装 / 手柄设置 / 建议测试什么 / 如果遇到问题”读一遍，确认朋友能照着做。
- 确认 `dist/JoyBridge-new-v0.10.0-local-test.zip` 可以作为朋友测试包。
- 如需检查当前 Hugh 本机稳定副本，运行 `Scripts/check-release-readiness.sh v0.10.0 /Users/hugh/Applications/JoyBridge-new.app`；如朋友安装到系统应用程序目录，则检查 `/Applications/JoyBridge-new.app`。
- 手动打开 JoyBridge-new，完成一轮：授权检查、重新检测手柄、锁定当前、按键映射、暂停/启用、复制诊断信息。

## Evidence

- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -list -project JoyBridge.xcodeproj`：target/scheme `JoyBridge` 可见。
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project JoyBridge.xcodeproj -scheme JoyBridge -configuration Debug -destination 'platform=macOS' build`：`BUILD SUCCEEDED`。
- `Scripts/run-domain-tests.sh`：`DomainMappingTests passed`。
- `bash -n Scripts/check-release-readiness.sh && bash -n Scripts/package-local-release.sh`：`shell-syntax-ok`。
- `Scripts/check-release-readiness.sh v0.10.0 /private/tmp/JoyBridgeNewPackage-v0.10.0/JoyBridge-new.app`：退出码 0，8 个本地测试预期 warning。
- `Scripts/package-local-release.sh v0.10.0`：`BUILD SUCCEEDED`，输出 `dist/JoyBridge-new-v0.10.0-local-test.zip`。
- `zipinfo -1 dist/JoyBridge-new-v0.10.0-local-test.zip`：包含 `JoyBridge-new.app` 和测试文档。
- `codesign --verify --deep --strict --verbose=2 /private/tmp/JoyBridgeNewPackage-v0.10.0/JoyBridge-new.app`：`valid on disk`，满足 Designated Requirement。
- `git diff --check`：无输出，未发现 whitespace 问题。
