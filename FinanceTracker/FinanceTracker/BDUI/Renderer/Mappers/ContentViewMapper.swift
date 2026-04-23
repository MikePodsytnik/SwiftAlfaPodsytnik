import UIKit

final class ContentViewMapper: BDUIViewMapping {
    let supportedType: BDUIViewType = .contentView

    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView {
        guard case let .contentView(content) = node.payload else {
            return UIView()
        }

        let view = BDUIContainerView()
        view.backgroundColor = content.backgroundColor?.value ?? DS.Colors.surface
        view.layer.cornerRadius = content.cornerRadius?.value ?? DS.Radius.m
        view.clipsToBounds = true

        view.stackView.axis = content.axis?.value ?? .vertical
        view.stackView.spacing = content.spacing?.value ?? DS.Spacing.m
        view.stackView.alignment = content.alignment?.stackValue ?? .fill
        view.stackView.distribution = content.distribution?.value ?? .fill
        view.updatePadding(content.padding?.uiInsets ?? .zero)

        return view
    }
}
