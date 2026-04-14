final class TransactionDetailsPresenterStub: TransactionDetailsPresenter {

    private weak var view: TransactionDetailsView?
    private let router: TransactionDetailsRouter
    private let id: TransactionID

    init(
        view: TransactionDetailsView,
        router: TransactionDetailsRouter,
        id: TransactionID
    ) {
        self.view = view
        self.router = router
        self.id = id
    }

    func didLoad() {
        view?.render(.loading)
        view?.render(.content(TransactionDetailsViewModel(
            title: "Transaction \(id)",
            amount: "$123.45",
            category: "Stub category",
            date: "Stub date",
            comment: "This is a stub details screen for transaction id \(id)."
        )))
    }

    func didTapDelete() {
        router.close()
    }

    func didTapClose() {
        router.close()
    }
}
