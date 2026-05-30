---
version: alpha
name: JoyBridge
description: "Native macOS controller-to-keyboard mapping tool design system for AI implementation."
colors:
  primary: "#0057D9"
  primaryHover: "#004EBD"
  primaryContainer: "#E8F1FF"
  onPrimary: "#FFFFFF"
  background: "#F5F6F8"
  surface: "#FFFFFF"
  surfaceSecondary: "#EEF1F5"
  surfaceElevated: "#FFFFFF"
  textPrimary: "#1D1D1F"
  textSecondary: "#6E6E73"
  textTertiary: "#8A8A8E"
  border: "#D6D6D8"
  divider: "#E5E5EA"
  success: "#007A2F"
  successContainer: "#E9F8EE"
  warning: "#8A4B00"
  warningContainer: "#FFF4E3"
  error: "#B00020"
  errorContainer: "#FEEDEE"
  paused: "#6E6E73"
  diagnostic: "#5856D6"
  focusRing: "#0A84FF"
  codeBackground: "#F0F2F5"
  keycapBackground: "#ECEFF3"
  darkBackground: "#1C1C1E"
  darkSurface: "#2C2C2E"
  darkSurfaceSecondary: "#3A3A3C"
  darkTextPrimary: "#F5F5F7"
  darkTextSecondary: "#C7C7CC"
  darkBorder: "#3A3A3C"
typography:
  h1:
    fontFamily: "SF Pro Display, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 24px
    fontWeight: 700
    lineHeight: 1.25
    letterSpacing: -0.02em
  h2:
    fontFamily: "SF Pro Display, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 18px
    fontWeight: 650
    lineHeight: 1.35
    letterSpacing: -0.01em
  h3:
    fontFamily: "SF Pro Text, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 15px
    fontWeight: 600
    lineHeight: 1.45
    letterSpacing: 0em
  bodyLg:
    fontFamily: "SF Pro Text, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 15px
    fontWeight: 400
    lineHeight: 1.55
    letterSpacing: 0em
  bodyMd:
    fontFamily: "SF Pro Text, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.55
    letterSpacing: 0em
  bodySm:
    fontFamily: "SF Pro Text, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: 0em
  labelMd:
    fontFamily: "SF Pro Text, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 13px
    fontWeight: 600
    lineHeight: 1.25
    letterSpacing: 0em
  labelSm:
    fontFamily: "SF Pro Text, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 12px
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: 0.01em
  caption:
    fontFamily: "SF Pro Text, PingFang SC, -apple-system, BlinkMacSystemFont, system-ui, sans-serif"
    fontSize: 11px
    fontWeight: 400
    lineHeight: 1.35
    letterSpacing: 0.01em
  mono:
    fontFamily: "SF Mono, Menlo, Monaco, Consolas, monospace"
    fontSize: 12px
    fontWeight: 500
    lineHeight: 1.45
    letterSpacing: 0em
rounded:
  none: 0px
  xs: 4px
  sm: 6px
  md: 8px
  lg: 10px
  xl: 14px
  full: 9999px
spacing:
  micro: 2px
  xxs: 4px
  xs: 6px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  xxl: 32px
  section: 40px
  window: 24px
  gutter: 16px
  row: 10px
  gridColumns: 12
