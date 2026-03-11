import Foundation

protocol AuthRepository {
    func login(email: String, password: String) throws -> UserSession
}
