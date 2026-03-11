import UIKit

enum AuthAssembly {
    static func build(navigationController: UINavigationController) -> UIViewController {
        let viewController = AuthViewController()
        let router = AuthRouterImpl(navigationController: navigationController)

        let presenter = AuthPresenterStub(
            view: viewController,
            router: router
        )

        viewController.presenter = presenter
        return viewController
    }
}
