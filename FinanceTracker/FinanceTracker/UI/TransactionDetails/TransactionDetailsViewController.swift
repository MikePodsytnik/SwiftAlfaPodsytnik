import UIKit

final class TransactionDetailsViewController: UIViewController, TransactionDetailsView {

    var presenter: TransactionDetailsPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }

    func render(_ state: TransactionDetailsViewState) {
    }
}
