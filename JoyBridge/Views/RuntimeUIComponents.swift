import AppKit
import SwiftUI

struct SectionPanel<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.separator.opacity(0.65), lineWidth: 1)
        }
    }
}

struct StatusChip: View {
    let level: RuntimeStatusLevel
    var text: String?

    var body: some View {
        Label(text ?? level.defaultChipText, systemImage: level.systemImageName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(foregroundColor.opacity(0.12))
            .clipShape(Capsule())
            .accessibilityLabel(text ?? level.defaultChipText)
    }

    private var foregroundColor: Color {
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

struct KeyChip: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(.caption, design: .monospaced).weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.secondary.opacity(0.14))
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .lineLimit(1)
    }
}

struct DiagnosticPanel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.secondary)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.secondary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
