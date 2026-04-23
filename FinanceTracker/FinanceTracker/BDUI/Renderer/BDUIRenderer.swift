import UIKit

final class BDUIRenderer: BDUINodeRendering {
    private let mappers: [BDUIViewType: BDUIViewMapping]
    private weak var actionHandler: BDUIActionHandling?

    init(
        mappers: [BDUIViewMapping] = BDUIViewFactory.makeDefaultMappers(),
        actionHandler: BDUIActionHandling? = nil
    ) {
        self.mappers = Dictionary(uniqueKeysWithValues: mappers.map { ($0.supportedType, $0) })
        self.actionHandler = actionHandler
    }

    func render(node: BDUINode) -> UIView {
        guard let mapper = mappers[node.type] else {
            return UIView()
        }

        let view = mapper.makeView(for: node, actionHandler: actionHandler)
        attachSubviews(node.subviews, to: view)
        view.applyBDUILayout(node.layout)
        return view
    }

    private func attachSubviews(_ nodes: [BDUINode], to parent: UIView) {
        guard !nodes.isEmpty else { return }

        if let container = parent as? BDUIChildContaining {
            nodes
                .map(render(node:))
                .forEach(container.addBDUIChild(_:))
            return
        }

        if let stackView = parent as? UIStackView {
            nodes
                .map(render(node:))
                .forEach(stackView.addArrangedSubview(_:))
        }
    }
}
