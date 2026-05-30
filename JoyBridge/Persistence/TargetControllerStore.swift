import Foundation

struct StoredTargetController: Equatable {
    let id: String
    let name: String
}

protocol TargetControllerStore {
    func loadTargetController() -> StoredTargetController?
    func saveTargetController(id: String, name: String)
    func clearTargetController()
}

final class UserDefaultsTargetControllerStore: TargetControllerStore {
    private let userDefaults: UserDefaults
    private let idKey: String
    private let nameKey: String

    init(
        userDefaults: UserDefaults = .standard,
        idKey: String = "joybridge.targetControllerID",
        nameKey: String = "joybridge.targetControllerName"
    ) {
        self.userDefaults = userDefaults
        self.idKey = idKey
        self.nameKey = nameKey
    }

    func loadTargetController() -> StoredTargetController? {
        guard
            let id = userDefaults.string(forKey: idKey),
            let name = userDefaults.string(forKey: nameKey)
        else {
            return nil
        }

        return StoredTargetController(id: id, name: name)
    }

    func saveTargetController(id: String, name: String) {
        userDefaults.set(id, forKey: idKey)
        userDefaults.set(name, forKey: nameKey)
    }

    func clearTargetController() {
        userDefaults.removeObject(forKey: idKey)
        userDefaults.removeObject(forKey: nameKey)
    }
}
