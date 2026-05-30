import Foundation

enum RuntimeStatusLevel: String, Equatable {
    case ready
    case warning
    case blocked
    case paused

    var defaultChipText: String {
        switch self {
        case .ready:
            "可用"
        case .warning:
            "需要处理"
        case .blocked:
            "无法输出"
        case .paused:
            "已暂停"
        }
    }

    var systemImageName: String {
        switch self {
        case .ready:
            "checkmark.circle"
        case .warning:
            "exclamationmark.triangle"
        case .blocked:
            "xmark.octagon"
        case .paused:
            "pause.circle"
        }
    }
}

enum RuntimeCheckKind: String, Equatable {
    case accessibility
    case controller
    case targetController
    case mappingOutput
}

struct RuntimeCheckItem: Identifiable, Equatable {
    var id: String { kind.rawValue }

    let kind: RuntimeCheckKind
    let title: String
    let value: String
    let detail: String
    let level: RuntimeStatusLevel
    let actionTitle: String?
}

struct RuntimeState: Equatable {
    let level: RuntimeStatusLevel
    let title: String
    let subtitle: String
    let checks: [RuntimeCheckItem]

    static func make(
        isAccessibilityTrusted: Bool,
        currentControllerName: String?,
        isTargetControllerSelected: Bool,
        isSelectedTargetConnected: Bool,
        selectedTargetControllerName: String?,
        isMappingPaused: Bool
    ) -> RuntimeState {
        let isControllerConnected = currentControllerName != nil
        let permissionCheck = RuntimeCheckItem(
            kind: .accessibility,
            title: "辅助功能",
            value: isAccessibilityTrusted ? "已授权" : "需要授权",
            detail: isAccessibilityTrusted
                ? "JoyBridge 可以向 macOS 发送映射后的键盘事件。"
                : "需要先授权，JoyBridge 才能输出键盘事件。",
            level: isAccessibilityTrusted ? .ready : .blocked,
            actionTitle: isAccessibilityTrusted ? nil : "打开系统设置"
        )

        let controllerCheck = RuntimeCheckItem(
            kind: .controller,
            title: "手柄",
            value: currentControllerName ?? "未连接",
            detail: isControllerConnected
                ? "已检测到当前手柄，可以继续测试按键。"
                : "请先在 macOS 蓝牙设置中连接手柄，再重新检测。",
            level: isControllerConnected ? .ready : .warning,
            actionTitle: isControllerConnected ? nil : "重新检测手柄"
        )

        let targetCheck = makeTargetCheck(
            isControllerConnected: isControllerConnected,
            isTargetControllerSelected: isTargetControllerSelected,
            isSelectedTargetConnected: isSelectedTargetConnected,
            selectedTargetControllerName: selectedTargetControllerName
        )

        let mappingCheck = RuntimeCheckItem(
            kind: .mappingOutput,
            title: "映射输出",
            value: isMappingPaused ? "已暂停" : "已启用",
            detail: isMappingPaused
                ? "输入监听继续，最近按键会更新，但不会发送键盘事件。"
                : "映射输出已启用，满足权限和目标条件时会发送键盘事件。",
            level: isMappingPaused ? .paused : .ready,
            actionTitle: isMappingPaused ? "启用映射" : nil
        )

        let level: RuntimeStatusLevel
        let title: String
        let subtitle: String

        if !isAccessibilityTrusted {
            level = .blocked
            title = "需要授权辅助功能"
            subtitle = "打开系统设置并授权当前安装路径。"
        } else if isMappingPaused {
            level = .paused
            title = "映射已暂停"
            subtitle = "可以检测输入，但不会输出键盘事件。"
        } else if isTargetControllerSelected && !isSelectedTargetConnected {
            level = .warning
            title = "目标手柄离线"
            subtitle = "不会自动切换到其他手柄。"
        } else if !isControllerConnected {
            level = .warning
            title = "等待手柄"
            subtitle = "连接蓝牙手柄后重新检测。"
        } else if !isTargetControllerSelected {
            level = .warning
            title = "可以测试，建议锁定"
            subtitle = "锁定当前手柄可避免误响应其他设备。"
        } else {
            level = .ready
            title = "已准备好"
            subtitle = "可以按手柄测试映射。"
        }

        return RuntimeState(
            level: level,
            title: title,
            subtitle: subtitle,
            checks: [permissionCheck, controllerCheck, targetCheck, mappingCheck]
        )
    }

    private static func makeTargetCheck(
        isControllerConnected: Bool,
        isTargetControllerSelected: Bool,
        isSelectedTargetConnected: Bool,
        selectedTargetControllerName: String?
    ) -> RuntimeCheckItem {
        if isTargetControllerSelected {
            if isSelectedTargetConnected {
                return RuntimeCheckItem(
                    kind: .targetController,
                    title: "目标手柄",
                    value: selectedTargetControllerName ?? "已锁定",
                    detail: "只响应这个目标手柄的输入。",
                    level: .ready,
                    actionTitle: nil
                )
            }

            return RuntimeCheckItem(
                kind: .targetController,
                title: "目标手柄",
                value: "目标离线",
                detail: "目标手柄未连接时，不会自动切换到其他手柄。",
                level: .warning,
                actionTitle: "重新检测手柄"
            )
        }

        return RuntimeCheckItem(
            kind: .targetController,
            title: "目标手柄",
            value: "自动选择第一个",
            detail: "日常使用前建议锁定当前手柄。",
            level: .warning,
            actionTitle: isControllerConnected ? "锁定当前" : nil
        )
    }
}
