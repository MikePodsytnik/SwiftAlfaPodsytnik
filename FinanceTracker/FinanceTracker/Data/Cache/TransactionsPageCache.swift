import Foundation

protocol TransactionsPageCache {
    func get(userId: UserID, limit: Int, skip: Int) -> PaginatedList<Transaction>?
    func save(_ page: PaginatedList<Transaction>, userId: UserID, limit: Int, skip: Int)
    func clear()
}

final class TransactionsPageCacheImpl: TransactionsPageCache {
    private final class Box {
        let value: PaginatedList<Transaction>

        init(_ value: PaginatedList<Transaction>) {
            self.value = value
        }
    }

    private let cache = NSCache<NSString, Box>()

    init(countLimit: Int = 20) {
        cache.countLimit = countLimit
    }

    func get(userId: UserID, limit: Int, skip: Int) -> PaginatedList<Transaction>? {
        let key = makeKey(userId: userId, limit: limit, skip: skip)
        return cache.object(forKey: key as NSString)?.value
    }

    func save(_ page: PaginatedList<Transaction>, userId: UserID, limit: Int, skip: Int) {
        let key = makeKey(userId: userId, limit: limit, skip: skip)
        cache.setObject(Box(page), forKey: key as NSString)
    }

    func clear() {
        cache.removeAllObjects()
    }

    private func makeKey(userId: UserID, limit: Int, skip: Int) -> String {
        "\(userId)_\(limit)_\(skip)"
    }
}
