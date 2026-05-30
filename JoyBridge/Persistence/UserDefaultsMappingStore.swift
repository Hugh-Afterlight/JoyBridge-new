import Foundation

enum MappingStoreError: Error {
    case corruptedProfile(Error)
    case saveFailed(Error)
}

final class UserDefaultsMappingStore: MappingStore {
    private let userDefaults: UserDefaults
    private let profileKey: String
    private let legacyMappingsKey: String

    init(
        userDefaults: UserDefaults = .standard,
        profileKey: String = "joybridge.mappingProfile",
        legacyMappingsKey: String = "joybridge.keyMappings"
    ) {
        self.userDefaults = userDefaults
        self.profileKey = profileKey
        self.legacyMappingsKey = legacyMappingsKey
    }

    func loadProfile() throws -> MappingProfile {
        if let profileData = userDefaults.data(forKey: profileKey) {
            do {
                return try JSONDecoder()
                    .decode(MappingProfile.self, from: profileData)
                    .normalized()
            } catch {
                throw MappingStoreError.corruptedProfile(error)
            }
        }

        if let legacyData = userDefaults.data(forKey: legacyMappingsKey) {
            do {
                let legacyMappings = try JSONDecoder().decode([KeyMapping].self, from: legacyData)
                let migratedProfile = MappingProfile.defaultProfile(mappings: legacyMappings)
                try saveProfile(migratedProfile)
                return migratedProfile
            } catch {
                throw MappingStoreError.corruptedProfile(error)
            }
        }

        let defaultProfile = MappingProfile.defaultProfile()
        try saveProfile(defaultProfile)
        return defaultProfile
    }

    func saveProfile(_ profile: MappingProfile) throws {
        do {
            let data = try JSONEncoder().encode(profile.normalized())
            userDefaults.set(data, forKey: profileKey)
        } catch {
            throw MappingStoreError.saveFailed(error)
        }
    }
}

final class UserDefaultsPauseStateStore: PauseStateStore {
    private let userDefaults: UserDefaults
    private let pausedKey: String

    init(
        userDefaults: UserDefaults = .standard,
        pausedKey: String = "joybridge.mappingPaused"
    ) {
        self.userDefaults = userDefaults
        self.pausedKey = pausedKey
    }

    func loadMappingPaused() -> Bool {
        userDefaults.bool(forKey: pausedKey)
    }

    func saveMappingPaused(_ isPaused: Bool) {
        userDefaults.set(isPaused, forKey: pausedKey)
    }
}