components:
  window:
    backgroundColor: "{colors.background}"
    textColor: "{colors.textPrimary}"
    typography: "{typography.bodyMd}"
    rounded: "{rounded.none}"
    padding: "{spacing.window}"
    width: 880px
  sectionCard:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.textPrimary}"
    typography: "{typography.bodyMd}"
    rounded: "{rounded.xl}"
    padding: "{spacing.xl}"
  readinessPanel:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.textPrimary}"
    typography: "{typography.bodyMd}"
    rounded: "{rounded.xl}"
    padding: "{spacing.xl}"
  statusChipReady:
    backgroundColor: "{colors.successContainer}"
    textColor: "{colors.success}"
    typography: "{typography.labelSm}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs}"
  statusChipWarning:
    backgroundColor: "{colors.warningContainer}"
    textColor: "{colors.warning}"
    typography: "{typography.labelSm}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs}"
  statusChipError:
    backgroundColor: "{colors.errorContainer}"
    textColor: "{colors.error}"
    typography: "{typography.labelSm}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs}"
  statusChipPaused:
    backgroundColor: "{colors.surfaceSecondary}"
    textColor: "{colors.paused}"
    typography: "{typography.labelSm}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs}"
  buttonPrimary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.onPrimary}"
    typography: "{typography.labelMd}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
    height: 32px
  buttonSecondary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.labelMd}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
    height: 32px
  buttonDestructive:
    backgroundColor: "{colors.error}"
    textColor: "{colors.onPrimary}"
    typography: "{typography.labelMd}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
    height: 32px
  buttonQuiet:
    backgroundColor: "{colors.surfaceSecondary}"
    textColor: "{colors.textSecondary}"
    typography: "{typography.labelMd}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
    height: 32px
  mappingRow:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.textPrimary}"
    typography: "{typography.bodyMd}"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
    height: 56px
  keyChip:
    backgroundColor: "{colors.keycapBackground}"
    textColor: "{colors.textPrimary}"
    typography: "{typography.mono}"
    rounded: "{rounded.sm}"
    padding: "{spacing.sm}"
  permissionCallout:
    backgroundColor: "{colors.warningContainer}"
    textColor: "{colors.warning}"
    typography: "{typography.bodyMd}"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
  diagnosticPanel:
    backgroundColor: "{colors.codeBackground}"
    textColor: "{colors.textSecondary}"
    typography: "{typography.mono}"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
---

# JoyBridge DESIGN.md

## Overview

JoyBridge 的界面目标是让个人 Mac 用户在一个窗口内完成三件事：确认当前能不能用、配置手柄按钮到键盘动作的映射、在出问题时复制足够清楚的诊断信息。

产品气质应为 **native macOS utility**，也就是安静、可信、紧凑、状态清晰。它不是游戏工具，也不是复杂自动化平台。视觉上不要追求游戏化、赛博风、霓虹风或大面积装饰。用户打开 App 后应立刻理解：JoyBridge 正在监听哪只手柄、是否已授权、是否已锁定目标手柄、映射是否会输出键盘事件。

核心体验原则：

- **状态优先**：界面第一屏必须优先回答“现在能不能用”和“下一步做什么”。
- **安全优先**：目标手柄锁定是输入链路规则，不是普通 UI 装饰。未锁定或目标不在线时必须明确提示。
- **单窗口渐进式披露**：不使用复杂侧边栏、不使用多层设置页、不把诊断藏到深层菜单。
- **领域对象清晰**：映射编辑必须围绕 Source、Action、State 三个概念，不要把它实现成一次性表单。
- **原生优先**：使用 SwiftUI 和必要的 AppKit，保持 macOS 系统工具的熟悉感。

JoyBridge 的核心信息链路为：

`ControllerDevice -> ControllerInput -> ControllerButton -> KeyMapping -> MappingAction -> KeyboardOutput -> DiagnosticReport`

任何新增 UI 都必须能映射到这条链路中的某一段。如果不能映射，默认不应加入本轮重构。

## Colors

颜色使用语义 token，不要在 SwiftUI View 中硬编码十六进制颜色。实现时应通过 Asset Catalog 或集中式 `Color` extension 暴露这些 token。

**主色 Primary**

`primary #0057D9` 用于当前页面最重要的操作，例如“打开系统设置”“锁定当前手柄”“启用映射”。每个区域最多只能有一个主按钮。主色不要用于普通图标、普通文字或背景装饰。

**背景与表面**

`background #F5F6F8` 是主窗口背景。`surface #FFFFFF` 是卡片、列表和面板背景。`surfaceSecondary #EEF1F5` 用于次级按钮、分组底色、disabled 区域。界面应通过浅背景、卡片边框和少量阴影建立层级，而不是通过高饱和色块建立层级。

