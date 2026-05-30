import SwiftUI

struct ControllerStatusView: View {
    @EnvironmentObject private var controllerManager: ControllerManager

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionPanel(title: "手柄状态") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        StatusChip(
                            level: controllerManager.isControllerConnected ? .ready : .warning,
                            text: controllerManager.isControllerConnected ? "已连接" : "未连接"
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(controllerManager.connectedControllerName ?? "未检测到手柄")
                                .font(.body.weight(.semibold))

                            Text(controllerManager.isControllerConnected ? "JoyBridge 正在监听当前手柄输入。" : "请先在 macOS 蓝牙设置里连接手柄。")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            controllerManager.scanControllers()
                        } label: {
                            Label("重新检测手柄", systemImage: "gamecontroller")
                        }
                    }

                    HStack(spacing: 8) {
                        Text("最近按键：")
                            .foregroundStyle(.secondary)

                        Text(controllerManager.latestPressedButton?.displayName ?? "无")
                            .fontWeight(.semibold)

                        if let latestPressedAt = controllerManager.latestPressedAt {
                            Text("· \(formatted(latestPressedAt))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            SectionPanel(title: "目标锁定") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        StatusChip(level: targetLevel, text: targetChipText)

                        Picker("目标手柄", selection: targetSelection) {
                            Text("自动选择第一个")
                                .tag(ControllerManager.automaticTargetID)

                            ForEach(controllerManager.availableControllers) { controller in
                                Text(controller.displayName)
                                    .tag(controller.id)
                            }

                            if
                                let selectedID = controllerManager.selectedTargetControllerID,
                                let selectedName = controllerManager.selectedTargetControllerName,
                                !controllerManager.availableControllers.contains(where: { $0.id == selectedID })
                            {
                                Text("\(selectedName)（未连接）")
                                    .tag(selectedID)
                            }
                        }
                        .frame(maxWidth: 360)

                        Spacer()

                        Button {
                            controllerManager.lockCurrentControllerAsTarget()
                        } label: {
                            Label("锁定当前", systemImage: "lock")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!controllerManager.isControllerConnected)

                        if controllerManager.isTargetControllerSelected {
                            Button {
                                controllerManager.selectTargetController(id: nil)
                            } label: {
                                Label("清除目标", systemImage: "xmark.circle")
                            }
                        }
                    }

                    Text(targetStatusDescription)
                        .font(.caption)
                        .foregroundStyle(targetLevel == .warning ? .orange : .secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var targetSelection: Binding<String> {
        Binding(
            get: {
                controllerManager.selectedTargetControllerID ?? ControllerManager.automaticTargetID
            },
            set: { newValue in
                if newValue == ControllerManager.automaticTargetID {
                    controllerManager.selectTargetController(id: nil)
                } else {
                    controllerManager.selectTargetController(id: newValue)
                }
            }
        )
    }

    private var targetLevel: RuntimeStatusLevel {
        if controllerManager.isTargetControllerSelected {
            return controllerManager.isSelectedTargetConnected ? .ready : .warning
        }

        return .warning
    }

    private var targetChipText: String {
        if controllerManager.isTargetControllerSelected {
            return controllerManager.isSelectedTargetConnected ? "已锁定" : "目标离线"
        }

        return "建议锁定"
    }

    private var targetStatusDescription: String {
        if controllerManager.isTargetControllerSelected {
            if controllerManager.isSelectedTargetConnected {
                return "锁定后，JoyBridge 只响应这个手柄。"
            }

            return "目标手柄未连接时，JoyBridge 不会自动切换到其他手柄。"
        }

        return "当前为自动选择第一个已连接手柄。建议测试稳定后点击“锁定当前”，避免响应其他蓝牙手柄。"
    }

    private func formatted(_ date: Date) -> String {
        DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
    }
}
