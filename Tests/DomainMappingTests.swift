import Foundation

@main
struct DomainMappingTests {
    @MainActor
    static func main() throws {
        try testMappingActions()
        try testModifierOrdering()
        try testDefaultMappings()
        try testMappingNormalization()
        try testProfileUpdate()
        try testUserDefaultsStoreRoundTrip()
        try testControllerInputEvent()
        try testTargetControllerRule()
        try testMappingServiceDecisions()
        try testMappingManagerOutputGuards()
        try testMappingManagerReleasesHeldModifiers()
        try testRuntimeStatePriority()
        try testDiagnosticReportText()

        print("DomainMappingTests passed")
    }

    private static func testMappingActions() throws {
        try expectEqual(
            MappingAction(key: .space, modifiers: []),
            .keyboard(key: .space, modifiers: []),
            "single key action"
        )

        try expectEqual(
            MappingAction(key: .c, modifiers: [.shift, .command, .shift]),
            .keyboard(key: .c, modifiers: [.command, .shift]),
            "combo action normalizes modifiers"
        )

        try expectEqual(
            MappingAction(key: nil, modifiers: [.control]),
            .modifierOnly(modifiers: [.control]),
            "modifier-only action"
        )

        try expectEqual(
            MappingAction(key: nil, modifiers: []),
            .none,
            "none action"
        )
    }

    private static func testModifierOrdering() throws {
        try expectEqual(
            KeyModifier.orderedUnique(from: [.shift, .command, .shift, .option]),
            [.command, .option, .shift],
            "modifier order follows JoyBridge canonical order"
        )
    }

    private static func testDefaultMappings() throws {
        let defaults = MappingCatalog.defaultMappings()

        try expectEqual(
            defaults.count,
            ControllerButton.mappableButtons.count,
            "default mapping count matches mappable buttons"
        )

        try expectEqual(
            defaults.first { $0.controllerButton == .x }?.action,
            .keyboard(key: .c, modifiers: [.command]),
            "X defaults to Command + C"
        )

        try expectEqual(
            defaults.first { $0.controllerButton == .leftTrigger }?.action,
            .keyboard(key: .pageUp, modifiers: []),
            "ZL defaults to Page Up"
        )
    }

    private static func testMappingNormalization() throws {
        let sourceMappings = [
            KeyMapping(id: "custom-a", controllerButton: .a, key: .enter),
            KeyMapping(controllerButton: .a, key: .escape),
            KeyMapping(controllerButton: .unknown, key: .space)
        ]

        let normalized = MappingCatalog.normalizedMappings(sourceMappings)

        try expectEqual(
            normalized.count,
            ControllerButton.mappableButtons.count,
            "normalization keeps one mapping per mappable button"
        )

        let aMapping = try unwrap(normalized.first { $0.controllerButton == .a }, "normalized A mapping")
        try expectEqual(aMapping.id, ControllerButton.a.rawValue, "normalized mapping id")
        try expectEqual(aMapping.key, .enter, "first source mapping wins")

        let bMapping = try unwrap(normalized.first { $0.controllerButton == .b }, "normalized B mapping")
        try expectEqual(bMapping.key, .escape, "missing mapping is filled from defaults")
    }

    private static func testProfileUpdate() throws {
        let profile = MappingProfile.defaultProfile()
        let updated = profile.updatingMapping(
            KeyMapping(controllerButton: .b, key: nil, modifiers: [.control])
        )

        try expectEqual(
            updated.mapping(for: .b)?.action,
            .modifierOnly(modifiers: [.control]),
            "profile update supports modifier-only mapping"
        )

        try expectEqual(
            updated.mappings.count,
            ControllerButton.mappableButtons.count,
            "profile update preserves full mapping set"
        )
    }

    private static func testUserDefaultsStoreRoundTrip() throws {
        let suiteName = "JoyBridgeDomainMappingTests-\(UUID().uuidString)"
        let userDefaults = try unwrap(UserDefaults(suiteName: suiteName), "test UserDefaults suite")
        defer {
            userDefaults.removePersistentDomain(forName: suiteName)
        }

        let store = UserDefaultsMappingStore(userDefaults: userDefaults)
        let sourceProfile = MappingProfile.defaultProfile().updatingMapping(
            KeyMapping(controllerButton: .y, key: .s, modifiers: [.command, .shift])
        )

        try store.saveProfile(sourceProfile)
        let loadedProfile = try store.loadProfile()

        try expectEqual(
            loadedProfile.mapping(for: .y)?.action,
            .keyboard(key: .s, modifiers: [.command, .shift]),
            "store preserves custom profile mapping"
        )
    }

