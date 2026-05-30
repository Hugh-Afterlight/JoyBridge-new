import Combine
import Foundation

@MainActor
final class MappingManager: ObservableObject, ControllerInputHandling, OutputStateResetting {
    @Published private(set) var mappings: [KeyMapping] = []
    @Published private(set) var isMappingPaused: Bool
    @Published private(set) var latestOutputResult = "尚未输出"

    private var profile: MappingProfile
    private let mappingStore: MappingStore
    private let pauseStateStore: PauseStateStore
    private let keyboardOutputService: any KeyboardOutputService
    private let mappingService: MappingService
    private let accessibilityPermissionManager: any AccessibilityPermissionProviding
    private var activeModifierHolds: [ControllerButton: [KeyModifier]] = [:]

    init(
        accessibilityPermissionManager: any AccessibilityPermissionProviding,
        keyboardOutputService: (any KeyboardOutputService)? = nil,
        mappingService: MappingService = MappingService(),
        mappingStore: MappingStore? = nil,
        pauseStateStore: PauseStateStore? = nil
    ) {
        self.accessibilityPermissionManager = accessibilityPermissionManager
        self.keyboardOutputService = keyboardOutputService ?? KeyboardEventSender()
        self.mappingService = mappingService
        self.mappingStore = mappingStore ?? UserDefaultsMappingStore()
        self.pauseStateStore = pauseStateStore ?? UserDefaultsPauseStateStore()
        profile = MappingProfile.defaultProfile()
        isMappingPaused = self.pauseStateStore.loadMappingPaused()

        print("Global mapping pause state loaded: \(isMappingPaused ? "paused" : "enabled")")
        loadProfile()
    }

    func mapping(for button: ControllerButton) -> KeyMapping? {
        mappingService.mapping(for: button, in: profile)
    }

    func updateMapping(_ mapping: KeyMapping) {
        releaseModifierHold(for: mapping.controllerButton)

        profile = profile.updatingMapping(mapping)
        mappings = profile.mappings
        saveProfile()
    }

    func handleButtonPress(_ button: ControllerButton) {
        let decision = mappingService.executionDecision(
            for: button,
            in: profile,
            context: MappingExecutionContext(
                isPaused: isMappingPaused,
                isAccessibilityTrusted: accessibilityPermissionManager.isTrusted
            )
        )

        switch decision {
        case let .execute(mapping, action):
            print("Mapping found: \(mapping.previewDescription)")
            perform(action, for: button)
        case let .skip(reason):
            logSkippedMapping(reason, button: button)
        }
    }

    func handleButtonRelease(_ button: ControllerButton) {
        releaseModifierHold(for: button)
    }

    func setMappingPaused(_ isPaused: Bool) {
        guard isMappingPaused != isPaused else {
            return
        }

        isMappingPaused = isPaused
        pauseStateStore.saveMappingPaused(isPaused)

        if isPaused {
            releaseAllHeldModifiers()
            print("Mappings paused; held modifiers released")
        } else {
            print("Mappings enabled")
        }
    }

    func toggleMappingPaused() {
        setMappingPaused(!isMappingPaused)
    }

    func releaseAllHeldModifiers() {
        let heldModifiers = KeyModifier.orderedUnique(from: activeModifierHolds.values.flatMap { $0 })
        guard !heldModifiers.isEmpty else { return }

        activeModifierHolds.removeAll()
        if keyboardOutputService.sendModifierKeyUp(modifiers: heldModifiers) {
            recordOutputResult("已释放修饰键：\(KeyMapping.actionDisplayName(key: nil, modifiers: heldModifiers))")
        } else {
            recordOutputResult("释放修饰键失败：\(KeyMapping.actionDisplayName(key: nil, modifiers: heldModifiers))")
        }
    }

    func handleControllerInput(_ event: ControllerInputEvent) {
        switch event.phase {
        case .pressed:
            handleButtonPress(event.button)
        case .released:
            handleButtonRelease(event.button)
        }
    }

    func releaseAllHeldOutputs() {
        releaseAllHeldModifiers()
    }

    private func loadProfile() {
        do {
            profile = try mappingStore.loadProfile().normalized()
            mappings = profile.mappings
            print("Mapping profile loaded: \(profile.name)")
        } catch {
            profile = MappingProfile.defaultProfile()
            mappings = profile.mappings
            print("Default mapping profile created after load failure: \(error.localizedDescription)")
            saveProfile()
        }
    }

