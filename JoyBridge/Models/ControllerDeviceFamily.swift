import Foundation

enum ControllerDeviceFamily: String, Codable, CaseIterable, Identifiable {
    case nintendoJoyCon
    case switchProController
    case compatibleController
    case unknown

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .nintendoJoyCon:
            "Nintendo Joy-Con"
        case .switchProController:
            "Switch Pro Controller"
        case .compatibleController:
            "Compatible Controller"
        case .unknown:
            "Unknown Controller"
        }
    }
}
