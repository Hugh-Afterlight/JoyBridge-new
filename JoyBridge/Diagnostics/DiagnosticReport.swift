import Foundation

struct DiagnosticReport: Equatable {
    let appName: String
    let appVersion: String
    let releaseDate: String
    let bundleIdentifier: String
    let macOSVersion: String
    let appPath: String
    let accessibilityStatus: String
    let currentController: String
    let targetControllerStatus: String
    let targetControllerName: String
    let latestButton: String
    let latestButtonTime: String
    let mappingStatus: String
    let mappingSummary: String
    let mappingDetails: [String]
    let latestOutputResult: String

    var text: String {
        var lines = [
            "\(appName) 诊断信息",
            "App 版本：\(appVersion) · \(releaseDate)",
            "Bundle ID：\(bundleIdentifier)",
            "macOS 版本：\(macOSVersion)",
            "App 路径：\(appPath)",
            "辅助功能权限（Accessibility）：\(accessibilityStatus)",
            "当前手柄：\(currentController)",
            "目标手柄状态：\(targetControllerStatus)",
            "目标手柄名称：\(targetControllerName)",
            "最近按键：\(latestButton)",
            "最近按键时间：\(latestButtonTime)",
            "暂停状态：\(mappingStatus)",
            "映射摘要：\(mappingSummary)",
            "最近输出结果：\(latestOutputResult)",
            "映射明细："
        ]

        lines.append(contentsOf: mappingDetails.map { "- \($0)" })
        lines.append("反馈时请补充：你按了哪个手柄按钮、期望发生什么、实际发生了什么。")
        return lines.joined(separator: "\n")
    }
}
