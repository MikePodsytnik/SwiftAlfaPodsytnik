import UIKit

final class LabelMapper: BDUIViewMapping {
    let supportedType: BDUIViewType = .label

    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView {
        guard case let .label(content) = node.payload else {
            return UIView()
        }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = content.text
        label.numberOfLines = content.numberOfLines ?? 0
        label.textAlignment = mapAlignment(content.textAlignment)

        if let typography = content.typography {
            label.font = typography.font
            label.textColor = content.textColor?.value ?? typography.color
        } else {
            label.apply(.body)
            if let textColor = content.textColor {
                label.textColor = textColor.value
            }
        }

        return label
    }

    private func mapAlignment(_ value: String?) -> NSTextAlignment {
        switch value {
        case "left":
            return .left
        case "center":
            return .center
        case "right":
            return .right
        case "justified":
            return .justified
        case "natural", nil:
            return .natural
        default:
            return .natural
        }
    }
}
