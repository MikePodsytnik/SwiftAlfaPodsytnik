enum TransactionsListViewState: Equatable {
    case loading
    case content([TransactionItemViewModel])
    case empty
    case error(String)
}
