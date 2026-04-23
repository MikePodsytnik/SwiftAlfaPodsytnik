import UIKit

final class TextFieldMapper: BDUIViewMapping {
    let supportedType: BDUIViewType = .textField

    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView {
        guard case let .textField(content) = node.payload else {
            return UIView()
        }

        let textField = DSTextField(title: content.title, placeholder: content.placeholder)
        textField.text = content.text
        textField.isSecureTextEntry = content.isSecureTextEntry ?? false

        if let keyboardType = content.keyboardType, let value = UIKeyboardType(rawValue: keyboardType) {
            textField.keyboardType = value
        } else {
            textField.keyboardType = .default
        }

        if let returnKeyType = content.returnKeyType, let value = UIReturnKeyType(rawValue: returnKeyType) {
            textField.returnKeyType = value
        } else {
            textField.returnKeyType = .default
        }

        switch content.state ?? .normal {
        case .normal:
            textField.setState(.normal)
        case .focused:
            textField.setState(.focused)
        case .error:
            textField.setState(.error(content.errorMessage ?? "Ошибка"))
        case .disabled:
            textField.setState(.disabled)
        }

        return textField
    }
}
