import Foundation

enum BDUIButtonStyleToken: String, Decodable {
    case primary
    case secondary
    case destructive

    var value: DSButton.Style {
        switch self {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .destructive:
            return .destructive
        }
    }
}

enum BDUIButtonStateToken: String, Decodable {
    case normal
    case loading
    case disabled

    var value: DSButton.State {
        switch self {
        case .normal:
            return .normal
        case .loading:
            return .loading
        case .disabled:
            return .disabled
        }
    }
}
