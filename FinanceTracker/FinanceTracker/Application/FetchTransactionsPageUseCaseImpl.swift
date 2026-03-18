final class FetchTransactionsPageUseCaseImpl: FetchTransactionsPageUseCase {
    private let repository: TransactionsRepository

    init(repository: TransactionsRepository) {
        self.repository = repository
    }

    func execute(userId: UserID, limit: Int, skip: Int) async throws -> PaginatedList<Transaction> {
        try await repository.fetchTransactionsPage(userId: userId, limit: limit, skip: skip)
    }
}
