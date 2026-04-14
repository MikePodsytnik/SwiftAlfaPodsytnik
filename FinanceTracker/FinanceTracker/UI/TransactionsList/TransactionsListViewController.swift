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
    private let listManager = TransactionsListManager()

    private let footerActivityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var footerLoaderView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 52))
        container.addSubview(footerActivityIndicator)

        NSLayoutConstraint.activate([
            footerActivityIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            footerActivityIndicator.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Transactions"

        setupNavigation()
        setupLayout()
        setupTableView()
        setupTableFooter()

        presenter?.didLoad()
    }

    func render(_ state: TransactionsListViewState) {
        switch state {
        case .idle:
            loadingView.stop()
            loadingView.isHidden = true
            placeholderView.isHidden = true
            tableView.isHidden = true
            showBottomLoader(false)
            listManager.setNextPageRequestInFlight(false)

        case .loading:
            loadingView.isHidden = false
            loadingView.start()
            placeholderView.isHidden = true
            tableView.isHidden = true
            showBottomLoader(false)
            listManager.setNextPageRequestInFlight(false)

        case .content(let items, let update, let pagination):
            tableView.isHidden = false
            placeholderView.isHidden = true
            loadingView.stop()
            loadingView.isHidden = true
            showBottomLoader(pagination == .loading)
            listManager.setNextPageRequestInFlight(pagination == .loading)

            switch update {
            case .none:
                break

            case .reload:
                listManager.setItems(items)
                tableView.reloadData()

            case .append(let newItems):
                let indexPaths = listManager.appendItems(newItems)
                guard !indexPaths.isEmpty else { return }

                tableView.performBatchUpdates {
                    tableView.insertRows(at: indexPaths, with: .none)
                }
            }

        case .empty:
            listManager.clear()
            tableView.reloadData()
            showBottomLoader(false)
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
            listManager.clear()
            tableView.reloadData()
            showBottomLoader(false)
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

    private func setupTableView() {
        tableView.register(
            TransactionsListCell.self,
            forCellReuseIdentifier: TransactionsListCell.reuseIdentifier
        )
        tableView.dataSource = listManager
        tableView.delegate = listManager
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 76
        tableView.keyboardDismissMode = .onDrag

        listManager.delegate = self
    }

    private func setupTableFooter() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    }

    private func showBottomLoader(_ isVisible: Bool) {
        if isVisible {
            footerActivityIndicator.startAnimating()
            tableView.tableFooterView = footerLoaderView
        } else {
            footerActivityIndicator.stopAnimating()
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        }
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
