final class AuthPresenterImpl: AuthPresenter {

    private weak var view: AuthView?
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
            let session = try loginUseCase.execute(
                email: email,
                password: password
            )

            router.openTransactionsList(session: session)

        } catch {
            view?.render(.error("Invalid email or password"))
        }
    }
}
