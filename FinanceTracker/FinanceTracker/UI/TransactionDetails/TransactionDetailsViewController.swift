import UIKit

final class TransactionDetailsViewController: UIViewController, TransactionDetailsView {

    var presenter: TransactionDetailsPresenter?

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 12
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Transaction Details"

        setupNavigation()
        setupLayout()
        setupActions()

        presenter?.didLoad()
    }

    func render(_ state: TransactionDetailsViewState) {
        switch state {
        case .loading:
            contentStackView.isHidden = true
            errorLabel.isHidden = true
            activityIndicator.startAnimating()

        case .content(let viewModel):
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            contentStackView.isHidden = false

            titleLabel.text = viewModel.title
            amountLabel.text = "Amount: \(viewModel.amount)"
            categoryLabel.text = "Category: \(viewModel.category)"
            dateLabel.text = "Date: \(viewModel.date)"
            commentLabel.text = "Comment: \(viewModel.comment ?? "No comment")"

        case .error(let message):
            activityIndicator.stopAnimating()
            contentStackView.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = message
        }
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
    }

    private func setupLayout() {
        view.addSubview(activityIndicator)
        view.addSubview(contentStackView)
        view.addSubview(errorLabel)

        [titleLabel, amountLabel, categoryLabel, dateLabel, commentLabel, deleteButton].forEach {
            contentStackView.addArrangedSubview($0)
        }

        contentStackView.setCustomSpacing(24, after: commentLabel)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        contentStackView.isHidden = true
    }

    private func setupActions() {
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }

    @objc
    private func didTapDelete() {
        presenter?.didTapDelete()
    }

    @objc
    private func didTapClose() {
        presenter?.didTapClose()
    }
}
