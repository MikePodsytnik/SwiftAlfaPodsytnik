import Foundation

extension CartDTO {
    func toDomain() -> Transaction {
        Transaction(
            id: String(id),
            amount: Decimal(discountedTotal),
            category: "Cart \(totalProducts) products",
            date: Date(),
            comment: "User \(userId), quantity \(totalQuantity)"
        )
    }
}
