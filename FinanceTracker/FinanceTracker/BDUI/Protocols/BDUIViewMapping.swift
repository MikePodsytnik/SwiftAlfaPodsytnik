import UIKit

protocol BDUIViewMapping {
    var supportedType: BDUIViewType { get }
    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView
}
