import UIKit

final class TransactionsListViewController: UIViewController, TransactionsListView {

    var presenter: TransactionsListPresenter?

    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        return view
    }()

    private let stateView = DSStateView()
    private let listManager = TransactionsListManager()

    private let footerActivityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var footerLoaderView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        container.backgroundColor = .clear
        container.addSubview(footerActivityIndicator)

        NSLayoutConstraint.activate([
            footerActivityIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            footerActivityIndicator.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DS.Colors.background
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
            tableView.isHidden = true
            stateView.isHidden = true
            showBottomLoader(false)
            listManager.setNextPageRequestInFlight(false)

        case .loading:
            tableView.isHidden = true
            stateView.isHidden = false
            stateView.configure(
                state: .loading(
                    title: "Loading transactions",
                    message: "Please wait a moment"
                ),
                action: nil
            )
            showBottomLoader(false)
            listManager.setNextPageRequestInFlight(false)

        case .content(let items, let update, let pagination):
            tableView.isHidden = false
            stateView.isHidden = true
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
                    tableView.insertRows(at: indexPaths, with: .fade)
                }
            }

        case .empty:
            listManager.clear()
            tableView.reloadData()
            tableView.isHidden = true
            stateView.isHidden = false
            showBottomLoader(false)

            stateView.configure(
                state: .empty(
                    title: "No transactions",
                    message: "There is nothing to show yet.",
                    buttonTitle: "Retry"
                ),
                action: { [weak self] in
                    self?.presenter?.didTapRetry()
                }
            )

        case .error(let message):
            listManager.clear()
            tableView.reloadData()
            tableView.isHidden = true
            stateView.isHidden = false
            showBottomLoader(false)

            stateView.configure(
                state: .error(
                    title: "Something went wrong",
                    message: message,
                    buttonTitle: "Retry"
                ),
                action: { [weak self] in
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
        view.addSubview(stateView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        stateView.isHidden = true
    }

    private func setupTableView() {
        tableView.register(
            TransactionsListCell.self,
            forCellReuseIdentifier: TransactionsListCell.reuseIdentifier
        )
        tableView.dataSource = listManager
        tableView.delegate = listManager
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96
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
