# Phase 04 · runtime-diagnostics-ui

Status: pending

## Goal

把运行状态、诊断信息、主窗口和菜单栏体验整理成 PRD/DESIGN 规定的单窗口流程。

## Tasks

- [ ] 定义 `RuntimeState` 或等价聚合状态。
- [ ] 定义 `DiagnosticReport` 和 `DiagnosticsService`。
- [ ] 让诊断信息包含 PRD 要求的关键字段。
- [ ] 重整主窗口顺序：总状态、运行检查、权限、手柄、映射、运行控制、诊断。
- [ ] 抽出可复用 SwiftUI 组件：状态 chip、section panel、key chip、诊断 panel。
- [ ] 菜单栏加入复制诊断信息。
- [ ] 按 CONTENT.md 统一 UI 文案。

## Acceptance

- 用户打开 App 第一屏能看懂当前能不能用。
- 所有关键状态都有下一步提示。
- 诊断信息可复制且字段稳定。
- 菜单栏可以暂停/启用、显示窗口、重检、复制诊断、退出。
- UI 符合 DESIGN.md 的 native macOS utility 气质。

## Notes

不要把诊断区藏进深层设置页。本轮仍保持单窗口。
