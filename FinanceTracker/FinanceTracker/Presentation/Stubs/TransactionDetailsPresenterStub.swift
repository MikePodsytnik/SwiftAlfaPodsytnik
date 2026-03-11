final class TransactionDetailsPresenterStub: TransactionDetailsPresenter {

    private weak var view: TransactionDetailsView?
    private let router: TransactionDetailsRouter

    init(view: TransactionDetailsView, router: TransactionDetailsRouter) {
        self.view = view
        self.router = router
    }

    func didLoad() {
        view?.render(.loading)
        view?.render(.content(TransactionDetailsViewModel(
            title: "Stub",
            amount: "0",
            category: "Stub",
            date: "—",
            comment: nil
        )))
    }

    func didTapDelete() {
        router.close()
    }

    func didTapClose() {
        router.close()
    }
}
