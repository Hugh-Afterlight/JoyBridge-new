import Foundation

struct TargetControllerRule {
    nonisolated init() {}

    func accepts(controllerID: String, selectedTargetControllerID: String?) -> Bool {
        guard let selectedTargetControllerID else {
            return true
        }

        return controllerID == selectedTargetControllerID
    }
}
