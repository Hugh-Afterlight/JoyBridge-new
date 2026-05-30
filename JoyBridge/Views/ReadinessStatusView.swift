import SwiftUI

struct ReadinessStatusView: View {
    let runtimeState: RuntimeState
    let onPermissionAction: () -> Void
    let onControllerAction: () -> Void
    let onTargetAction: () -> Void
    let onMappingAction: () -> Void

    var body: some View {
        SectionPanel(title: "运行检查") {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    StatusChip(level: runtimeState.level)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(runtimeState.title)
                            .font(.body.weight(.semibold))

                        Text(runtimeState.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                VStack(spacing: 10) {
                    ForEach(runtimeState.checks) { item in
                        readinessRow(item)
                    }
                }
            }
        }
    }

    private func readinessRow(_ item: RuntimeCheckItem) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: item.level.systemImageName)
                .foregroundStyle(color(for: item.level))
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(item.title)
                        .font(.callout.weight(.semibold))

                    Text(item.value)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                Text(item.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            if let actionTitle = item.actionTitle {
                Button(actionTitle) {
                    performAction(for: item.kind)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(10)
        .background(.secondary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func performAction(for kind: RuntimeCheckKind) {
        switch kind {
        case .accessibility:
            onPermissionAction()
        case .controller:
            onControllerAction()
        case .targetController:
            onTargetAction()
        case .mappingOutput:
            onMappingAction()
        }
    }

    private func color(for level: RuntimeStatusLevel) -> Color {
        switch level {
        case .ready:
            .green
        case .warning:
            .orange
        case .blocked:
            .red
        case .paused:
            .secondary
        }
    }
}
