import UIKit

final class TransactionDetailsRouterImpl: TransactionDetailsRouter {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
}
