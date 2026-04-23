import UIKit

enum BDUIAlignmentToken: String, Decodable {
    case fill
    case leading
    case center
    case trailing
    case top
    case bottom

    var stackValue: UIStackView.Alignment {
        switch self {
        case .fill:
            return .fill
        case .leading, .top:
            return .leading
        case .center:
            return .center
        case .trailing, .bottom:
            return .trailing
        }
    }
}
