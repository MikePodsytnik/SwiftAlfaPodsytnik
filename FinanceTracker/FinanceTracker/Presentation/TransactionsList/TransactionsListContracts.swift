protocol TransactionsListView: AnyObject {
    func render(_ state: TransactionsListViewState)
}

protocol TransactionsListPresenter: AnyObject {
    func didLoad()
    func didTapRetry()
    func didReachListEnd()
    func didSelectTransaction(id: TransactionID)
    func didTapAddTransaction()
}

protocol TransactionsListRouter {
    func openTransactionDetails(id: TransactionID)
    func openAddTransaction()
}