**文本**

`textPrimary #1D1D1F` 用于标题和正文。`textSecondary #6E6E73` 用于说明、路径、元信息。`textTertiary #8A8A8E` 仅用于低优先级辅助说明。不要将 `textTertiary` 用于关键状态或按钮。

**状态色**

- `success #007A2F`：可用、已授权、已锁定、映射输出正常。
- `warning #8A4B00`：需要用户处理但 App 未崩溃，例如未连接手柄、未锁定目标、目标手柄离线、映射已暂停。
- `error #B00020`：明确阻断当前功能的状态，例如 Accessibility 未授权导致无法输出键盘事件。
- `paused #6E6E73`：暂停状态。暂停不是错误，不要用红色表达。
- `diagnostic #5856D6`：仅用于诊断入口、复制诊断成功提示或诊断图标。

**深色模式**

深色模式必须使用 `darkBackground`、`darkSurface`、`darkTextPrimary`、`darkTextSecondary`、`darkBorder` 等 token。不要简单反转浅色模式。状态色在深色模式中仍使用语义角色，但背景容器应提高透明度或使用更深的 tonal surface，避免发光感。

**禁用规则**

- 不要用红色表示“未锁定手柄”。这属于 warning，不是 fatal error。
- 不要用绿色表示“连接了任意手柄”。只有满足输出条件时才能显示整体 ready。
- 不要只用颜色表达状态。每个状态必须同时有图标、文本和必要说明。

## Typography

JoyBridge 使用系统字体。SwiftUI 实现时优先使用系统语义字体，如 `.title2`、`.headline`、`.body`，并通过 ViewModifier 对齐本文件中的尺寸和权重。不要引入外部字体文件。

**H1**

用于主窗口标题。字号 24px，字重 700。只用于“JoyBridge”和极少量页面级标题。一个窗口内最多一个 H1。

**H2**

用于主要分区标题，例如“运行检查”“辅助功能权限”“手柄与目标锁定”“映射列表”“诊断信息”。字号 18px，字重 650。

**H3**

用于卡片内的小标题，例如“当前手柄”“目标手柄”“最近按键”“映射输出”。字号 15px，字重 600。

**Body**

正文默认使用 13px。说明性段落可以使用 13px 或 12px，但不要低于 11px。长说明需要控制在 1 到 2 行，复杂说明放入诊断或帮助文本，不要堆在主界面。

**Label**

按钮、状态 chip、表格列标题使用 12px 到 13px，字重 600。状态 chip 文案必须短，例如“可用”“需要授权”“已暂停”“未检测到手柄”。

**Monospace**

键名、快捷键、App 路径、Bundle ID、诊断字段使用 `SF Mono`。键盘动作显示为 key chip，例如 `Command`、`Shift`、`C`，不要只用纯文本串。

**中英文混排**

界面说明文本以中文为主。键盘按键、手柄按钮和系统框架名可以保留英文，例如 `A`、`DPad Up`、`Command + C`、`GameController.framework`。不要将技术名词强行翻译成不常见中文。

## Layout

主窗口采用单窗口纵向分区，不使用左侧导航栏，不使用多 Tab，不使用多层设置页。默认窗口宽度 880px，建议最小宽度 760px，最大内容宽度 1040px。窗口内容放入垂直 `ScrollView`，主内容左右 padding 为 24px，分区间距为 24px 到 32px。

**页面顺序必须固定**

1. AppHeader
2. ReadinessPanel
3. PermissionSection
4. ControllerSection
5. TargetLockSection
6. MappingSection
7. RuntimeControlSection
8. DiagnosticSection

该顺序不得随意调整，因为它对应用户从上到下理解 App 的流程：能不能用、缺什么、怎么连接、怎么锁定、怎么映射、怎么暂停、怎么排查。

**网格**

