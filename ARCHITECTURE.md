# JoyBridge · ARCHITECTURE

> 本文档是 JoyBridge 重构版的技术架构规格。它把 BRIEF、PRD、DESIGN 落到具体工程决策。原仓库 `Hugh-Afterlight/JoyBridge` 只读参考；本仓库 `Hugh-Afterlight/JoyBridge-Refactor` 承接全部重构工作。

## 技术栈一句话

JoyBridge 继续使用原生 macOS 技术栈：Swift + SwiftUI + AppKit + GameController.framework + CoreGraphics CGEvent，不引入 Electron、Tauri、Python、Node.js 或新的运行时框架。

选择这条路线的原因很简单：JoyBridge 的核心能力依赖 macOS 权限、系统输入事件、手柄框架和菜单栏生命周期，原生实现最稳定，也最少引入额外复杂度。

## 项目类型与运行环境

- 平台：macOS App。
- 最低系统：macOS 13，保持与原 README 一致。
- 推荐开发环境：Xcode 16 或更高版本。
- 语言：Swift。
- UI：SwiftUI 为主，必要时使用 AppKit 管理 App 生命周期、窗口和菜单栏行为。
- 系统框架：GameController.framework、CoreGraphics、ApplicationServices。
- 依赖策略：本轮不新增第三方依赖。只有当系统框架无法满足需求时，才先更新本文件并说明取舍。

## 架构分层

本轮重构目标不是大规模改名，而是让每个目录的责任清楚。可以保留现有 `Managers`、`Models`、`Utilities`、`Views` 作为过渡，但代码含义必须逐步向下面六层收敛：

| 层 | 职责 | 示例 |
|---|---|---|
| Presentation | 展示状态，接收用户操作 | SwiftUI Views、MenuBar View |
| Application | 编排用例，不碰系统底层细节 | LockTargetControllerUseCase、UpdateMappingUseCase |
| Domain | 纯业务模型和规则 | ControllerButton、KeyMapping、MappingAction、MappingProfile |
| Infrastructure | macOS 系统能力适配 | GameController adapter、CGEvent sender、Accessibility checker |
| Persistence | 本地状态读写 | UserDefaultsMappingStore，未来 JSONMappingStore |
| Diagnostics | 收集状态并生成诊断文本 | ReadinessState、DiagnosticReport、DiagnosticsService |

## 核心链路

本轮所有代码都围绕这条链路组织：

`ControllerDevice -> ControllerInput -> ControllerButton -> TargetControllerRule -> KeyMapping -> MappingAction -> KeyboardOutput -> DiagnosticReport`

关键规则：

- Controller 输入层只负责识别设备和标准化按键，不直接发送键盘事件。
- TargetControllerRule 决定某次输入是否被接受。
- MappingService 根据 ControllerButton 找到 MappingAction。
- KeyboardOutputService 只负责把 MappingAction 输出成系统键盘事件。
- DiagnosticsService 只读状态，不改变业务状态。
- SwiftUI View 只订阅状态和触发命令，不实现复杂判断。

## 推荐目录结构

重构可以分阶段迁移，不需要一次性移动所有文件。目标结构如下：

```text
JoyBridge/
  App/
    JoyBridgeApp.swift
    AppDelegate.swift
    MenuBar/
  Presentation/
    Views/
    Components/
    DesignSystem/
  Application/
    Services/
    UseCases/
    State/
  Domain/
    Controllers/
    Mappings/
    Runtime/
  Infrastructure/
    GameController/
    KeyboardOutput/
    Accessibility/
  Persistence/
    MappingStore.swift
    UserDefaultsMappingStore.swift
  Diagnostics/
    DiagnosticReport.swift
    DiagnosticsService.swift
  Resources/
    Assets.xcassets/
Scripts/
iterations/
BRIEF.md
DESIGN.md
ARCHITECTURE.md
AGENTS.md
```

如果移动 Xcode 文件导致 `.xcodeproj` 变更过大，可以先在现有目录下按类型新建文件，再在后续 phase 做目录整理。

## 领域模型

本轮必须稳定这些领域对象：

- `ControllerDevice`：被系统识别到的手柄设备。
- `ControllerButton`：JoyBridge 标准化后的按钮，例如 A、B、DPad Up。
- `TargetController`：当前锁定目标手柄，作为输入过滤规则。
- `KeyMapping`：一个按钮到一个动作的映射，是核心业务对象。
- `MappingAction`：键盘单键、纯修饰键、组合键、无动作。
- `KeyboardKey`：可输出的键盘按键。
- `KeyModifier`：Command、Shift、Option、Control。
- `RuntimeState`：暂停、可输出、最近按键、目标状态。
- `PermissionState`：Accessibility 授权状态。
- `DiagnosticReport`：朋友测试和长期维护使用的问题报告。
- `MappingProfile`：本轮只预留单默认 profile，不做可见 UI。

