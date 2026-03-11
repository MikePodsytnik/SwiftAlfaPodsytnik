import UIKit

final class AuthViewController: UIViewController, AuthView {
    var presenter: AuthPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let label = UILabel()
        label.text = "Auth Screen"
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        presenter?.didLoad()
    }

    func render(_ state: AuthViewState) {
    }

    @objc private func didTapLogin() {
        presenter?.didTapLogin(email: "", password: "")
    }
}
