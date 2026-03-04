import Foundation

final class TransactionsRepositoryImpl: TransactionsRepository {

    func fetchTransactions(userId: UserID) throws -> [Transaction] {
        return []
    }

    func fetchTransaction(id: TransactionID) throws -> Transaction {
        return Transaction(
            id: id,
            amount: 0,
            category: "stub",
            date: Date(),
            comment: nil
        )
    }

    func createTransaction(userId: UserID, transaction: Transaction) throws { }

    func deleteTransaction(id: TransactionID) throws { }

}
