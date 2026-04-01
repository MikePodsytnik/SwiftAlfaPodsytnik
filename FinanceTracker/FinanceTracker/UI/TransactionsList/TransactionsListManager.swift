import UIKit

protocol TransactionsListManagerDelegate: AnyObject {
    func transactionsListManager(_ manager: TransactionsListManager, didSelect id: TransactionID)
    func transactionsListManagerDidRequestNextPage(_ manager: TransactionsListManager)
}

final class TransactionsListManager: NSObject {

    weak var delegate: TransactionsListManagerDelegate?

    private weak var tableView: UITableView?
    private var items: [TransactionItemViewModel] = []
    private let paginationThreshold = 5
    private var isNextPageRequestInFlight = false

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

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        configure(tableView)
    }

    func setInitialItems(_ items: [TransactionItemViewModel]) {
        self.items = items
        tableView?.reloadData()
        isNextPageRequestInFlight = false
    }

    func appendItems(_ newItems: [TransactionItemViewModel]) {
        guard !newItems.isEmpty, let tableView else {
            isNextPageRequestInFlight = false
            return
        }

        let startIndex = items.count
        let endIndex = startIndex + newItems.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }

        items.append(contentsOf: newItems)

        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .none)
        }

        isNextPageRequestInFlight = false
    }

    func clear() {
        items = []
        tableView?.reloadData()
        isNextPageRequestInFlight = false
    }

    func showBottomLoader(_ isVisible: Bool) {
        guard let tableView else { return }

        isNextPageRequestInFlight = isVisible

        if isVisible {
            footerActivityIndicator.startAnimating()
            tableView.tableFooterView = footerLoaderView
        } else {
            footerActivityIndicator.stopAnimating()
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        }
    }

    private func configure(_ tableView: UITableView) {
        tableView.register(
            TransactionsListCell.self,
            forCellReuseIdentifier: TransactionsListCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 76
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    }
}

extension TransactionsListManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TransactionsListCell.reuseIdentifier,
                for: indexPath
            ) as? TransactionsListCell
        else {
            return UITableViewCell()
        }

        cell.configure(with: items[indexPath.row])
        return cell
    }
}

extension TransactionsListManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.transactionsListManager(self, didSelect: items[indexPath.row].id)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard !items.isEmpty else { return }
        guard !isNextPageRequestInFlight else { return }
        guard indexPath.row >= items.count - paginationThreshold else { return }

        isNextPageRequestInFlight = true
        delegate?.transactionsListManagerDidRequestNextPage(self)
    }
}
