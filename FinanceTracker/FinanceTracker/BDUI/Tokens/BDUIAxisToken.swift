import UIKit

enum BDUIAxisToken: String, Decodable {
    case vertical
    case horizontal

    var value: NSLayoutConstraint.Axis {
        switch self {
        case .vertical:
            return .vertical
        case .horizontal:
            return .horizontal
        }
    }
}
