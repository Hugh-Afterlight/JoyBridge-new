import Foundation

@MainActor
protocol ControllerInputHandling: AnyObject {
    func handleControllerInput(_ event: ControllerInputEvent)
}

@MainActor
protocol OutputStateResetting: AnyObject {
    func releaseAllHeldOutputs()
}

typealias ControllerInputRuntime = ControllerInputHandling & OutputStateResetting
