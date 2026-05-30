import SwiftUI

struct MappingRowView: View {
    let mapping: KeyMapping
    let onUpdate: (KeyMapping) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("手柄按键")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(mapping.controllerButton.displayName)
                        .font(.headline)
                }
                .frame(width: 112, alignment: .leading)

                VStack(alignment: .leading, spacing: 8) {
                    Text("动作")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 6) {
                        ForEach(actionChips, id: \.self) { chip in
                            KeyChip(chip)
                        }
                    }

                    HStack(spacing: 10) {
                        ForEach(KeyModifier.allCases) { modifier in
                            Toggle(modifier.displayName, isOn: modifierBinding(for: modifier))
                                .toggleStyle(.checkbox)
                        }
                    }

                    Picker("键盘按键", selection: keyBinding) {
                        Text("None/无").tag(nil as KeyboardKey?)

                        ForEach(KeyboardKey.allCases) { key in
                            Text(key.displayName).tag(key as KeyboardKey?)
                        }
                    }
                    .frame(maxWidth: 240)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("状态")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    StatusChip(level: mapping.isEnabled ? .ready : .paused, text: mappingStateText)

                    Toggle("启用", isOn: enabledBinding)
                        .toggleStyle(.checkbox)

                    Button {
                        onUpdate(defaultMapping)
                    } label: {
                        Label("恢复默认", systemImage: "arrow.counterclockwise")
                    }
                    .disabled(mapping == defaultMapping)
                }
                .frame(width: 140, alignment: .leading)
            }

            Text("预览：\(mapping.previewDescription)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 12)
    }

    private var enabledBinding: Binding<Bool> {
        Binding {
            mapping.isEnabled
        } set: { isEnabled in
            var updatedMapping = mapping
            updatedMapping.isEnabled = isEnabled
            onUpdate(updatedMapping)
        }
    }

    private var keyBinding: Binding<KeyboardKey?> {
        Binding {
            mapping.key
        } set: { key in
            var updatedMapping = mapping
            updatedMapping.key = key
            onUpdate(updatedMapping)
        }
    }

    private var actionChips: [String] {
        let modifierNames = KeyModifier.orderedUnique(from: mapping.modifiers).map(\.displayName)

        if let key = mapping.key {
            return modifierNames + [key.displayName]
        }

        if modifierNames.isEmpty {
            return ["无动作"]
        }

        return modifierNames
    }

    private var mappingStateText: String {
        if !mapping.isEnabled {
            return "已禁用"
        }

        if mapping.action == .none {
            return "无动作"
        }

        if mapping == defaultMapping {
            return "默认值"
        }

        return "已启用"
    }

    private var defaultMapping: KeyMapping {
        MappingCatalog.defaultMappings().first { $0.controllerButton == mapping.controllerButton } ?? mapping
    }

    private func modifierBinding(for modifier: KeyModifier) -> Binding<Bool> {
        Binding {
            mapping.modifiers.contains(modifier)
        } set: { isEnabled in
            onUpdate(mapping.settingModifier(modifier, enabled: isEnabled))
        }
    }
}
