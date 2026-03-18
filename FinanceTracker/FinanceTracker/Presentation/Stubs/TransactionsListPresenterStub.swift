final class TransactionsListPresenterStub: TransactionsListPresenter {

    private weak var view: TransactionsListView?
    private let router: TransactionsListRouter

    init(view: TransactionsListView, router: TransactionsListRouter) {
        self.view = view
        self.router = router
    }

    func didLoad() {

        view?.render(.loading)

        let items = [
            TransactionItemViewModel(
                id: "1",
                title: "Coffee",
                subtitle: "Food",
                formattedAmount: "-350 Рублей"
            ),
            TransactionItemViewModel(
                id: "2",
                title: "Salary",
                subtitle: "Income",
                formattedAmount: "+15000 Рублей"
            )
        ]

        view?.render(.content(items))
    }

    func didSelectTransaction(id: TransactionID) {
        router.openTransactionDetails(id: id)
    }

    func didTapAddTransaction() {
        router.openAddTransaction()
    }
}
