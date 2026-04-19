import UIKit

final class DSTextField: UIView {
    enum State {
        case normal
        case focused
        case error(String)
        case disabled
    }

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let errorLabel = UILabel()

    private var currentState: State = .normal

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }

    var inputViewRef: UITextField {
        textField
    }

    weak var delegate: UITextFieldDelegate? {
        get { textField.delegate }
        set { textField.delegate = newValue }
    }

    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
        configure(title: title, placeholder: placeholder)
        setState(.normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var canBecomeFirstResponder: Bool {
        textField.canBecomeFirstResponder
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let result = textField.becomeFirstResponder()
        setState(.focused)
        return result
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        let result = textField.resignFirstResponder()
        if case .error = currentState {
        } else {
            setState(.normal)
        }
        return result
    }

    func configure(title: String, placeholder: String) {
        titleLabel.text = title
        textField.placeholder = placeholder
    }

    func setState(_ state: State) {
        currentState = state
        applyState()
    }

    private func applyState() {
        switch currentState {
        case .normal:
            textField.isEnabled = true
            textField.backgroundColor = DS.Colors.fieldBackground
            textField.layer.borderColor = DS.Colors.border.cgColor
            errorLabel.text = nil
            errorLabel.isHidden = true

        case .focused:
            textField.isEnabled = true
            textField.backgroundColor = DS.Colors.fieldBackground
            textField.layer.borderColor = DS.Colors.primary.cgColor
            errorLabel.text = nil
            errorLabel.isHidden = true

        case .error(let message):
            textField.isEnabled = true
            textField.backgroundColor = DS.Colors.fieldBackground
            textField.layer.borderColor = DS.Colors.error.cgColor
            errorLabel.text = message
            errorLabel.isHidden = false

        case .disabled:
            textField.isEnabled = false
            textField.backgroundColor = DS.Colors.secondary
            textField.layer.borderColor = DS.Colors.border.cgColor
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }

    private func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DS.Spacing.s

        titleLabel.apply(.caption)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = DS.Colors.textPrimary
        textField.font = DS.Typography.font(for: .body)
        textField.layer.cornerRadius = DS.Radius.m
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true

        errorLabel.apply(.error)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
