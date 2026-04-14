import UIKit

protocol TransactionsListManagerDelegate: AnyObject {
    func transactionsListManager(_ manager: TransactionsListManager, didSelect id: TransactionID)
    func transactionsListManagerDidRequestNextPage(_ manager: TransactionsListManager)
}

final class TransactionsListManager: NSObject {

    weak var delegate: TransactionsListManagerDelegate?

    private var items: [TransactionItemViewModel] = []
    private let paginationThreshold = 5
    private var isNextPageRequestInFlight = false

    func setItems(_ items: [TransactionItemViewModel]) {
        self.items = items
        isNextPageRequestInFlight = false
    }

    func appendItems(_ newItems: [TransactionItemViewModel]) -> [IndexPath] {
        guard !newItems.isEmpty else {
            isNextPageRequestInFlight = false
            return []
        }

        let startIndex = items.count
        let endIndex = startIndex + newItems.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }

        items.append(contentsOf: newItems)
        isNextPageRequestInFlight = false

        return indexPaths
    }

    func clear() {
        items = []
        isNextPageRequestInFlight = false
    }

    func setNextPageRequestInFlight(_ value: Bool) {
        isNextPageRequestInFlight = value
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
