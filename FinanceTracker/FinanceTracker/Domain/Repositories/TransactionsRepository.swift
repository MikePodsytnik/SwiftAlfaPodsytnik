import Foundation

protocol TransactionsRepository {
    func fetchTransactionsPage(userId: UserID, limit: Int, skip: Int) async throws -> PaginatedList<Transaction>
    func fetchTransaction(id: TransactionID) async throws -> Transaction
    func createTransaction(userId: UserID, transaction: Transaction) throws
    func deleteTransaction(id: TransactionID) throws
}
