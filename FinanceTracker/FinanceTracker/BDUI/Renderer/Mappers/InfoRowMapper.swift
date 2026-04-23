import UIKit

final class InfoRowMapper: BDUIViewMapping {
    let supportedType: BDUIViewType = .infoRow

    func makeView(for node: BDUINode, actionHandler: BDUIActionHandling?) -> UIView {
        guard case let .infoRow(content) = node.payload else {
            return UIView()
        }

        let view = InfoRowView()
        view.configure(title: content.title, value: content.value)
        return view
    }
}
