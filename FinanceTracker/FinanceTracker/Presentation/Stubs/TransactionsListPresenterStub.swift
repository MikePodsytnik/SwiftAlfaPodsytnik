final class TransactionsListPresenterStub: TransactionsListPresenter {

    private weak var view: TransactionsListView?
    private let router: TransactionsListRouter

    init(view: TransactionsListView, router: TransactionsListRouter) {
        self.view = view
        self.router = router
    }

    func didLoad() {
        view?.render(.loading)
        view?.render(.empty) 
    }

    func didSelectTransaction(id: TransactionID) {
        router.openTransactionDetails(id: id)
    }

    func didTapAddTransaction() {
        router.openAddTransaction()
    }
}
