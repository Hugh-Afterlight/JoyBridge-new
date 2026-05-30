import Foundation

enum ControllerInputPhase: String, Equatable {
    case pressed
    case released
}

struct ControllerInputEvent: Equatable {
    let controllerID: String
    let controllerName: String
    let button: ControllerButton
    let phase: ControllerInputPhase
    let sourceProfile: String
}
