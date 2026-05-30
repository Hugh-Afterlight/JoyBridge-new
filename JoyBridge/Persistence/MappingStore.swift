import Foundation

protocol MappingStore {
    func loadProfile() throws -> MappingProfile
    func saveProfile(_ profile: MappingProfile) throws
}

protocol PauseStateStore {
    func loadMappingPaused() -> Bool
    func saveMappingPaused(_ isPaused: Bool)
}