    private static func testControllerInputEvent() throws {
        let event = ControllerInputEvent(
            controllerID: "target-1",
            controllerName: "Joy-Con (L)",
            button: .a,
            phase: .pressed,
            sourceProfile: "unit-test"
        )

        try expectEqual(event.controllerID, "target-1", "controller input event keeps controller id")
        try expectEqual(event.button, .a, "controller input event keeps button")
        try expectEqual(event.phase, .pressed, "controller input event keeps phase")
    }

    private static func testTargetControllerRule() throws {
        let rule = TargetControllerRule()

        try expectEqual(
            rule.accepts(controllerID: "controller-a", selectedTargetControllerID: nil),
            true,
            "automatic target accepts connected controller"
        )

        try expectEqual(
            rule.accepts(controllerID: "controller-a", selectedTargetControllerID: "controller-a"),
            true,
            "locked target accepts matching controller"
        )

        try expectEqual(
            rule.accepts(controllerID: "controller-b", selectedTargetControllerID: "controller-a"),
            false,
            "locked target rejects non-target controller"
        )
    }

    private static func testMappingServiceDecisions() throws {
        let service = MappingService()
        let profile = MappingProfile.defaultProfile(
            mappings: [
                KeyMapping(controllerButton: .a, key: .space),
                KeyMapping(controllerButton: .b, key: .enter, isEnabled: false),
                KeyMapping(controllerButton: .x, key: nil),
                KeyMapping(controllerButton: .y, key: nil, modifiers: [.command])
            ]
        )
        let trustedContext = MappingExecutionContext(isPaused: false, isAccessibilityTrusted: true)

        try expectExecute(
            service.executionDecision(for: .a, in: profile, context: trustedContext),
            action: .keyboard(key: .space, modifiers: []),
            "enabled keyboard mapping executes"
        )

        try expectSkip(
            service.executionDecision(
                for: .a,
                in: profile,
                context: MappingExecutionContext(isPaused: true, isAccessibilityTrusted: true)
            ),
            reason: .paused,
            "paused mapping skips before output"
        )

        try expectSkip(
            service.executionDecision(for: .unknown, in: profile, context: trustedContext),
            reason: .missingMapping,
            "missing mapping skips before output"
        )

        try expectSkip(
            service.executionDecision(for: .b, in: profile, context: trustedContext),
            reason: .disabled,
            "disabled mapping skips before output"
        )

        try expectSkip(
            service.executionDecision(
                for: .a,
                in: profile,
                context: MappingExecutionContext(isPaused: false, isAccessibilityTrusted: false)
            ),
            reason: .missingAccessibilityPermission,
            "missing Accessibility permission skips before output"
        )

        try expectSkip(
            service.executionDecision(for: .x, in: profile, context: trustedContext),
            reason: .noAction,
            "none mapping skips before output"
        )

        try expectExecute(
            service.executionDecision(for: .y, in: profile, context: trustedContext),
            action: .modifierOnly(modifiers: [.command]),
            "modifier-only mapping executes"
        )
    }

    @MainActor
    private static func testMappingManagerOutputGuards() throws {
        let permissionProvider = FakePermissionProvider(isTrusted: true)
        let keyboardOutput = FakeKeyboardOutputService()
        let mappingManager = makeMappingManager(
            permissionProvider: permissionProvider,
            keyboardOutput: keyboardOutput
        )

        mappingManager.handleControllerInput(inputEvent(button: .a, phase: .pressed))
        try expectEqual(
            keyboardOutput.events,
            [.keyCombo(key: .space, modifiers: [])],
            "enabled keyboard mapping sends one key combo"
        )

        keyboardOutput.events.removeAll()
        mappingManager.setMappingPaused(true)
        mappingManager.handleControllerInput(inputEvent(button: .a, phase: .pressed))
        try expectEqual(keyboardOutput.events, [], "paused mapping sends no keyboard output")

        mappingManager.setMappingPaused(false)
        permissionProvider.isTrusted = false
        mappingManager.handleControllerInput(inputEvent(button: .a, phase: .pressed))
        try expectEqual(keyboardOutput.events, [], "missing permission sends no keyboard output")

        permissionProvider.isTrusted = true
        mappingManager.handleControllerInput(inputEvent(button: .b, phase: .pressed))
        mappingManager.handleControllerInput(inputEvent(button: .x, phase: .pressed))
        try expectEqual(keyboardOutput.events, [], "disabled and none mappings send no keyboard output")

        mappingManager.handleControllerInput(inputEvent(button: .y, phase: .pressed))
        mappingManager.handleControllerInput(inputEvent(button: .y, phase: .pressed))
        try expectEqual(
            keyboardOutput.events,
            [.modifierDown([.command])],
            "modifier hold sends keyDown only once"
        )

        mappingManager.handleControllerInput(inputEvent(button: .y, phase: .released))
        try expectEqual(
            keyboardOutput.events,
            [.modifierDown([.command]), .modifierUp([.command])],
            "modifier release sends keyUp"
        )
    }

