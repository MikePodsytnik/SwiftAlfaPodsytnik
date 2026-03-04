import Foundation

protocol TransactionDetailsView: AnyObject {
    func render(_ state: TransactionDetailsViewState)
}

protocol TransactionDetailsPresenter {
    func didLoad()
    func didTapDelete()
    func didTapClose()
}

protocol TransactionDetailsRouter {
    func close()
}
