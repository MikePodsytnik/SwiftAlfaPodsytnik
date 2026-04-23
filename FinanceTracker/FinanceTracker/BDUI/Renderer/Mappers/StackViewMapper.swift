import UIKit

final class StackViewMapper: BDUIViewMapping {
    let supportedType: BDUIViewType = .stackView

    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView {
        guard case let .stackView(content) = node.payload else {
            return UIView()
        }

        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = content.axis?.value ?? .vertical
        view.spacing = content.spacing?.value ?? DS.Spacing.m
        view.alignment = content.alignment?.stackValue ?? .fill
        view.distribution = content.distribution?.value ?? .fill
        return view
    }
}
