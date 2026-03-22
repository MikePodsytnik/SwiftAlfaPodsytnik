import UIKit

final class AuthRouterImpl: AuthRouter {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func openTransactionsList(session: UserSession) {
        guard let navigationController else { return }

        let viewController = TransactionsListAssembly().build(
            navigationController: navigationController,
            session: session
        )

        navigationController.setViewControllers([viewController], animated: true)
    }
}
