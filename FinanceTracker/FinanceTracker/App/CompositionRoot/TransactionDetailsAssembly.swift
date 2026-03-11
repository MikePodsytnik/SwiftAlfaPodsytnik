import UIKit

final class TransactionDetailsAssembly {
    func build(
        navigationController: UINavigationController,
        id: TransactionID,
        session: UserSession
    ) -> UIViewController {
        let viewController = TransactionDetailsViewController()

        let router = TransactionDetailsRouterImpl(
            navigationController: navigationController
        )

        let presenter = TransactionDetailsPresenterStub(
            view: viewController,
            router: router
        )

        viewController.presenter = presenter
        return viewController
    }
}
