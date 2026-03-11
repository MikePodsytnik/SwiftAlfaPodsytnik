import UIKit

final class AddTransactionViewController: UIViewController, AddTransactionView {

    var presenter: AddTransactionPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }

    func render(_ state: AddTransactionViewState) { }
}