    @MainActor
    private static func testMappingManagerReleasesHeldModifiers() throws {
        let permissionProvider = FakePermissionProvider(isTrusted: true)
        let keyboardOutput = FakeKeyboardOutputService()
        let mappingManager = makeMappingManager(
            permissionProvider: permissionProvider,
            keyboardOutput: keyboardOutput
        )

        mappingManager.handleControllerInput(inputEvent(button: .y, phase: .pressed))
        mappingManager.handleControllerInput(inputEvent(button: .a, phase: .pressed))
        try expectEqual(
            keyboardOutput.events,
            [
                .modifierDown([.command]),
                .keyCombo(key: .space, modifiers: [.command])
            ],
            "held modifiers combine with keyboard mappings"
        )

        keyboardOutput.events.removeAll()
        mappingManager.setMappingPaused(true)
        try expectEqual(
            keyboardOutput.events,
            [.modifierUp([.command])],
            "pausing mapping releases held modifiers"
        )

        mappingManager.setMappingPaused(false)
        keyboardOutput.events.removeAll()
        mappingManager.handleControllerInput(inputEvent(button: .y, phase: .pressed))
        mappingManager.updateMapping(KeyMapping(controllerButton: .y, key: .enter))
        try expectEqual(
            keyboardOutput.events,
            [.modifierDown([.command]), .modifierUp([.command])],
            "changing a modifier mapping releases its held modifier"
        )

        keyboardOutput.events.removeAll()
        mappingManager.handleControllerInput(inputEvent(button: .y, phase: .pressed))
        try expectEqual(
            keyboardOutput.events,
            [.keyCombo(key: .enter, modifiers: [])],
            "updated mapping is used after modifier release"
        )
    }

    private static func testRuntimeStatePriority() throws {
        let unauthorized = RuntimeState.make(
            isAccessibilityTrusted: false,
            currentControllerName: "Joy-Con",
            isTargetControllerSelected: true,
            isSelectedTargetConnected: true,
            selectedTargetControllerName: "Joy-Con",
            isMappingPaused: false
        )
        try expectEqual(unauthorized.level, .blocked, "missing permission blocks output")

        let paused = RuntimeState.make(
            isAccessibilityTrusted: true,
            currentControllerName: "Joy-Con",
            isTargetControllerSelected: true,
            isSelectedTargetConnected: false,
            selectedTargetControllerName: "Joy-Con",
            isMappingPaused: true
        )
        try expectEqual(paused.level, .paused, "pause status has priority after permission")

        let targetOffline = RuntimeState.make(
            isAccessibilityTrusted: true,
            currentControllerName: nil,
            isTargetControllerSelected: true,
            isSelectedTargetConnected: false,
            selectedTargetControllerName: "Joy-Con",
            isMappingPaused: false
        )
        try expectEqual(targetOffline.title, "目标手柄离线", "locked target offline does not become automatic")

        let unlocked = RuntimeState.make(
            isAccessibilityTrusted: true,
            currentControllerName: "Joy-Con",
            isTargetControllerSelected: false,
            isSelectedTargetConnected: true,
            selectedTargetControllerName: nil,
            isMappingPaused: false
        )
        try expectEqual(unlocked.title, "可以测试，建议锁定", "unlocked connected controller suggests lock")

        let ready = RuntimeState.make(
            isAccessibilityTrusted: true,
            currentControllerName: "Joy-Con",
            isTargetControllerSelected: true,
            isSelectedTargetConnected: true,
            selectedTargetControllerName: "Joy-Con",
            isMappingPaused: false
        )
        try expectEqual(ready.level, .ready, "trusted connected locked enabled is ready")
    }

    private static func testDiagnosticReportText() throws {
        let report = DiagnosticReport(
            appName: "JoyBridge-new",
            appVersion: "v0.10.0",
            releaseDate: "2026-05-11",
            bundleIdentifier: "cc.afterlight.JoyBridgeNew",
            macOSVersion: "Version 26.0",
            appPath: "/Users/hugh/Applications/JoyBridge-new.app",
            accessibilityStatus: "已授权",
            currentController: "Joy-Con (L/R)",
            targetControllerStatus: "已锁定且在线",
            targetControllerName: "Joy-Con (L/R)",
            latestButton: "A",
            latestButtonTime: "12:05:16 AM",
            mappingStatus: "已启用",
            mappingSummary: "总数 12，启用 12，禁用 0，无动作 0",
            mappingDetails: ["A：Space（启用）"],
            latestOutputResult: "已输出：Space"
        )
        let text = report.text

        try expectContains(text, "macOS 版本：Version 26.0", "diagnostic includes macOS version")
        try expectContains(text, "App 路径：/Users/hugh/Applications/JoyBridge-new.app", "diagnostic includes app path")
        try expectContains(text, "映射摘要：总数 12，启用 12，禁用 0，无动作 0", "diagnostic includes mapping summary")
        try expectContains(text, "最近输出结果：已输出：Space", "diagnostic includes latest output result")
        try expectContains(text, "- A：Space（启用）", "diagnostic includes mapping details")
    }

