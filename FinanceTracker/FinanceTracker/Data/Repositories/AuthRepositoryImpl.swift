final class AuthRepositoryImpl: AuthRepository {

    func login(email: String, password: String) throws -> UserSession {

        if email == "admin@test.com" && password == "123456" {
            return UserSession(
                token: "demo_token",
                userId: "user_1"
            )
        }

        throw AuthError.invalidCredentials
    }
}
