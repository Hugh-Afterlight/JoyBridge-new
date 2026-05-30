import Foundation

@MainActor
struct DiagnosticsService {
    func makeReport(
        accessibilityPermissionManager: AccessibilityPermissionManager,
        mappingManager: MappingManager,
        controllerManager: ControllerManager
    ) -> DiagnosticReport {
        let mappings = mappingManager.mappings
        let enabledCount = mappings.filter(\.isEnabled).count
        let noActionCount = mappings.filter { $0.action == .none }.count
        let mappingDetails = mappings.map { mapping in
            let state = mapping.isEnabled ? "启用" : "禁用"
            return "\(mapping.controllerButton.displayName)：\(mapping.actionDisplayName)（\(state)）"
        }

        return DiagnosticReport(
            appName: AppIdentity.displayName,
            appVersion: AppInfo.currentTestVersion,
            releaseDate: AppInfo.releaseDate,
            bundleIdentifier: AppInfo.bundleIdentifier,
            macOSVersion: ProcessInfo.processInfo.operatingSystemVersionString,
            appPath: accessibilityPermissionManager.currentAppPath,
            accessibilityStatus: accessibilityPermissionManager.isTrusted ? "已授权" : "未授权",
            currentController: controllerManager.connectedControllerName ?? "未连接",
            targetControllerStatus: targetControllerStatus(controllerManager),
            targetControllerName: controllerManager.selectedTargetControllerName ?? "未设置",
            latestButton: controllerManager.latestPressedButton?.displayName ?? "无",
            latestButtonTime: formatted(controllerManager.latestPressedAt),
            mappingStatus: mappingManager.isMappingPaused ? "已暂停" : "已启用",
            mappingSummary: "总数 \(mappings.count)，启用 \(enabledCount)，禁用 \(mappings.count - enabledCount)，无动作 \(noActionCount)",
            mappingDetails: mappingDetails,
            latestOutputResult: mappingManager.latestOutputResult
        )
    }

    private func targetControllerStatus(_ controllerManager: ControllerManager) -> String {
        if controllerManager.isTargetControllerSelected {
            return controllerManager.isSelectedTargetConnected ? "已锁定且在线" : "已锁定但离线"
        }

        return "自动选择第一个"
    }

    private func formatted(_ date: Date?) -> String {
        guard let date else {
            return "无"
        }

        return DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
    }
}
