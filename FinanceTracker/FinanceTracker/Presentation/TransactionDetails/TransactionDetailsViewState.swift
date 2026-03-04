enum TransactionDetailsViewState: Equatable {
    case loading
    case content(TransactionDetailsViewModel)
    case error(String)
}
