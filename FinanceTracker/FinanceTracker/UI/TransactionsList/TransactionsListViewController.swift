import UIKit

final class TransactionsListViewController: UIViewController, TransactionsListView {

    var presenter: TransactionsListPresenter?

    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loadingView = LoadingView()
    private let placeholderView = PlaceholderView()
    private var listManager: TransactionsListManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Transactions"

        setupNavigation()
        setupLayout()
        setupListManager()

        presenter?.didLoad()
    }

    func render(_ state: TransactionsListViewState) {
        switch state {
        case .idle:
            loadingView.stop()
            loadingView.isHidden = true
            placeholderView.isHidden = true
            tableView.isHidden = true
            listManager?.showBottomLoader(false)

        case .loading:
            loadingView.isHidden = false
            loadingView.start()
            placeholderView.isHidden = true
            tableView.isHidden = true
            listManager?.showBottomLoader(false)

        case .content(_, let update, let pagination):
            tableView.isHidden = false
            placeholderView.isHidden = true
            loadingView.stop()
            loadingView.isHidden = true
            listManager?.showBottomLoader(pagination == .loading)

            switch update {
            case .none:
                break
            case .reload:
                if case let .content(items, _, _) = state {
                    listManager?.setInitialItems(items)
                }
            case .append(let newItems):
                listManager?.appendItems(newItems)
            }

        case .empty:
            listManager?.clear()
            listManager?.showBottomLoader(false)
            tableView.isHidden = true
            loadingView.stop()
            loadingView.isHidden = true
            placeholderView.isHidden = false
            placeholderView.configure(
                title: "No transactions",
                message: "There is nothing to show yet.",
                buttonTitle: "Retry",
                onTap: { [weak self] in
                    self?.presenter?.didTapRetry()
                }
            )

        case .error(let message):
            listManager?.clear()
            listManager?.showBottomLoader(false)
            tableView.isHidden = true
            loadingView.stop()
            loadingView.isHidden = true
            placeholderView.isHidden = false
            placeholderView.configure(
                title: "Something went wrong",
                message: message,
                buttonTitle: "Retry",
                onTap: { [weak self] in
                    self?.presenter?.didTapRetry()
                }
            )
        }
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddTransaction)
        )
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(placeholderView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        loadingView.isHidden = true
        placeholderView.isHidden = true
    }

    private func setupListManager() {
        let manager = TransactionsListManager(tableView: tableView)
        manager.delegate = self
        listManager = manager
    }

    @objc
    private func didTapAddTransaction() {
        presenter?.didTapAddTransaction()
    }
}

extension TransactionsListViewController: TransactionsListManagerDelegate {
    func transactionsListManager(_ manager: TransactionsListManager, didSelect id: TransactionID) {
        presenter?.didSelectTransaction(id: id)
    }

    func transactionsListManagerDidRequestNextPage(_ manager: TransactionsListManager) {
        presenter?.didReachListEnd()
    }
}
