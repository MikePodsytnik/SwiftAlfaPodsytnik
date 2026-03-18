import UIKit

final class TransactionsListViewController: UIViewController, TransactionsListView {

    var presenter: TransactionsListPresenter?

    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Transactions"

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        presenter?.didLoad()
    }

    func render(_ state: TransactionsListViewState) {
        switch state {
        case .idle:
            label.text = "Idle"

        case .loading:
            label.text = "Loading..."

        case .content(let items, _):
            label.text = "Loaded: \(items.count)"

        case .empty:
            label.text = "No transactions"

        case .error(let message):
            label.text = message
        }
    }
}
