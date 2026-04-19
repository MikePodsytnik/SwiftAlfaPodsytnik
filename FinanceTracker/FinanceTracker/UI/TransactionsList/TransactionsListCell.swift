import UIKit

final class TransactionsListCell: UITableViewCell {

    static let reuseIdentifier = "TransactionsListCell"

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DS.Colors.surface
        view.layer.cornerRadius = DS.Radius.l
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(.headline)
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.apply(.caption)
        label.numberOfLines = 2
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.apply(.bodyMedium)
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let textStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = DS.Spacing.xs
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top
        view.spacing = DS.Spacing.m
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: TransactionItemViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        amountLabel.text = viewModel.formattedAmount
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        amountLabel.text = nil
    }

    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)

        contentStackView.addArrangedSubview(textStackView)
        contentStackView.addArrangedSubview(amountLabel)

        contentView.addSubview(cardView)
        cardView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.s),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.s),

            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DS.Spacing.l),
            contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.l),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DS.Spacing.l),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DS.Spacing.l)
        ])
    }
}
