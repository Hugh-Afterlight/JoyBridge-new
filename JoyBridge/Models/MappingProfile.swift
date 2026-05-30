import Foundation

struct MappingProfile: Codable, Identifiable, Equatable {
    static let defaultID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    var id: UUID
    var name: String
    var deviceFamily: ControllerDeviceFamily
    var mappings: [KeyMapping]
    var isDefault: Bool

    init(
        id: UUID = Self.defaultID,
        name: String = MappingCatalog.defaultProfileName,
        deviceFamily: ControllerDeviceFamily = .compatibleController,
        mappings: [KeyMapping] = MappingCatalog.defaultMappings(),
        isDefault: Bool = true
    ) {
        self.id = id
        self.name = name
        self.deviceFamily = deviceFamily
        self.mappings = MappingCatalog.normalizedMappings(mappings)
        self.isDefault = isDefault
    }

    static func defaultProfile(mappings: [KeyMapping] = MappingCatalog.defaultMappings()) -> MappingProfile {
        MappingProfile(mappings: mappings)
    }

    func normalized() -> MappingProfile {
        MappingProfile(
            id: id,
            name: name,
            deviceFamily: deviceFamily,
            mappings: mappings,
            isDefault: isDefault
        )
    }

    func mapping(for button: ControllerButton) -> KeyMapping? {
        mappings.first { $0.controllerButton == button }
    }

    func updatingMapping(_ mapping: KeyMapping) -> MappingProfile {
        MappingProfile(
            id: id,
            name: name,
            deviceFamily: deviceFamily,
            mappings: MappingCatalog.updating(mapping, in: mappings),
            isDefault: isDefault
        )
    }
}