## 持久化策略

本轮继续使用 UserDefaults，原因是数据小、单机使用、无需账号和同步。为了避免未来被 UserDefaults 绑死，需要引入清晰接口：

```swift
protocol MappingStore {
    func loadProfile() throws -> MappingProfile
    func saveProfile(_ profile: MappingProfile) throws
}
```

本轮实现 `UserDefaultsMappingStore`。JSON 导入导出、iCloud、云同步都不做，只保留未来替换点。

## UI 与设计系统落地

DESIGN.md 已定义 JoyBridge 的 macOS utility 气质、颜色、字体、间距和组件 token。实现时不需要使用 Web 的 design token export，而应在 Swift 中建立轻量设计系统：

- `JoyBridgeColor` 或 Asset Catalog 暴露语义颜色。
- `JoyBridgeTextStyle` 暴露标题、正文、说明、等宽文本。
- `StatusChip`、`SectionPanel`、`KeyChip`、`DiagnosticPanel` 做成可复用 SwiftUI 组件。
- 不在 View 内散落十六进制颜色和魔法间距。

UI 优先级和 PRD 一致：运行检查在前，诊断和细节在后。不要做游戏化、霓虹、复杂侧边栏或多层设置页。

## 测试策略

本轮优先补核心逻辑测试，而不是追求 UI 自动化覆盖。

必须覆盖：

- `MappingAction`：单键、组合键、纯修饰键、none。
- `KeyModifier.orderedUnique`：顺序稳定、去重。
- Mapping 规范化：缺失映射补默认，重复映射按按钮合并。
- 暂停行为：暂停时不输出，恢复后可输出。
- TargetControllerRule：锁定目标后只接受目标设备。
- DiagnosticReport：字段稳定，缺失状态有可读 fallback。

建议新增 Xcode test target：`JoyBridgeTests`。不引入 Quick、Nimble 等第三方测试框架，使用 XCTest。

## 构建与验证命令

常用命令：

```bash
xcodebuild -list -project JoyBridge.xcodeproj
xcodebuild -project JoyBridge.xcodeproj -scheme JoyBridge -configuration Debug -destination 'platform=macOS' build
Scripts/check-release-readiness.sh v0.10.0
```

如果新增测试 target，再加入：

```bash
xcodebuild test -project JoyBridge.xcodeproj -scheme JoyBridge -destination 'platform=macOS'
```

本地打包仍使用：

```bash
Scripts/package-local-release.sh v0.10.0
```

## 发布与仓库策略

- 原仓库：`https://github.com/Hugh-Afterlight/JoyBridge`，只读参考。
- 新仓库：`https://github.com/Hugh-Afterlight/JoyBridge-Refactor`，本轮所有重构工作所在仓库。
- 本轮不做 Developer ID 签名和 Apple 公证。
- 保留 `FRIEND_TESTING.md`、`RELEASE_CHECKLIST.md`、`Scripts/check-release-readiness.sh`。
- `dist/`、`DerivedData/`、`build/`、`.DS_Store` 不提交。

## 安全与权限

- Accessibility 权限必须始终显式展示，不假设用户已经授权。
- 诊断信息不能包含隐私敏感内容或系统 token。
- App 路径用于排查授权错误，但不要收集或上传。
- 键盘事件发送前必须检查权限和暂停状态。
- 退出 App 前必须释放仍处于按下状态的 modifier。

## 风险与取舍

- GameController.framework 对不同手柄暴露的按键不同，JoyBridge 只能清楚诊断，不能承诺所有硬件模式都可用。
- Xcode project 文件手改风险较高，新增测试 target 时要小步修改并立即跑 `xcodebuild -list`。
- 如果一次性大规模移动目录，容易引入 project reference 错误，因此目录重构应分 phase。
- 本轮不新增依赖，短期会牺牲一些开发便利，但对 MVP 重构更稳。

## 开发前检查

- [ ] 确认当前 remote 指向 `JoyBridge-Refactor`，不是原仓库。
- [ ] 阅读 `BRIEF.md`、`iterations/v1-launch/PRD.md`、`DESIGN.md`、本文件。
- [ ] 阅读 `iterations/v1-launch/.plan/plan.md` 和当前 phase 文档。
- [ ] 跑 `xcodebuild -list -project JoyBridge.xcodeproj`。
- [ ] 做代码修改前确认本 phase 的验收标准。
