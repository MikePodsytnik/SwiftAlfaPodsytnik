import Foundation

protocol TransactionsRepository {
    func fetchTransactions(userId: UserID) throws -> [Transaction]
    func fetchTransaction(id: TransactionID) throws -> Transaction
    func createTransaction(userId: UserID, transaction: Transaction) throws
    func deleteTransaction(id: TransactionID) throws
}