主内容可以使用 12 列概念网格，但视觉上仍然是纵向单窗口。默认 gutter 为 16px。

- 宽度小于 720px：所有卡片单列堆叠。
- 宽度 720px 到 899px：主分区单列，Readiness 状态项可以 2 列。
- 宽度大于等于 900px：Readiness 状态项使用 4 列或 2x2，Controller 与 TargetLock 可以并排，MappingList 仍保持单列列表。

**MappingRow 内部列**

当窗口宽度大于等于 820px 时，映射行使用 4 列：

- Source：160px，显示手柄按钮。
- Action：自适应，显示键盘动作编辑器。
- State：120px，显示启用、默认值、无动作等状态。
- Controls：160px，显示恢复默认、更多操作。

当窗口宽度小于 820px 时，MappingRow 改为两行布局：第一行显示 Source 与 State，第二行显示 Action 与 Controls。

**密度**

JoyBridge 是桌面工具，可以比营销页面更紧凑，但不能拥挤。每个主要卡片内部 padding 为 24px。列表行高度不低于 56px。按钮高度为 32px。图标和文字间距为 8px。

**滚动**

主窗口内容可以滚动。AppHeader 不需要 sticky。不要让 MappingList 自己独立滚动，除非主窗口高度小于 640px。避免嵌套滚动。

## Elevation & Depth

JoyBridge 采用低阴影、强边框、轻 tonal layer 的 macOS 工具风格。不要使用 Material Design 式的大阴影层级。

**Depth 0**

窗口背景、普通列表背景。无阴影。

**Depth 1**

主要卡片、状态面板、映射行。使用 1px border `border #D6D6D8`，可选阴影为 `0 1px 2px rgba(0,0,0,0.04)`。这是主界面默认深度。

**Depth 2**

Popover、菜单浮层、小型确认浮层。使用 `0 8px 24px rgba(0,0,0,0.14)`。只用于临时浮层，不用于主卡片。

**Depth 3**

Modal sheet 或系统级阻断提示。使用 `0 16px 40px rgba(0,0,0,0.18)`。本轮不建议新增复杂 modal。

**禁用规则**

- 不要用阴影表达状态。
- 不要给每个按钮加阴影。
- 不要让卡片漂浮感强于 macOS 原生窗口层级。
- 不要用玻璃拟态作为主风格。可以兼容未来 macOS 视觉变化，但本轮默认保持稳定的实用工具风格。

## Shapes

圆角语言应统一、克制、偏工具型。

- 主卡片：14px。
- 信息行和映射行：10px。
- 按钮、输入框、Picker 容器：8px。
- Key chip 和小标签：6px。
- 状态 chip：9999px pill。
- 分割线和列表边界：直线，不要做波浪、斜切或装饰形状。

不要在同一层级混用大圆角和直角。不要使用夸张圆角让 App 看起来像移动端卡片流。JoyBridge 是 macOS 桌面工具，视觉上应更稳定和紧凑。

## Components

所有组件都应是可复用 SwiftUI View 或 ViewModifier。SwiftUI View 不应直接调用 GameController、CGEvent 或 Accessibility 系统 API。View 只消费 ViewState，用户操作通过 Application 层 use case 触发。

**AppHeader**

用途：显示 App 名称、版本、整体运行状态、复制诊断入口。

内容：

- 左侧：App icon、`JoyBridge`、版本号。
- 右侧：整体状态 chip、`复制诊断信息` 次级按钮。
- 整体状态优先级：未授权 > 已暂停 > 目标手柄离线 > 未检测到手柄 > 建议锁定 > 可用。

**ReadinessPanel**

用途：第一屏告诉用户当前能不能用，以及下一步做什么。

必须包含 4 个状态项：

- Accessibility 权限。
- 手柄连接。
- 目标手柄锁定。
- 映射输出状态。

每个状态项使用 ReadinessRow。状态项必须有图标、标题、当前状态、说明、可选操作按钮。不要只显示勾叉图标。

