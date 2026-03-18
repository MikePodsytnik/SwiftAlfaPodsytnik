import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding
    case transport
    case cancelled
}
