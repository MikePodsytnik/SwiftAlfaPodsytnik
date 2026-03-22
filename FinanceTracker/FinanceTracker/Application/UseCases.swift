protocol CreateTransactionUseCase {
    func execute(userId: UserID, transaction: Transaction) throws
}

protocol DeleteTransactionUseCase {
    func execute(id: TransactionID) throws
}

protocol GetTransactionDetailsUseCase {
    func execute(id: TransactionID) throws -> Transaction
}

protocol LoginUseCase {
    func execute(email: String, password: String) throws -> UserSession
}

protocol FetchTransactionsPageUseCase {
    func execute(userId: UserID, limit: Int, skip: Int) async throws -> PaginatedList<Transaction>
}
