import Foundation

protocol AuthView: AnyObject {
    func render(_ state: AuthViewState)
}

protocol AuthPresenter: AnyObject {
    func didLoad()
    func didTapLogin(email: String, password: String)
}

protocol AuthRouter {
    func openTransactionsList(session: UserSession)
}
