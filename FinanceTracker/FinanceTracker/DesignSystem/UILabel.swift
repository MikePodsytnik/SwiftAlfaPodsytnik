import UIKit

extension UILabel {
    func apply(_ style: TextStyle) {
        font = DS.Typography.font(for: style)
        textColor = DS.Typography.color(for: style)
    }
}
