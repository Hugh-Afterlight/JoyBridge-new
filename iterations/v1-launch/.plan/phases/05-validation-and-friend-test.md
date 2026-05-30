# Phase 05 · validation-and-friend-test

Status: pending

## Goal

完成构建验证、朋友测试资料同步和本地发布路径检查，让重构版可以进入小范围测试。

## Tasks

- [ ] 跑 `xcodebuild -list -project JoyBridge.xcodeproj`。
- [ ] 跑 Debug build。
- [ ] 如已新增测试 target，跑测试。
- [ ] 更新 README 中和重构行为不一致的部分。
- [ ] 更新 FRIEND_TESTING.md 的测试步骤和反馈模板。
- [ ] 确认 RELEASE_CHECKLIST.md 和 release readiness script 仍可用。
- [ ] 确认 `.gitignore` 排除 build、dist、DerivedData、.DS_Store、xcuserdata。
- [ ] 准备用户验收清单。

## Acceptance

- 构建命令通过，或失败原因被清楚记录。
- 朋友测试说明和 App 当前行为一致。
- 发布准备检查脚本可以运行，预期 warning 被记录。
- 用户可以按清单完成一轮手动测试。

## Notes

本 phase 不做正式 Developer ID 签名、公证、App Store 或自动更新。