    private func saveProfile() {
        do {
            try mappingStore.saveProfile(profile)
            print("Mapping profile saved: \(profile.name)")
        } catch {
            print("Mapping profile save failed: \(error.localizedDescription)")
        }
    }

    private func perform(_ action: MappingAction, for button: ControllerButton) {
        switch action {
        case let .keyboard(key, modifiers):
            let effectiveModifiers = modifiersIncludingActiveHolds(modifiers)
            if keyboardOutputService.sendKeyCombo(key: key, modifiers: effectiveModifiers) {
                recordOutputResult("已输出：\(KeyMapping.actionDisplayName(key: key, modifiers: effectiveModifiers))")
            } else {
                recordOutputResult("输出失败：\(KeyMapping.actionDisplayName(key: key, modifiers: effectiveModifiers))")
            }
        case let .modifierOnly(modifiers):
            startModifierHold(modifiers, for: button)
        case .none:
            print("Mapping has no action: \(button.displayName)")
            recordOutputResult("未输出：\(button.displayName) 无动作")
        }
    }

    private func startModifierHold(_ modifiers: [KeyModifier], for button: ControllerButton) {
        let orderedModifiers = KeyModifier.orderedUnique(from: modifiers)
        guard !orderedModifiers.isEmpty else { return }

        let alreadyHeldModifiers = Set(activeModifierHolds.values.flatMap { $0 })
        let modifiersToPress = orderedModifiers.filter { !alreadyHeldModifiers.contains($0) }

        activeModifierHolds[button] = orderedModifiers

        guard !modifiersToPress.isEmpty else {
            print("Modifier hold already active: \(KeyMapping.actionDisplayName(key: nil, modifiers: orderedModifiers))")
            recordOutputResult("修饰键保持中：\(KeyMapping.actionDisplayName(key: nil, modifiers: orderedModifiers))")
            return
        }

        if keyboardOutputService.sendModifierKeyDown(modifiers: modifiersToPress) {
            recordOutputResult("已按下修饰键：\(KeyMapping.actionDisplayName(key: nil, modifiers: modifiersToPress))")
        } else {
            recordOutputResult("按下修饰键失败：\(KeyMapping.actionDisplayName(key: nil, modifiers: modifiersToPress))")
        }
    }

    private func releaseModifierHold(for button: ControllerButton) {
        guard let releasedModifiers = activeModifierHolds.removeValue(forKey: button) else {
            return
        }

        let stillHeldModifiers = Set(activeModifierHolds.values.flatMap { $0 })
        let modifiersToRelease = releasedModifiers.filter { !stillHeldModifiers.contains($0) }

        guard !modifiersToRelease.isEmpty else {
            print("Modifier hold released, modifiers still held by another button")
            recordOutputResult("修饰键仍被其他按钮保持")
            return
        }

        if keyboardOutputService.sendModifierKeyUp(modifiers: modifiersToRelease) {
            recordOutputResult("已释放修饰键：\(KeyMapping.actionDisplayName(key: nil, modifiers: modifiersToRelease))")
        } else {
            recordOutputResult("释放修饰键失败：\(KeyMapping.actionDisplayName(key: nil, modifiers: modifiersToRelease))")
        }
    }

    private func modifiersIncludingActiveHolds(_ modifiers: [KeyModifier]) -> [KeyModifier] {
        KeyModifier.orderedUnique(from: activeModifierHolds.values.flatMap { $0 } + modifiers)
    }

    private func logSkippedMapping(_ reason: MappingSkipReason, button: ControllerButton) {
        switch reason {
        case .paused:
            print("Mapping skipped because global pause is enabled: \(button.displayName)")
            recordOutputResult("未输出：映射已暂停（\(button.displayName)）")
        case .missingMapping:
            print("Mapping missing: \(button.displayName)")
            recordOutputResult("未输出：缺少映射（\(button.displayName)）")
        case .disabled:
            print("Mapping disabled: \(button.displayName)")
            recordOutputResult("未输出：映射已禁用（\(button.displayName)）")
        case .missingAccessibilityPermission:
            print("Accessibility permission missing")
            recordOutputResult("未输出：缺少辅助功能权限")
        case .noAction:
            print("Mapping has no action: \(button.displayName)")
            recordOutputResult("未输出：\(button.displayName) 无动作")
        }
    }

    private func recordOutputResult(_ result: String) {
        latestOutputResult = result
    }

    static func defaultMappings() -> [KeyMapping] {
        MappingCatalog.defaultMappings()
    }
}
