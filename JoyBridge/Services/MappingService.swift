import Foundation

struct MappingExecutionContext: Equatable {
    let isPaused: Bool
    let isAccessibilityTrusted: Bool
}

enum MappingSkipReason: Equatable {
    case paused
    case missingMapping
    case disabled
    case missingAccessibilityPermission
    case noAction
}

enum MappingExecutionDecision: Equatable {
    case execute(mapping: KeyMapping, action: MappingAction)
    case skip(reason: MappingSkipReason)
}

struct MappingService {
    nonisolated init() {}

    func mapping(for button: ControllerButton, in profile: MappingProfile) -> KeyMapping? {
        profile.mapping(for: button)
    }

    func executionDecision(
        for button: ControllerButton,
        in profile: MappingProfile,
        context: MappingExecutionContext
    ) -> MappingExecutionDecision {
        if context.isPaused {
            return .skip(reason: .paused)
        }

        guard let mapping = mapping(for: button, in: profile) else {
            return .skip(reason: .missingMapping)
        }

        guard mapping.isEnabled else {
            return .skip(reason: .disabled)
        }

        guard context.isAccessibilityTrusted else {
            return .skip(reason: .missingAccessibilityPermission)
        }

        let action = mapping.action
        guard action != .none else {
            return .skip(reason: .noAction)
        }

        return .execute(mapping: mapping, action: action)
    }
}
