import UIKit

final class DSButton: UIButton {
    enum Style {
        case primary
        case secondary
        case destructive
    }

    enum State {
        case normal
        case loading
        case disabled
    }

    private let style: Style
    private let spinner = UIActivityIndicatorView(style: .medium)

    private var regularTitle: String?
    private var currentState: State = .normal

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        regularTitle = title
        if currentState != .loading {
            super.setTitle(title, for: .normal)
        }
    }

    func setState(_ state: State) {
        currentState = state
        applyAppearance()
    }

    private func setup() {
        layer.cornerRadius = DS.Radius.m
        titleLabel?.font = DS.Typography.font(for: .button)
        clipsToBounds = true

        heightAnchor.constraint(equalToConstant: 52).isActive = true

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        applyAppearance()
    }

    private func applyAppearance() {
        switch currentState {
        case .normal:
            spinner.stopAnimating()
            super.setTitle(regularTitle, for: .normal)
            isEnabled = true

        case .loading:
            spinner.startAnimating()
            super.setTitle(nil, for: .normal)
            isEnabled = false

        case .disabled:
            spinner.stopAnimating()
            super.setTitle(regularTitle, for: .normal)
            isEnabled = false
        }

        applyStyleColors()
    }

    private func applyStyleColors() {
        switch style {
        case .primary:
            switch currentState {
            case .normal:
                backgroundColor = DS.Colors.primary
                setTitleColor(DS.Colors.textOnPrimary, for: .normal)
            case .loading, .disabled:
                backgroundColor = DS.Colors.primary.withAlphaComponent(0.45)
                setTitleColor(DS.Colors.textOnPrimary.withAlphaComponent(0.85), for: .normal)
            }
            spinner.color = DS.Colors.textOnPrimary

        case .secondary:
            switch currentState {
            case .normal:
                backgroundColor = DS.Colors.secondary
                setTitleColor(DS.Colors.primary, for: .normal)
            case .loading, .disabled:
                backgroundColor = DS.Colors.secondary.withAlphaComponent(0.7)
                setTitleColor(DS.Colors.primary.withAlphaComponent(0.6), for: .normal)
            }
            spinner.color = DS.Colors.primary

        case .destructive:
            switch currentState {
            case .normal:
                backgroundColor = DS.Colors.error
                setTitleColor(.white, for: .normal)
            case .loading, .disabled:
                backgroundColor = DS.Colors.error.withAlphaComponent(0.45)
                setTitleColor(.white.withAlphaComponent(0.85), for: .normal)
            }
            spinner.color = .white
        }
    }
}