**ReadinessRow**

状态结构：

- `ready`：绿色，文案为“已就绪”或“正常”。
- `warning`：橙色，文案为“需要处理”。
- `blocked`：红色，文案为“无法输出”。
- `paused`：灰色，文案为“已暂停”。

当状态有明确下一步时，行尾显示一个操作按钮。例如 Accessibility 未授权时显示“打开系统设置”，未检测到手柄时显示“重新检测手柄”。

**PermissionSection**

用途：处理 Accessibility 辅助功能权限。

必须显示：

- 当前权限状态。
- 当前 App 路径。
- 为什么需要权限：为了把映射后的键盘事件发送到 macOS。
- 操作：`打开系统设置`、`重新检测权限`。

当用户已授权但仍无法输出时，显示 warning callout：提醒用户检查授权对象是否为当前安装路径下的 `JoyBridge.app`。

**ControllerSection**

用途：显示当前检测到的手柄与最近按键。

必须显示：

- 当前手柄名称。
- 连接状态。
- 最近按键。
- 最近按键发生时间，如果可得。
- 操作：`重新检测手柄`。

未检测到手柄时使用 EmptyState。EmptyState 文案应指向 macOS 蓝牙设置，而不是让用户猜测 JoyBridge 是否坏了。

**TargetLockSection**

用途：管理目标手柄锁定。

状态：

- 未锁定：warning，提示“建议锁定当前手柄，避免其他手柄触发映射”。
- 已锁定且在线：ready，显示目标手柄名。
- 已锁定但离线：warning，提示“不会自动切换到其他手柄”。
- 当前有手柄但不是目标：warning，提示“当前手柄不会触发键盘输出”。

操作：

- `锁定当前手柄`：当前检测到手柄且未锁定时使用 primary。
- `清除锁定`：destructive 或 secondary destructive，不要默认为 primary。
- `重新检测手柄`：secondary。

**MappingSection**

用途：编辑手柄按钮到键盘动作的映射。

映射列表必须按手柄按钮稳定排序：

1. A
2. B
3. X
4. Y
5. Left Shoulder
6. Right Shoulder
7. Left Trigger
8. Right Trigger
9. DPad Up
10. DPad Down
11. DPad Left
12. DPad Right

每个 MappingRow 显示 Source、Action、State、Controls。不要让用户必须打开弹窗才能理解当前映射。

**MappingRow**

Source 显示手柄按钮和可选图标。Action 显示 key chip，例如 `Command` + `C`。State 显示是否启用、是否默认、是否无动作。Controls 至少包含“恢复默认”。

按键编辑规则：

- 单键：`A -> Space`。
- 组合键：`X -> Command + C`。
- 纯修饰键：`Button -> Control`，Key 选择器为 `None/无`，Modifiers 至少一个。
- 无动作：Key 为 `None/无`，Modifiers 为空，显示 `无动作` chip。
- 修改后无需重启，行内状态应短暂显示“已保存”。

**ActionEditor**

使用原生 Picker、Toggle 或 Menu 组合，不做复杂快捷键录制器。本轮不允许加入“按下键盘录制快捷键”的功能。编辑器必须防止无效组合，例如无 key 且无 modifier 时应明确保存为 `No Action`，而不是保存为脏数据。

**RuntimeControlSection**

用途：暂停或恢复映射输出。

暂停定义为：输入监听继续，最近按键继续更新，目标锁定继续有效，键盘输出停止。

状态文案：

- 未暂停：`映射输出已启用`。
- 已暂停：`映射输出已暂停，手柄输入仍会被检测`。

操作：

- 未暂停时显示 `暂停映射`，使用 secondary 或 warning style。
- 已暂停时显示 `启用映射`，使用 primary。

不要把暂停按钮命名为“停止 App”或“断开连接”。

**DiagnosticSection**

用途：朋友测试和长期维护时复制问题上下文。

必须显示简短摘要和复制按钮。诊断详情可以使用 monospace panel。

