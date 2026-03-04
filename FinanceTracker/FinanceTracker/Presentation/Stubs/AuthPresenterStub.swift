final class AuthPresenterStub: AuthPresenter {

    private weak var view: AuthView?
    private let router: AuthRouter

    init(view: AuthView, router: AuthRouter) {
        self.view = view
        self.router = router
    }

    func didLoad() {
        view?.render(.idle)
    }

    func didTapLogin(email: String, password: String) {
        view?.render(.loading)

        let session = UserSession(token: "stub_token", userId: "stub_user")
        router.openTransactionsList(session: session)
    }
}
