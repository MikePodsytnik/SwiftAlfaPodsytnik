import UIKit

final class TransactionsListAssembly {
    func build(
        navigationController: UINavigationController,
        session: UserSession
    ) -> UIViewController {
        let viewController = TransactionsListViewController()

        let router = TransactionsListRouterImpl(
            navigationController: navigationController,
            session: session
        )

        let presenter = TransactionsListPresenterStub(
            view: viewController,
            router: router
        )

        viewController.presenter = presenter
        return viewController
    }
}
