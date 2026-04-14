enum TransactionsListPaginationState: Equatable {
    case idle
    case loading
}

enum TransactionsListContentUpdate: Equatable {
    case none
    case reload
    case append(newItems: [TransactionItemViewModel])
}

enum TransactionsListViewState: Equatable {
    case idle
    case loading
    case content(
        items: [TransactionItemViewModel],
        update: TransactionsListContentUpdate,
        pagination: TransactionsListPaginationState
    )
    case empty
    case error(String)
}