诊断至少包含：

- App 版本。
- macOS 版本。
- App 路径。
- Accessibility 状态。
- 当前手柄。
- 目标手柄。
- 最近按键。
- 当前映射摘要。
- 暂停状态。
- 最近输出结果。

复制成功后显示 2 秒状态反馈：`诊断信息已复制`。不要打开新窗口显示诊断。

**StatusChip**

用于短状态，不用于长说明。chip 文案控制在 2 到 7 个中文字，或 1 到 3 个英文词。每个 chip 必须有 accessibility label。

推荐文案：

- `可用`
- `需要授权`
- `未检测到手柄`
- `建议锁定`
- `已锁定`
- `目标离线`
- `已暂停`
- `无动作`

**Button**

按钮分为 Primary、Secondary、Quiet、Destructive。

- Primary：每个区域最多一个，表示推荐下一步。
- Secondary：普通操作，例如重新检测、复制。
- Quiet：低优先级操作，例如查看路径、展开详情。
- Destructive：清除锁定、恢复全部默认值等潜在破坏性操作。

按钮必须有 disabled 状态。Disabled 状态不能只降低 opacity，还要避免 VoiceOver 误读为可执行主操作。

**InlineAlert**

用于卡片内部提示，不用于整屏错误。

类型：

- info：普通说明。
- warning：需要用户处理。
- error：阻断输出。
- success：操作完成。

不要同时显示多个强提示。若有多个问题，ReadinessPanel 汇总，具体区域只显示与该区域相关的问题。

**EmptyState**

用于未检测到手柄、暂无映射、暂无诊断等状态。EmptyState 必须包含：

- 图标。
- 一句状态说明。
- 一句下一步。
- 可选操作按钮。

未检测到手柄的推荐文案：`未检测到手柄。请先在 macOS 蓝牙设置中连接 Joy-Con、Switch Pro Controller 或兼容蓝牙手柄，然后点击重新检测。`

**MenuBarMenu**

菜单栏保留轻量操作，不替代主窗口。

顺序：

1. JoyBridge 状态，read-only。
2. 暂停映射或启用映射。
3. 重新打开窗口。
4. 重新检测手柄。
5. 重新检测权限。
6. 复制诊断信息。
7. 退出 JoyBridge。

菜单栏状态文案必须与主窗口整体状态一致。不要在菜单栏加入复杂映射编辑。

## Do's and Don'ts

**Do**

- Do keep the main screen ordered by readiness, permission, controller, target lock, mappings, runtime control, diagnostics.
- Do show the next recommended action whenever a readiness item is not ready.
- Do treat target lock as a business rule in the input pipeline.
- Do separate Source, Action and State in every mapping row.
- Do use native macOS controls and system fonts.
- Do use semantic colors and named tokens.
- Do make diagnostic copying available from both main window and menu bar.
- Do keep the first version focused on controller button to keyboard action mapping.
- Do preserve future extension points for MappingProfile and JSON import or export without showing those features in the current UI.
- Do make UI copy understandable for non-developer testers.

**Don't**

- Don't add sidebar navigation, multi-tab settings, profile switching UI or deep settings pages in this round.
- Don't introduce Electron, Tauri, Python, Node.js UI, Material UI or a web front-end.
- Don't add mouse control, stick scrolling, Motion mouse, per-app profiles, cloud sync, auto update, plugin system or complex shortcut recording.
- Don't let SwiftUI Views call GameController, CGEvent or Accessibility APIs directly.
- Don't use red for every incomplete state.
- Don't hide the App path when diagnosing Accessibility problems.
- Don't show “ready” if Accessibility is missing, no target is locked, or mapping output is paused.
- Don't automatically switch to another controller when the locked target controller is offline.
- Don't rely on console logs as the only feedback for testers.
- Don't use animation to imply that a keyboard event was sent unless the output service actually attempted to send it.

## Interaction & Animation

