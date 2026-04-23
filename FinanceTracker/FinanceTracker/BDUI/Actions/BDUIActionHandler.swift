import UIKit

class BDUIActionHandler: BDUIActionHandling {
    let context: BDUIActionContext

    init(context: BDUIActionContext) {
        self.context = context
    }

    func handle(action: BDUIAction, from sourceView: UIView?) {
        switch action.type {
        case .print:
            context.onPrint?(action.message ?? "")
        case .route:
            guard let route = action.route else { return }
            context.onRoute?(route, sourceView)
        case .reload:
            context.onReload?(sourceView)
        case .custom:
            guard let name = action.name else { return }
            context.onCustom?(name, action.payload, sourceView)
        case .none:
            break
        }
    }
}
