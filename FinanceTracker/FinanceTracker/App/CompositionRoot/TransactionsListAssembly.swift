import UIKit

final class TransactionsListAssembly {
    func build(
        navigationController: UINavigationController,
        session: UserSession
    ) -> UIViewController {
        let viewController = TransactionsListViewController()

        let networkClient = URLSessionNetworkClient()
        let pageCache = TransactionsPageCacheImpl()
        let repository = TransactionsRepositoryImpl(
            networkClient: networkClient,
            pageCache: pageCache
        )
        let useCase = FetchTransactionsPageUseCaseImpl(repository: repository)

        let router = TransactionsListRouterImpl(
            navigationController: navigationController,
            session: session
        )

        let presenter = TransactionsListPresenterImpl(
            view: viewController,
            router: router,
            fetchTransactionsPageUseCase: useCase,
            session: session
        )

        viewController.presenter = presenter
        return viewController
    }
}
