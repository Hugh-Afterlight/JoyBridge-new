import Foundation

@MainActor
protocol AccessibilityPermissionProviding: AnyObject {
    var isTrusted: Bool { get }
}
