import UIKit

enum BDUIDistributionToken: String, Decodable {
    case fill
    case fillEqually
    case fillProportionally
    case equalSpacing
    case equalCentering

    var value: UIStackView.Distribution {
        switch self {
        case .fill:
            return .fill
        case .fillEqually:
            return .fillEqually
        case .fillProportionally:
            return .fillProportionally
        case .equalSpacing:
            return .equalSpacing
        case .equalCentering:
            return .equalCentering
        }
    }
}
