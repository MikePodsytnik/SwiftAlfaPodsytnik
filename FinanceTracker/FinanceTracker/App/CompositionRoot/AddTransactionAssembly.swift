import UIKit

enum AddTransactionAssembly {
    static func build(
        navigationController: UINavigationController,
        session: UserSession
    ) -> UIViewController {

        let viewController = AddTransactionViewController()

        let router = AddTransactionRouterImpl(
            navigationController: navigationController
        )

        let presenter = AddTransactionPresenterStub(
            view: viewController,
            router: router,
        )

        viewController.presenter = presenter
        return viewController
    }
}
