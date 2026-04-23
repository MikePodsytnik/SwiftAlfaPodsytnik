import UIKit

enum BDUITypographyToken: String, Decodable {
    case largeTitle
    case title
    case headline
    case body
    case bodyMedium
    case caption
    case error
    case button

    var textStyle: TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .headline:
            return .headline
        case .body:
            return .body
        case .bodyMedium:
            return .bodyMedium
        case .caption:
            return .caption
        case .error:
            return .error
        case .button:
            return .button
        }
    }

    var font: UIFont {
        DS.Typography.font(for: textStyle)
    }

    var color: UIColor {
        DS.Typography.color(for: textStyle)
    }
}
