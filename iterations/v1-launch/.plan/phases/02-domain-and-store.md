# Phase 02 · domain-and-store

Status: pending

## Goal

把 JoyBridge 的核心映射规则从现有 manager 逻辑中抽出来，形成可测试的领域模型和持久化边界。

## Tasks

- [ ] 梳理现有 `ControllerButton`、`KeyMapping`、`MappingAction`、`KeyboardKey`、`KeyModifier` 的职责。
- [ ] 引入或整理 `MappingProfile`，本轮只使用单默认 profile。
- [ ] 定义 `MappingStore` 协议。
- [ ] 实现 `UserDefaultsMappingStore`。
- [ ] 让默认映射、规范化、启用状态和无动作规则集中到领域层。
- [ ] 新增 `JoyBridgeTests` target 或等价测试入口。
- [ ] 覆盖单键、组合键、纯修饰键、none、modifier 去重、默认映射补齐。

## Acceptance

- Mapping 相关规则能在不启动 App UI 的情况下测试。
- UserDefaults 只出现在持久化实现中，不散落在业务逻辑里。
- 现有默认映射和 README 描述保持一致。
- `xcodebuild` 构建通过；如测试 target 已加入，测试通过。

## Notes

不要在本 phase 改 UI 结构。UI 只在必要时适配编译错误。
