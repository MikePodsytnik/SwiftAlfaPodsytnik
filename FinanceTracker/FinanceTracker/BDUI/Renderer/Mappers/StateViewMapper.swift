import UIKit

final class StateViewMapper: BDUIViewMapping {
    let supportedType: BDUIViewType = .stateView

    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView {
        guard case let .stateView(content) = node.payload else {
            return UIView()
        }

        let view = DSStateView()

        let action: (() -> Void)? = node.action.map { action in
            { [weak actionHandler, weak view] in
                actionHandler?.handle(action: action, from: view)
            }
        }

        switch content.state {
        case .loading:
            view.configure(
                state: .loading(title: content.title, message: content.message),
                action: action
            )
        case .empty:
            view.configure(
                state: .empty(title: content.title, message: content.message, buttonTitle: content.buttonTitle),
                action: action
            )
        case .error:
            view.configure(
                state: .error(title: content.title, message: content.message, buttonTitle: content.buttonTitle),
                action: action
            )
        }

        return view
    }
}
