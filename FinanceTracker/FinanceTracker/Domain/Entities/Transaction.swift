import Foundation

struct Transaction: Equatable {
    let id: TransactionID
    let amount: Decimal
    let category: String
    let date: Date
    let comment: String?
}
