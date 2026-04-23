import UIKit

final class ButtonMapper: BDUIViewMapping {
    let supportedType: BDUIViewType = .button

    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView {
        guard case let .button(content) = node.payload else {
            return UIView()
        }

        let button = DSButton(style: content.style?.value ?? .primary)
        button.configure(title: content.title)
        button.setState(content.state?.value ?? .normal)

        if let action = node.action {
            button.addAction(
                UIAction { [weak actionHandler, weak button] _ in
                    actionHandler?.handle(action: action, from: button)
                },
                for: .touchUpInside
            )
        }

        return button
    }
}
