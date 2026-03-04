protocol TransactionsListView: AnyObject {
    func render(_ state: TransactionsListViewState)
}

protocol TransactionsListPresenter {
    func didLoad()
    func didSelectTransaction(id: TransactionID)
    func didTapAddTransaction()
}

protocol TransactionsListRouter {
    func openTransactionDetails(id: TransactionID)
    func openAddTransaction()
}
