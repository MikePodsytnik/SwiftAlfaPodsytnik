final class LoginUseCaseImpl: LoginUseCase {

    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) throws -> UserSession {
        try repository.login(email: email, password: password)
    }
}
