import UIKit

enum DS {
    enum Colors {
        static let background = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.08, green: 0.08, blue: 0.09, alpha: 1)
            : UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        }

        static let surface = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1)
            : UIColor.white
        }

        static let primary = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
            : UIColor(red: 0.10, green: 0.10, blue: 0.11, alpha: 1)
        }

        static let primaryPressed = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.66, green: 0.66, blue: 0.70, alpha: 1)
            : UIColor(red: 0.46, green: 0.46, blue: 0.50, alpha: 1)
        }

        static let secondary = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
            : UIColor(red: 0.80, green: 0.90, blue: 0.90, alpha: 1)
        }

        static let textPrimary = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
            : UIColor(red: 0.10, green: 0.10, blue: 0.11, alpha: 1)
        }

        static let textSecondary = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.66, green: 0.66, blue: 0.70, alpha: 1)
            : UIColor(red: 0.46, green: 0.46, blue: 0.50, alpha: 1)
        }

        static let textOnPrimary = UIColor.white

        static let error = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 1.00, green: 0.40, blue: 0.40, alpha: 1)
            : UIColor(red: 0.78, green: 0.08, blue: 0.08, alpha: 1)
        }

        static let success = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.36, green: 0.76, blue: 0.45, alpha: 1)
            : UIColor(red: 0.18, green: 0.62, blue: 0.29, alpha: 1)
        }

        static let border = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.26, green: 0.26, blue: 0.29, alpha: 1)
            : UIColor(red: 0.87, green: 0.87, blue: 0.89, alpha: 1)
        }

        static let fieldBackground = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.17, green: 0.17, blue: 0.19, alpha: 1)
            : UIColor(red: 0.99, green: 0.99, blue: 0.995, alpha: 1)
        }

        static let divider = UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1)
            : UIColor(red: 0.91, green: 0.91, blue: 0.93, alpha: 1)
        }
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    enum Radius {
        static let s: CGFloat = 10
        static let m: CGFloat = 14
        static let l: CGFloat = 18
    }

    enum Typography {
        static func font(for style: TextStyle) -> UIFont {
            switch style {
            case .largeTitle:
                return .systemFont(ofSize: 30, weight: .bold)
            case .title:
                return .systemFont(ofSize: 22, weight: .bold)
            case .headline:
                return .systemFont(ofSize: 17, weight: .semibold)
            case .body:
                return .systemFont(ofSize: 16, weight: .regular)
            case .bodyMedium:
                return .systemFont(ofSize: 16, weight: .medium)
            case .caption:
                return .systemFont(ofSize: 13, weight: .regular)
            case .error:
                return .systemFont(ofSize: 14, weight: .medium)
            case .button:
                return .systemFont(ofSize: 16, weight: .semibold)
            }
        }

        static func color(for style: TextStyle) -> UIColor {
            switch style {
            case .largeTitle, .title, .headline, .body, .bodyMedium:
                return DS.Colors.textPrimary
            case .caption:
                return DS.Colors.textSecondary
            case .error:
                return DS.Colors.error
            case .button:
                return DS.Colors.textOnPrimary
            }
        }
    }
}

enum TextStyle {
    case largeTitle
    case title
    case headline
    case body
    case bodyMedium
    case caption
    case error
    case button
}
