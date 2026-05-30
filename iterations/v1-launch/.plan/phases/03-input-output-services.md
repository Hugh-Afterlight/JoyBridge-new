# Phase 03 · input-output-services

Status: completed

## Goal

解耦手柄输入、目标过滤、映射执行、键盘输出和权限检查，让输入链路按 ARCHITECTURE 中的边界运行。

## Tasks

- [x] 定义标准化 Controller input event。（`JoyBridge/Models/ControllerInputEvent.swift:3-14`, `Tests/DomainMappingTests.swift:142-154`）
- [x] 抽出 TargetController 过滤规则。（`JoyBridge/Services/TargetControllerRule.swift:3-13`, `Tests/DomainMappingTests.swift:156-176`）
- [x] 让 Controller 输入层不直接调用 MappingManager 或 KeyboardEventSender。（`JoyBridge/Managers/ControllerManager.swift:59-60`, `JoyBridge/Managers/ControllerManager.swift:555-602`, `JoyBridge/JoyBridgeApp.swift:15-17`）
- [x] 抽出 MappingService，负责从 ControllerButton 得到 MappingAction。（`JoyBridge/Services/MappingService.swift:3-56`, `Tests/DomainMappingTests.swift:178-239`）
- [x] 抽出 KeyboardOutputService，负责 CGEvent 输出。（`JoyBridge/Services/KeyboardOutputService.swift:3-14`, `JoyBridge/Managers/MappingManager.swift:12-25`）
- [x] 保证 Accessibility 未授权、映射暂停、映射禁用、无动作都不会输出键盘事件。（`JoyBridge/Services/MappingService.swift:33-51`, `Tests/DomainMappingTests.swift:241-286`）
- [x] 保证 modifier hold 在暂停、退出、映射变更时释放。（`JoyBridge/Managers/MappingManager.swift:40-42`, `JoyBridge/Managers/MappingManager.swift:71-109`, `Tests/DomainMappingTests.swift:288-333`）

## Acceptance

- 锁定目标后只接受目标手柄输入。
- 目标手柄不在线时不自动切换到其他手柄。
- 暂停时最近按键仍更新，但键盘事件不发送。
- 退出前释放已按下 modifier。
- 核心服务边界有测试或可观察验证。

## Notes

GameController 的硬件兼容限制只诊断，不承诺修复所有设备差异。

子智能体只读审查指出的高风险点已纳入验证：暂停不能阻止最近按键更新、目标手柄不在线不能 fallback、modifier cleanup 不能被权限判断挡住。子智能体已关闭释放资源。

验收反馈：用户发现系统设置里 `JoyBridge-new` 已开启，但 App 内仍显示未授权。检查后确认 Debug 构建原本使用 ad-hoc 临时签名，已改为稳定 Apple Development 签名，避免 macOS Accessibility 授权绑定到不稳定签名身份。

用户验收：2026-05-31 用户确认授权、映射、暂停恢复、目标控制器锁定相关行为“都可以”，Phase 03 验收通过。

## Evidence

- `Scripts/run-domain-tests.sh`：`DomainMappingTests passed`。
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project JoyBridge.xcodeproj -scheme JoyBridge -configuration Debug -destination 'platform=macOS' build`：`BUILD SUCCEEDED`。
- `git diff --check`：无输出，未发现 whitespace 问题。
- `rg -n "MappingManager|KeyboardEventSender|keyboardEventSender|handleButtonPress|handleButtonRelease|releaseAllHeldModifiers" JoyBridge/Managers/ControllerManager.swift`：无输出，Controller 输入层不再直接依赖映射管理器或键盘输出器。
- `codesign -dv --verbose=4 <Debug/JoyBridge-new.app>`：`Authority=Apple Development: yueyueba2022@163.com (32WU4499CJ)`, `TeamIdentifier=XUBA4RHJ7A`。
