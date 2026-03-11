import Foundation

enum AddTransactionViewState: Equatable {
    case idle
    case loading
    case validationError(String)
    case error(String)
}
