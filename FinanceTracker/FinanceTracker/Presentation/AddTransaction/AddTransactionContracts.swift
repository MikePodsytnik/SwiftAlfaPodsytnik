import Foundation

protocol AddTransactionView: AnyObject {
    func render(_ state: AddTransactionViewState)
}

protocol AddTransactionPresenter {
    func didLoad()
    func didTapSave(amount: Decimal, category: String, date: Date, comment: String?)
    func didTapCancel()
}

protocol AddTransactionRouter {
    func close()
}
