enum TransactionsListViewState: Equatable {
    case idle
    case loading
    case content([TransactionItemViewModel], isNextPageLoading: Bool)
    case empty
    case error(String)
}
