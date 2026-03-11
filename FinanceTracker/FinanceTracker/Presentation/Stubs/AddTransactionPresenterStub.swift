import Foundation

final class AddTransactionPresenterStub: AddTransactionPresenter {

    private weak var view: AddTransactionView?
    private let router: AddTransactionRouter

    init(view: AddTransactionView, router: AddTransactionRouter) {
        self.view = view
        self.router = router
    }

    func didLoad() {
        view?.render(.idle)
    }

    func didTapSave(amount: Decimal, category: String, date: Date, comment: String?) {
        router.close()
    }

    func didTapCancel() {
        router.close()
    }
}
