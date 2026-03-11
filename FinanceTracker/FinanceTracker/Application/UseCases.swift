protocol CreateTransactionUseCase {
    func execute(userId: UserID, transaction: Transaction) throws
}

protocol DeleteTransactionUseCase {
    func execute(id: TransactionID) throws
}

protocol FetchTransactionsUseCase {
    func execute(userId: UserID) throws -> [Transaction]
}

protocol GetTransactionDetailsUseCase {
    func execute(id: TransactionID) throws -> Transaction
}

protocol LoginUseCase {
    func execute(email: String, password: String) throws -> UserSession
}
