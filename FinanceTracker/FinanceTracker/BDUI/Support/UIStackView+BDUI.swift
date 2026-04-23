import UIKit

extension UIStackView: BDUIChildContaining {
    func addBDUIChild(_ child: UIView) {
        addArrangedSubview(child)
    }
}
