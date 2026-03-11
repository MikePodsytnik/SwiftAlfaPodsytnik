final class AuthRepositoryImpl: AuthRepository {

    func login(email: String, password: String) throws -> UserSession {
        return UserSession(token: "stub_token", userId: "user_1")
    }

}
