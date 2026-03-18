import Foundation

struct CartsResponseDTO: Decodable {
    let carts: [CartDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

struct CartDTO: Decodable {
    let id: Int
    let products: [CartProductDTO]
    let total: Double
    let discountedTotal: Double
    let userId: Int
    let totalProducts: Int
    let totalQuantity: Int
}

struct CartProductDTO: Decodable {
    let id: Int
    let title: String
    let price: Double
    let quantity: Int
    let total: Double
    let discountedTotal: Double
}
