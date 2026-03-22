final class AuthPresenterImpl: AuthPresenter {
    weak var view: AuthView?
    private let loginUseCase: LoginUseCase
    private let router: AuthRouter

    init(
        view: AuthView,
        loginUseCase: LoginUseCase,
        router: AuthRouter
    ) {
        self.view = view
        self.loginUseCase = loginUseCase
        self.router = router
    }

    func didLoad() {
        view?.render(.idle)
    }

    func didTapLogin(email: String, password: String) {
        view?.render(.loading)

        do {
            let session = try loginUseCase.execute(email: email, password: password)
            router.openTransactionsList(session: session)
        } catch let error as AuthError {
            view?.render(.error(error.localizedDescription))
        } catch {
            view?.render(.error("Something went wrong"))
        }
    }
}
