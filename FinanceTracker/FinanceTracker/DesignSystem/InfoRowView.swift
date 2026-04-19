import UIKit

final class InfoRowView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    private func setup() {
        backgroundColor = DS.Colors.surface
        layer.cornerRadius = DS.Radius.m

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = DS.Spacing.m

        titleLabel.apply(.caption)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)

        valueLabel.apply(.body)
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right

        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: DS.Spacing.l),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.l),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.l),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DS.Spacing.l)
        ])
    }
}
