import UIKit

protocol BDUIChildContaining: AnyObject {
    func addBDUIChild(_ child: UIView)
}

final class BDUIContainerView: UIView, BDUIChildContaining {
    let stackView = UIStackView()
    private var stackConstraints: [NSLayoutConstraint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        updatePadding(.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePadding(_ insets: UIEdgeInsets) {
        NSLayoutConstraint.deactivate(stackConstraints)
        stackConstraints = [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]
        NSLayoutConstraint.activate(stackConstraints)
    }

    func addBDUIChild(_ child: UIView) {
        stackView.addArrangedSubview(child)
    }
}

enum BDUIViewFactory {
    static func makeDefaultMappers() -> [BDUIViewMapping] {
        [
            ContentViewMapper(),
            StackViewMapper(),
            LabelMapper(),
            ButtonMapper(),
            TextFieldMapper(),
            StateViewMapper(),
            InfoRowMapper()
        ]
    }
}
