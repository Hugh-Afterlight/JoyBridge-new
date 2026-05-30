import SwiftUI

struct PermissionStatusView: View {
    @EnvironmentObject private var accessibilityPermissionManager: AccessibilityPermissionManager

    var body: some View {
        SectionPanel(title: "权限状态") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    StatusChip(
                        level: accessibilityPermissionManager.isTrusted ? .ready : .blocked,
                        text: accessibilityPermissionManager.isTrusted ? "已授权" : "需要授权"
                    )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("辅助功能权限（Accessibility）")
                            .font(.body.weight(.semibold))

                        Text("允许 \(AppIdentity.displayName) 把映射后的键盘事件发送给 macOS。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        accessibilityPermissionManager.requestPermissionAndOpenSettings()
                    } label: {
                        Label("请求授权/打开设置", systemImage: "gearshape")
                    }

                    Button {
                        accessibilityPermissionManager.refreshPermissionStatus()
                    } label: {
                        Label("重新检测权限", systemImage: "arrow.clockwise")
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(accessibilityPermissionManager.lastCheckedDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("当前 App 路径：\(accessibilityPermissionManager.currentAppPath)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                if accessibilityPermissionManager.currentAppPath.contains("/DerivedData/") {
                    Label(
                        "当前运行在 Xcode 临时目录。朋友测试和授权排查时，建议使用 /Users/hugh/Applications/JoyBridge-new.app 这样的稳定路径。",
                        systemImage: "exclamationmark.triangle"
                    )
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
