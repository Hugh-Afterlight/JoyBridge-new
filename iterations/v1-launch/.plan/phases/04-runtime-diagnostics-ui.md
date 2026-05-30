# Phase 04 · runtime-diagnostics-ui

Status: completed

## Goal

把运行状态、诊断信息、主窗口和菜单栏体验整理成 PRD/DESIGN 规定的单窗口流程。

## Tasks

- [x] 定义 `RuntimeState` 或等价聚合状态。（`JoyBridge/Models/RuntimeState.swift:54-146`, `Tests/DomainMappingTests.swift:337-386`）
- [x] 定义 `DiagnosticReport` 和 `DiagnosticsService`。（`JoyBridge/Diagnostics/DiagnosticReport.swift:3-44`, `JoyBridge/Diagnostics/DiagnosticsService.swift:4-53`）
- [x] 让诊断信息包含 PRD 要求的关键字段。（`JoyBridge/Diagnostics/DiagnosticReport.swift:5-19`, `JoyBridge/Managers/ControllerManager.swift:39`, `JoyBridge/Managers/MappingManager.swift:8`）
- [x] 重整主窗口顺序：总状态、运行检查、权限、手柄、映射、运行控制、诊断。（`JoyBridge/ContentView.swift:10-54`）
- [x] 抽出可复用 SwiftUI 组件：状态 chip、section panel、key chip、诊断 panel。（`JoyBridge/Views/RuntimeUIComponents.swift:3-95`, `JoyBridge/Views/MappingRowView.swift:29-89`）
- [x] 菜单栏加入复制诊断信息。（`JoyBridge/JoyBridgeApp.swift:133-173`）
- [x] 按 CONTENT.md 统一 UI 文案。（`rg -n '控制器|调试提示' JoyBridge/ContentView.swift JoyBridge/JoyBridgeApp.swift JoyBridge/Views JoyBridge/Models/RuntimeState.swift JoyBridge/Diagnostics`：无输出）

## Acceptance

- 用户打开 App 第一屏能看懂当前能不能用。
- 所有关键状态都有下一步提示。
- 诊断信息可复制且字段稳定。
- 菜单栏可以暂停/启用、显示窗口、重检、复制诊断、退出。
- UI 符合 DESIGN.md 的 native macOS utility 气质。

## Notes

不要把诊断区藏进深层设置页。本轮仍保持单窗口。

实现备注：本 phase 将运行状态、下一步提示、权限、手柄、映射、暂停/启用和诊断复制整理到同一个主窗口流程；菜单栏也同步提供暂停/启用、显示窗口、重检、复制诊断和退出。终端截图命令 `screencapture -x /tmp/joybridge-phase04.png` 因当前会话无法从显示器创建图片失败，视觉验收留给用户在本机窗口中确认。

用户验收：2026-05-31 用户确认“可以，继续”，Phase 04 验收通过。

## Evidence

- `Scripts/run-domain-tests.sh`：`DomainMappingTests passed`。
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project JoyBridge.xcodeproj -scheme JoyBridge -configuration Debug -destination 'platform=macOS' build`：`BUILD SUCCEEDED`。
- `git diff --check`：无输出，未发现 whitespace 问题。
- `codesign --verify --deep --strict --verbose=2 "$HOME/Applications/JoyBridge-new.app"`：`valid on disk`，满足 Designated Requirement。
- `codesign -dv --verbose=4 "$HOME/Applications/JoyBridge-new.app"`：`Identifier=cc.afterlight.JoyBridgeNew`，`Authority=Apple Development: yueyueba2022@163.com (32WU4499CJ)`，`TeamIdentifier=XUBA4RHJ7A`。
- `pgrep -fl 'JoyBridge-new'`：运行路径为 `/Users/hugh/Applications/JoyBridge-new.app/Contents/MacOS/JoyBridge-new`。
