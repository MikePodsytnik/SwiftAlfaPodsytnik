import UIKit

final class AddTransactionRouterImpl: AddTransactionRouter {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
}
