import Foundation

enum MappingCatalog {
    static let defaultProfileName = "Default Controller Mapping"

    static func defaultMappings() -> [KeyMapping] {
        [
            KeyMapping(controllerButton: .a, key: .space),
            KeyMapping(controllerButton: .b, key: .escape),
            KeyMapping(controllerButton: .x, key: .c, modifiers: [.command]),
            KeyMapping(controllerButton: .y, key: .v, modifiers: [.command]),
            KeyMapping(controllerButton: .leftShoulder, key: .leftArrow, modifiers: [.command]),
            KeyMapping(controllerButton: .rightShoulder, key: .rightArrow, modifiers: [.command]),
            KeyMapping(controllerButton: .leftTrigger, key: .pageUp),
            KeyMapping(controllerButton: .rightTrigger, key: .pageDown),
            KeyMapping(controllerButton: .dpadUp, key: .upArrow),
            KeyMapping(controllerButton: .dpadDown, key: .downArrow),
            KeyMapping(controllerButton: .dpadLeft, key: .leftArrow),
            KeyMapping(controllerButton: .dpadRight, key: .rightArrow)
        ]
    }

    static func normalizedMappings(_ sourceMappings: [KeyMapping]) -> [KeyMapping] {
        let defaults = defaultMappings()

        return ControllerButton.mappableButtons.compactMap { button in
            if let mapping = sourceMappings.first(where: { $0.controllerButton == button }) {
                return mapping.normalized()
            }

            return defaults.first { $0.controllerButton == button }
        }
    }

    static func updating(_ mapping: KeyMapping, in mappings: [KeyMapping]) -> [KeyMapping] {
        let normalizedMapping = mapping.normalized()
        var updatedMappings = mappings

        if let index = updatedMappings.firstIndex(where: { $0.controllerButton == normalizedMapping.controllerButton }) {
            updatedMappings[index] = normalizedMapping
        } else {
            updatedMappings.append(normalizedMapping)
        }

        return normalizedMappings(updatedMappings)
    }
}
