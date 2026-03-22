struct PaginatedList<Item> {
    let items: [Item]
    let total: Int
    let limit: Int
    let skip: Int

    var hasMore: Bool {
        skip + items.count < total
    }
}