    private static func expectEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String) throws {
        guard actual == expected else {
            throw TestFailure("\(message): expected \(expected), got \(actual)")
        }
    }

    private static func expectContains(_ text: String, _ needle: String, _ message: String) throws {
        guard text.contains(needle) else {
            throw TestFailure("\(message): missing \(needle)")
        }
    }

    private static func expectSkip(
        _ decision: MappingExecutionDecision,
        reason: MappingSkipReason,
        _ message: String
    ) throws {
        guard decision == .skip(reason: reason) else {
            throw TestFailure("\(message): expected skip \(reason), got \(decision)")
        }
    }

    private static func expectExecute(
        _ decision: MappingExecutionDecision,
        action: MappingAction,
        _ message: String
    ) throws {
        switch decision {
        case let .execute(_, actualAction):
            try expectEqual(actualAction, action, message)
        case let .skip(reason):
            throw TestFailure("\(message): expected execute \(action), got skip \(reason)")
        }
    }

    @MainActor
    private static func makeMappingManager(
        permissionProvider: FakePermissionProvider,
        keyboardOutput: FakeKeyboardOutputService
    ) -> MappingManager {
        MappingManager(
            accessibilityPermissionManager: permissionProvider,
            keyboardOutputService: keyboardOutput,
            mappingStore: MemoryMappingStore(profile: mappingManagerTestProfile()),
            pauseStateStore: MemoryPauseStateStore()
        )
    }

    private static func mappingManagerTestProfile() -> MappingProfile {
        MappingProfile.defaultProfile(
            mappings: [
                KeyMapping(controllerButton: .a, key: .space),
                KeyMapping(controllerButton: .b, key: .enter, isEnabled: false),
                KeyMapping(controllerButton: .x, key: nil),
                KeyMapping(controllerButton: .y, key: nil, modifiers: [.command])
            ]
        )
    }

    private static func inputEvent(
        button: ControllerButton,
        phase: ControllerInputPhase
    ) -> ControllerInputEvent {
        ControllerInputEvent(
            controllerID: "controller-a",
            controllerName: "Test Controller",
            button: button,
            phase: phase,
            sourceProfile: "unit-test"
        )
    }

    private static func unwrap<T>(_ value: T?, _ message: String) throws -> T {
        guard let value else {
            throw TestFailure("missing \(message)")
        }

        return value
    }
}

@MainActor
private final class FakePermissionProvider: AccessibilityPermissionProviding {
    var isTrusted: Bool

    init(isTrusted: Bool) {
        self.isTrusted = isTrusted
    }
}

private final class FakeKeyboardOutputService: KeyboardOutputService {
    enum Event: Equatable {
        case keyCombo(key: KeyboardKey, modifiers: [KeyModifier])
        case modifierDown([KeyModifier])
        case modifierUp([KeyModifier])
    }

    var events: [Event] = []

    func sendKeyCombo(key: KeyboardKey, modifiers: [KeyModifier]) -> Bool {
        events.append(.keyCombo(key: key, modifiers: KeyModifier.orderedUnique(from: modifiers)))
        return true
    }

    func sendModifierKeyDown(modifiers: [KeyModifier]) -> Bool {
        events.append(.modifierDown(KeyModifier.orderedUnique(from: modifiers)))
        return true
    }

    func sendModifierKeyUp(modifiers: [KeyModifier]) -> Bool {
        events.append(.modifierUp(KeyModifier.orderedUnique(from: modifiers)))
        return true
    }
}

private final class MemoryMappingStore: MappingStore {
    private var profile: MappingProfile

    init(profile: MappingProfile) {
        self.profile = profile
    }

    func loadProfile() throws -> MappingProfile {
        profile
    }

    func saveProfile(_ profile: MappingProfile) throws {
        self.profile = profile
    }
}

private final class MemoryPauseStateStore: PauseStateStore {
    private var isPaused = false

    func loadMappingPaused() -> Bool {
        isPaused
    }

    func saveMappingPaused(_ isPaused: Bool) {
        self.isPaused = isPaused
    }
}

private struct TestFailure: Error, CustomStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }
}
