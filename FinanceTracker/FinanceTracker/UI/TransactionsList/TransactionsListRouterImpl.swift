import UIKit

final class TransactionsListRouterImpl: TransactionsListRouter {

    private weak var navigationController: UINavigationController?
    private let session: UserSession

    init(navigationController: UINavigationController, session: UserSession) {
        self.navigationController = navigationController
        self.session = session
    }

    func openTransactionDetails(id: TransactionID) {
        guard let navigationController else { return }
        let vc = TransactionDetailsAssembly.build(
            navigationController: navigationController,
            id: id,
            session: session
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func openAddTransaction() {
        guard let navigationController else { return }
        let vc = AddTransactionAssembly.build(
            navigationController: navigationController,
            session: session
        )
        navigationController.pushViewController(vc, animated: true)
    }
}
