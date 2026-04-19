import UIKit

final class DSStateView: UIView {
    enum State {
        case loading(title: String, message: String?)
        case empty(title: String, message: String?, buttonTitle: String?)
        case error(title: String, message: String?, buttonTitle: String?)
    }

    private let stackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = DSButton(style: .primary)

    private var actionHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(state: State, action: (() -> Void)?) {
        actionHandler = action

        switch state {
        case .loading(let title, let message):
            activityIndicator.startAnimating()
            titleLabel.text = title
            messageLabel.text = message
            messageLabel.isHidden = message == nil
            actionButton.isHidden = true

        case .empty(let title, let message, let buttonTitle):
            activityIndicator.stopAnimating()
            titleLabel.text = title
            messageLabel.text = message
            messageLabel.isHidden = message == nil

            if let buttonTitle {
                actionButton.isHidden = false
                actionButton.configure(title: buttonTitle)
                actionButton.setState(.normal)
            } else {
                actionButton.isHidden = true
            }

        case .error(let title, let message, let buttonTitle):
            activityIndicator.stopAnimating()
            titleLabel.text = title
            messageLabel.text = message
            messageLabel.isHidden = message == nil

            if let buttonTitle {
                actionButton.isHidden = false
                actionButton.configure(title: buttonTitle)
                actionButton.setState(.normal)
            } else {
                actionButton.isHidden = true
            }
        }
    }

    private func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = DS.Spacing.m

        titleLabel.apply(.title)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.apply(.body)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        actionButton.isHidden = true
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)

        addSubview(stackView)

        [activityIndicator, titleLabel, messageLabel, actionButton].forEach {
            stackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xl),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xl)
        ])
    }

    @objc
    private func didTapAction() {
        actionHandler?()
    }
}
