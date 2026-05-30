# Phase 02 · domain-and-store

Status: completed

## Goal

把 JoyBridge 的核心映射规则从现有 manager 逻辑中抽出来，形成可测试的领域模型和持久化边界。

## Tasks

- [x] 梳理现有 `ControllerButton`、`KeyMapping`、`MappingAction`、`KeyboardKey`、`KeyModifier` 的职责。(JoyBridge/Models/ControllerButton.swift:3, JoyBridge/Models/KeyMapping.swift:3, JoyBridge/Models/MappingAction.swift:3, JoyBridge/Models/KeyboardKey.swift:4, JoyBridge/Models/KeyModifier.swift:4)
- [x] 引入或整理 `MappingProfile`，本轮只使用单默认 profile。(JoyBridge/Models/MappingProfile.swift:3-53)
- [x] 定义 `MappingStore` 协议。(JoyBridge/Persistence/MappingStore.swift:3-11)
- [x] 实现 `UserDefaultsMappingStore`。(JoyBridge/Persistence/UserDefaultsMappingStore.swift:8-79)
- [x] 让默认映射、规范化、启用状态和无动作规则集中到领域层。(JoyBridge/Models/MappingCatalog.swift:3-47, JoyBridge/Managers/MappingManager.swift:9-42)
- [x] 新增 `JoyBridgeTests` target 或等价测试入口。(Scripts/run-domain-tests.sh:1-24, Tests/DomainMappingTests.swift:3-157)
- [x] 覆盖单键、组合键、纯修饰键、none、modifier 去重、默认映射补齐。(Tests/DomainMappingTests.swift:16-134, command: `Scripts/run-domain-tests.sh`)
- [x] 按用户要求把重构版 App 独立命名为 `JoyBridge-new`，避免和旧 JoyBridge 的辅助功能授权记录混在一起。(JoyBridge.xcodeproj/project.pbxproj:10, JoyBridge/Utilities/AppIdentity.swift:3, command: `xcodebuild ... build`)

## Acceptance

- Mapping 相关规则能在不启动 App UI 的情况下测试。
- UserDefaults 只出现在持久化实现中，不散落在业务逻辑里。
- 现有默认映射和 README 描述保持一致。
- `xcodebuild` 构建通过；如测试 target 已加入，测试通过。

## Notes

不要在本 phase 改 UI 结构。UI 只在必要时适配编译错误。

本 phase 采用脚本化测试入口，没有手改 `.xcodeproj` 增加 XCTest target，原因是当前项目使用 Xcode 文件夹同步，脚本测试能覆盖纯领域逻辑且更少触碰 project 文件。后续如果需要 Xcode Test navigator 集成，可在单独 phase 里补 `JoyBridgeTests` target。

验证：

- `Scripts/run-domain-tests.sh` 通过。
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project JoyBridge.xcodeproj -scheme JoyBridge -configuration Debug -destination 'platform=macOS' build` 通过。
- 构建时有 CoreSimulator 版本偏旧 warning，但 macOS Debug build 成功。
- 用户反馈不想清除旧 JoyBridge 授权记录，因此重构版已改为独立 App 身份：显示名 `JoyBridge-new`，bundle id `cc.afterlight.JoyBridgeNew`。旧 JoyBridge 可以保留在系统辅助功能列表中。
- 用户已实机验收：`JoyBridge-new` 可以获得辅助功能授权，手柄映射有效。
