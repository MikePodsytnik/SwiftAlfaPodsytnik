import Foundation

final class TransactionsRepositoryImpl: TransactionsRepository {
    private let networkClient: NetworkClient
    private let decoder: JSONDecoder
    private let pageCache: TransactionsPageCache

    init(
        networkClient: NetworkClient,
        pageCache: TransactionsPageCache,
        decoder: JSONDecoder = TransactionsRepositoryImpl.makeDecoder()
    ) {
        self.networkClient = networkClient
        self.pageCache = pageCache
        self.decoder = decoder
    }

    func fetchTransactionsPage(
        userId: UserID,
        limit: Int,
        skip: Int
    ) async throws -> PaginatedList<Transaction> {
        if let cached = pageCache.get(userId: userId, limit: limit, skip: skip) {
            return cached
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        components.path = "/carts"
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(skip))
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        let response: CartsResponseDTO = try await networkClient.get(url, decoder: decoder)

        let page = PaginatedList(
            items: response.carts.map { $0.toDomain() },
            total: response.total,
            limit: response.limit,
            skip: response.skip
        )

        pageCache.save(page, userId: userId, limit: limit, skip: skip)
        return page
    }

    func fetchTransaction(id: TransactionID) async throws -> Transaction {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        components.path = "/carts/\(id)"

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        let dto: CartDTO = try await networkClient.get(url, decoder: decoder)
        return dto.toDomain()
    }

    func createTransaction(userId: UserID, transaction: Transaction) throws { }

    func deleteTransaction(id: TransactionID) throws { }

    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}
