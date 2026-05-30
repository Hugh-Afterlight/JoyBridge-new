import AppKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var accessibilityPermissionManager: AccessibilityPermissionManager
    @EnvironmentObject private var mappingManager: MappingManager
    @EnvironmentObject private var controllerManager: ControllerManager
    @State private var didCopyDiagnostics = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AppHeaderView(
                    runtimeState: runtimeState,
                    didCopyDiagnostics: didCopyDiagnostics,
                    onCopyDiagnostics: copyDiagnostics
                )

                ReadinessStatusView(
                    runtimeState: runtimeState,
                    onPermissionAction: {
                        accessibilityPermissionManager.requestPermissionAndOpenSettings()
                    },
                    onControllerAction: {
                        controllerManager.scanControllers()
                    },
                    onTargetAction: {
                        if controllerManager.isTargetControllerSelected && !controllerManager.isSelectedTargetConnected {
                            controllerManager.scanControllers()
                        } else {
                            controllerManager.lockCurrentControllerAsTarget()
                        }
                    },
                    onMappingAction: {
                        mappingManager.setMappingPaused(false)
                    }
                )

                PermissionStatusView()
                ControllerStatusView()
                MappingListView()

                RuntimeControlView(
                    isPaused: mappingManager.isMappingPaused,
                    onTogglePause: {
                        mappingManager.toggleMappingPaused()
                    }
                )

                DiagnosticSectionView(
                    report: diagnosticReport,
                    didCopyDiagnostics: didCopyDiagnostics,
                    onCopyDiagnostics: copyDiagnostics
                )
            }
            .padding(24)
            .frame(maxWidth: 1040, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .frame(minWidth: 820, minHeight: 640)
        .onAppear {
            accessibilityPermissionManager.refreshPermissionStatus(reason: "view appeared")
            controllerManager.scanControllers()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            accessibilityPermissionManager.refreshPermissionStatusIfNeeded()
        }
    }

    private var runtimeState: RuntimeState {
        RuntimeState.make(
            isAccessibilityTrusted: accessibilityPermissionManager.isTrusted,
            currentControllerName: controllerManager.connectedControllerName,
            isTargetControllerSelected: controllerManager.isTargetControllerSelected,
            isSelectedTargetConnected: controllerManager.isSelectedTargetConnected,
            selectedTargetControllerName: controllerManager.selectedTargetControllerName,
            isMappingPaused: mappingManager.isMappingPaused
        )
    }

    private var diagnosticReport: DiagnosticReport {
        DiagnosticsService().makeReport(
            accessibilityPermissionManager: accessibilityPermissionManager,
            mappingManager: mappingManager,
            controllerManager: controllerManager
        )
    }

    private func copyDiagnostics() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(diagnosticReport.text, forType: .string)
        didCopyDiagnostics = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            didCopyDiagnostics = false
        }
    }
}

private struct AppHeaderView: View {
    let runtimeState: RuntimeState
    let didCopyDiagnostics: Bool
    let onCopyDiagnostics: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 42, height: 42)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 10) {
                    Text(AppIdentity.displayName)
                        .font(.title2.bold())

                    StatusChip(level: runtimeState.level, text: runtimeState.level.defaultChipText)
                }

                Text("\(AppInfo.currentTestVersion) · \(AppInfo.releaseDate) · \(runtimeState.subtitle)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Button(action: onCopyDiagnostics) {
                    Label("复制诊断信息", systemImage: "doc.on.doc")
                }

                if didCopyDiagnostics {
                    Text("诊断信息已复制")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(.vertical, 2)
    }
}

private struct RuntimeControlView: View {
    let isPaused: Bool
    let onTogglePause: () -> Void

    var body: some View {
        SectionPanel(title: "映射状态") {
            HStack(alignment: .center, spacing: 14) {
                StatusChip(level: isPaused ? .paused : .ready, text: isPaused ? "已暂停" : "已启用")

                VStack(alignment: .leading, spacing: 4) {
                    Text(isPaused ? "映射输出已暂停，手柄输入仍会被检测" : "映射输出已启用")
                        .font(.body.weight(.semibold))

                    Text("暂停后仍会监听手柄和更新最近按键，但不会发送键盘输入。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button(action: onTogglePause) {
                    Label(isPaused ? "启用映射" : "暂停映射", systemImage: isPaused ? "play.circle" : "pause.circle")
                }
                .buttonStyle(.borderedProminent)
                .tint(isPaused ? .blue : .gray)
            }
        }
    }
}

private struct DiagnosticSectionView: View {
    let report: DiagnosticReport
    let didCopyDiagnostics: Bool
    let onCopyDiagnostics: () -> Void

    var body: some View {
        SectionPanel(title: "诊断信息") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("朋友测试或排查问题时，请复制这份诊断信息。")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button(action: onCopyDiagnostics) {
                        Label("复制诊断信息", systemImage: "doc.on.doc")
                    }
                }

                if didCopyDiagnostics {
                    Text("诊断信息已复制")
                        .font(.caption)
                        .foregroundStyle(.green)
                }

                DiagnosticPanel(text: report.text)
            }
        }
    }
}
