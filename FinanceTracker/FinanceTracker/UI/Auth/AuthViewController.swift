import UIKit

final class AuthViewController: UIViewController, AuthView {

    var presenter: AuthPresenter?

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delaysContentTouches = false
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let formStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = DS.Spacing.l
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.largeTitle)
        label.text = "Finance Tracker"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.body)
        label.text = "Sign in to continue"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let emailField = DSTextField(title: "Email", placeholder: "Enter email")
    private let passwordField = DSTextField(title: "Password", placeholder: "Enter password")
    private let loginButton = DSButton(style: .primary)

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DS.Colors.background

        passwordField.isSecureTextEntry = true
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.returnKeyType = .next
        passwordField.returnKeyType = .go

        loginButton.configure(title: "Login")
        loginButton.setState(.normal)

        setupLayout()
        setupActions()
        setupKeyboardObservers()

        presenter?.didLoad()
    }

    func render(_ state: AuthViewState) {
        switch state {
        case .idle:
            loginButton.setState(.normal)
            emailField.setState(.normal)
            passwordField.setState(.normal)

        case .loading:
            emailField.setState(.normal)
            passwordField.setState(.normal)
            loginButton.setState(.loading)

        case .error(let message):
            loginButton.setState(.normal)
            emailField.setState(.normal)
            passwordField.setState(.error(mapAuthErrorMessage(message)))
        }
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formStackView)

        [titleLabel, subtitleLabel, emailField, passwordField, loginButton].forEach {
            formStackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            formStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            formStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.xl),
            formStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.xl),
            formStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xl)
        ])
    }

    private func mapAuthErrorMessage(_ message: String) -> String {
        if message.contains("AuthError") {
            return "Invalid email or password"
        }

        return "Failed to sign in. Please try again."
    }

    @objc
    private func didTapLogin() {
        presenter?.didTapLogin(
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }
}

private extension AuthViewController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc
    func keyboardWillChangeFrame(_ note: Notification) {
        guard
            let userInfo = note.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardInView)

        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField.inputViewRef {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapLogin()
        }

        return true
    }
}
