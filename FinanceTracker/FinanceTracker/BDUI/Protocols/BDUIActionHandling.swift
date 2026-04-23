import UIKit

protocol BDUIActionHandling: AnyObject {
    func handle(action: BDUIAction, from sourceView: UIView?)
}
