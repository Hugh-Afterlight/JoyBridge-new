import Foundation

protocol KeyboardOutputService {
    @discardableResult
    func sendKeyCombo(key: KeyboardKey, modifiers: [KeyModifier]) -> Bool

    @discardableResult
    func sendModifierKeyDown(modifiers: [KeyModifier]) -> Bool

    @discardableResult
    func sendModifierKeyUp(modifiers: [KeyModifier]) -> Bool
}

extension KeyboardEventSender: KeyboardOutputService {}
