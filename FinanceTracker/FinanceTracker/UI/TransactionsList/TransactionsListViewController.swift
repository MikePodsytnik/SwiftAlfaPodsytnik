import UIKit

final class TransactionsListViewController: UIViewController, TransactionsListView {

    var presenter: TransactionsListPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }

    func render(_ state: TransactionsListViewState) {
        switch state {
        case .loading: break
        case .content: break
        case .empty: break
        case .error: break
        }
    }
}
