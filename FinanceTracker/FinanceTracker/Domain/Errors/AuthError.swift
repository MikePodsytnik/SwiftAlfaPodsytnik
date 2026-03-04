import Foundation

enum AuthError: Error, Equatable {
    case invalidCredentials
    case network
    case unknown(String)
}
