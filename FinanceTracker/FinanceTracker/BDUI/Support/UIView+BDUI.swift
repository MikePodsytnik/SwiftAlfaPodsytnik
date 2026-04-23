import UIKit

extension UIView {
    func applyBDUILayout(_ layout: BDUILayout?) {
        guard let layout else { return }

        if let backgroundColor = layout.backgroundColor {
            self.backgroundColor = backgroundColor.value
        }

        if let cornerRadius = layout.cornerRadius {
            layer.cornerRadius = cornerRadius.value
            clipsToBounds = true
        }

        if let width = layout.width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = layout.height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let padding = layout.padding?.uiInsets {
            if let container = self as? BDUIContainerView {
                container.updatePadding(padding)
            } else if let stackView = self as? UIStackView {
                stackView.isLayoutMarginsRelativeArrangement = true
                stackView.layoutMargins = padding
            }
        }
    }
}