Animation should make state changes legible, not decorative. All animation must respect Reduce Motion.

**Durations**

- Button press feedback: 80ms to 120ms.
- Status chip change: 150ms ease out.
- Card expand or collapse: 180ms to 220ms ease in out.
- Recent pressed button highlight: 500ms to 700ms fade.
- Copy success toast or inline confirmation: visible for 2 seconds.

**Recent key feedback**

When a controller button is pressed, update “最近按键” immediately. The corresponding MappingRow may show a subtle background highlight for up to 700ms. If Reduce Motion is enabled, replace animation with an instant color change and no fade.

**Pause and resume**

When pausing, the RuntimeControlSection status changes immediately. Do not animate the whole MappingList into disabled opacity, because input detection continues. Instead, show a clear paused chip and suppress only output-related ready indicators.

**Permission changes**

When permission is rechecked, show an inline spinner only while the check is actually running. Avoid indefinite spinners. If the result is unchanged, provide text feedback such as `仍未检测到辅助功能权限` or `权限已确认`。

**Forbidden animation**

- No bouncing game controller icons.
- No confetti after successful mapping.
- No loading skeletons for local state.
- No animated background gradients.
- No animation that delays input handling or keyboard output.

## Responsive Design

JoyBridge is a macOS desktop app, not a mobile app. Responsive design means the window remains usable at different desktop sizes and in different system settings.

**Breakpoints**

- Compact: width < 720px. All sections single column. MappingRow stacks into two lines.
- Standard: 720px <= width < 900px. Main sections single column. Readiness items can use 2 columns.
- Wide: width >= 900px. Readiness items can use 4 columns. Controller and TargetLock may sit side by side. MappingList remains vertically ordered.

**Minimum window**

The app should remain usable at 760px by 640px. If the user makes the window smaller, content may scroll but controls must not overlap.

**Text scaling**

The layout must tolerate larger text without clipping. If a row becomes too tall, increase row height rather than truncating important state. Paths may truncate in the middle with tooltip or copy affordance.

**Dark mode and high contrast**

Support light and dark mode. Support increased contrast by strengthening borders and avoiding subtle-only differences. Status should remain readable without relying on saturation alone.

**Localization**

Chinese is the default UI copy. English hardware names and key names are acceptable. Layout must handle longer localized strings, especially buttons like `重新检测控制器` and `复制诊断信息`。

## UI Framework

Use SwiftUI as the primary UI framework.

Use AppKit only where it is the appropriate macOS integration layer, such as:

- `NSStatusItem` for menu bar item.
- App lifecycle and window behavior when SwiftUI cannot express it cleanly.
- Opening System Settings for Accessibility authorization.
- Native pasteboard integration for diagnostics if needed.

Do not introduce third-party UI frameworks in this refactor. Do not use web UI frameworks, Tailwind, Material UI, Electron, Tauri, Python UI, React, Vue or Node based UI implementation.

Recommended implementation structure:

- `DesignTokens.swift`: semantic colors, spacing, radius and typography helpers.
- `JoyButtonStyle`: primary, secondary, quiet, destructive variants.
- `StatusChipView`: shared chip component.
- `SectionCard`: shared card container.
- `ReadinessPanelView`: summary state.
- `PermissionSectionView`: Accessibility status.
- `ControllerSectionView`: current device and recent input.
- `TargetLockSectionView`: target lock state.
- `MappingListView`: mapping rows.
- `MappingRowView`: row level editor.
- `RuntimeControlView`: pause and resume.
- `DiagnosticPanelView`: copyable diagnostics.

State should flow from Application layer into Presentation layer through view models or observable state objects. Presentation should not own domain rules.

## Accessibility

JoyBridge must be usable with keyboard navigation, VoiceOver, high contrast settings and reduced motion.

**Keyboard navigation**

All controls must be reachable by Tab. Focus order follows visual order from top to bottom. Primary actions may have keyboard shortcuts only when they do not conflict with user mappings. Avoid global shortcuts inside JoyBridge that could conflict with the mapping output being tested.

