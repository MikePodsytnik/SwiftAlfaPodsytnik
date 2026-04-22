import UIKit

final class TransactionDetailsViewController: UIViewController, TransactionDetailsView {

    var presenter: TransactionDetailsPresenter?

    private let stateView = DSStateView()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = DS.Spacing.l
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()

    private let amountRow = InfoRowView()
    private let categoryRow = InfoRowView()
    private let dateRow = InfoRowView()
    private let commentRow = InfoRowView()
    private let deleteButton = DSButton(style: .destructive)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DS.Colors.background
        title = "Transaction Details"

        deleteButton.configure(title: "Delete")
        deleteButton.setState(.normal)

        setupNavigation()
        setupLayout()
        setupActions()

        presenter?.didLoad()
    }

    func render(_ state: TransactionDetailsViewState) {
        switch state {
        case .loading:
            scrollView.isHidden = true
            stateView.isHidden = false
            stateView.configure(
                state: .loading(title: "Loading details", message: nil),
                action: nil
            )

        case .content(let viewModel):
            stateView.isHidden = true
            scrollView.isHidden = false

            titleLabel.text = viewModel.title
            amountRow.configure(title: "Amount", value: viewModel.amount)
            categoryRow.configure(title: "Category", value: viewModel.category)
            dateRow.configure(title: "Date", value: viewModel.date)
            commentRow.configure(title: "Comment", value: viewModel.comment ?? "No comment")
            deleteButton.setState(.normal)

        case .error(let message):
            scrollView.isHidden = true
            stateView.isHidden = false
            stateView.configure(
                state: .error(
                    title: "Failed to load details",
                    message: message,
                    buttonTitle: nil
                ),
                action: nil
            )
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
        view.addSubview(scrollView)
        view.addSubview(stateView)

        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        [titleLabel, amountRow, categoryRow, dateRow, commentRow, deleteButton].forEach {
            stackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.xl),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xl)
        ])

        scrollView.isHidden = true
        stateView.isHidden = true
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
