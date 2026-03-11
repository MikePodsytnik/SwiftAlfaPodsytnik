import UIKit

final class AuthAssembly {
    func build(navigationController: UINavigationController) -> UIViewController {
        let viewController = AuthViewController()

        let repository = AuthRepositoryImpl()
        let useCase = LoginUseCaseImpl(repository: repository)
        let router = AuthRouterImpl(navigationController: navigationController)

        let presenter = AuthPresenterImpl(
            view: viewController,
            loginUseCase: useCase,
            router: router
        )

        viewController.presenter = presenter
        return viewController
    }
}