**VoiceOver**

Every status chip must expose a full label, for example `辅助功能权限：已授权` rather than only `已授权`。Every button must describe its result, for example `打开辅助功能系统设置` rather than only `打开`。

**Color and contrast**

Text must meet WCAG AA contrast where applicable. Do not use color alone to convey ready, warning or error. Pair color with icon and text.

**Motion**

Respect Reduce Motion. Recent key highlight and status transitions must become instant or near-instant when Reduce Motion is enabled.

**Hit targets**

Interactive controls should be at least 28px high, with 32px preferred. Icon-only buttons should have visible labels unless they are in a dense toolbar or menu, and they still require accessibility labels.

**Diagnostics**

Diagnostic text must be selectable or copyable. The copy button must give visible and accessible feedback after copying. The App path should be readable by VoiceOver and copyable for troubleshooting.

## AI Implementation Rules

These rules are binding for AI coding agents.

- Generate UI from the tokens in this file first. If a visual value is missing, add a token rather than hard-coding a new value in a View.
- Keep the UI single-window and vertically ordered.
- Use ViewState structs to render UI. Do not let Views compute domain truth from raw managers.
- Do not add features outside the current scope just because a component seems convenient.
- Treat `paused` as a runtime output state, not as disconnected input.
- Treat target lock filtering as part of input acceptance, not as a visual-only setting.
- Keep diagnostic fields stable so copied reports can be compared between tester sessions.
- Prefer clear text over icon-only UI.
- Prefer native controls over custom controls unless a custom component is defined in this file.
- When user feedback asks for a vague visual change, translate it into token changes, component rules or layout constraints.

## Design Decisions and Tradeoffs

**Single window instead of tabs**

Chosen because the user's main task is a linear readiness and mapping workflow. Tabs would hide permission, target lock or diagnostics behind navigation and would make friend testing harder.

**Native macOS utility style instead of branded visual style**

Chosen because JoyBridge is a personal productivity tool that interacts with system permissions and keyboard events. Trust and clarity are more important than visual novelty.

**Tonal cards instead of heavy shadows**

Chosen because the app should feel like a stable macOS settings utility. Heavy shadows would add noise and make state colors less clear.

**Simple ActionEditor instead of shortcut recorder**

Chosen because the current scope supports single key, modifier-only and modifier combinations. A recorder would introduce edge cases and raise implementation complexity.

**MappingProfile model without profile UI**

Chosen because future profiles should be possible, but the current UI should not ask users to understand profile management before the core mapping flow is stable.

## References & Inspiration

Use these references for product and interaction inspiration, not for direct visual copying.

- Apple Human Interface Guidelines: native macOS patterns, accessibility expectations, system typography and control behavior.
- macOS System Settings: permission-related layout, concise explanations and native controls.
- Karabiner-Elements: keyboard customization as a domain reference. JoyBridge should be simpler and more guided.
- BetterTouchTool: broad input customization reference. JoyBridge should avoid its feature breadth in the current round.
- Keyboard Maestro: powerful automation reference. JoyBridge should not become a macro automation platform.
- Nintendo controller mental model: button names and source labels should remain familiar to Joy-Con and Switch Pro Controller users.

## Design QA Checklist

Use this checklist before accepting UI changes.

- The first visible panel tells the user whether JoyBridge can currently output keyboard events.
- Missing Accessibility permission shows a clear next action.
- The current App path is visible in the permission or diagnostic area.
- Current controller, target controller and recent button are visible.
- Locked target offline state does not auto-switch to another controller.
- Mapping rows show Source, Action and State without opening a modal.
- Pause stops output but does not visually imply input detection has stopped.
- Copy diagnostics includes all required diagnostic fields.
- All status colors have matching text and icons.
- The interface remains usable at 760px by 640px.
- Dark mode and increased contrast remain readable.
- No out-of-scope features were introduced.
