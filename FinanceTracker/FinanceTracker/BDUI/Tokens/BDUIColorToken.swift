import UIKit

enum BDUIColorToken: String, Decodable {
    case background
    case surface
    case primary
    case primaryPressed
    case secondary
    case textPrimary
    case textSecondary
    case textOnPrimary
    case error
    case success
    case border
    case fieldBackground
    case divider

    var value: UIColor {
        switch self {
        case .background:
            return DS.Colors.background
        case .surface:
            return DS.Colors.surface
        case .primary:
            return DS.Colors.primary
        case .primaryPressed:
            return DS.Colors.primaryPressed
        case .secondary:
            return DS.Colors.secondary
        case .textPrimary:
            return DS.Colors.textPrimary
        case .textSecondary:
            return DS.Colors.textSecondary
        case .textOnPrimary:
            return DS.Colors.textOnPrimary
        case .error:
            return DS.Colors.error
        case .success:
            return DS.Colors.success
        case .border:
            return DS.Colors.border
        case .fieldBackground:
            return DS.Colors.fieldBackground
        case .divider:
            return DS.Colors.divider
        }
    }
}
