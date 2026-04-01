import UIKit

final class PlaceholderView: UIView {

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 12
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        title: String,
        message: String?,
        buttonTitle: String?,
        onTap: (() -> Void)?
    ) {
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.isHidden = message == nil || message?.isEmpty == true

        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.isHidden = buttonTitle == nil

        self.onTap = onTap
    }

    private func setupLayout() {
        addSubview(stackView)

        [titleLabel, messageLabel, actionButton].forEach {
            stackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    private func setupActions() {
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc
    private func didTapButton() {
        onTap?()
    }
}
