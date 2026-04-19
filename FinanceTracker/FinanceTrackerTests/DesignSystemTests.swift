import XCTest
@testable import FinanceTracker

final class DesignSystemTests: XCTestCase {

    func test_largeTitleTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .largeTitle)
        let color = DS.Typography.color(for: .largeTitle)

        XCTAssertEqual(font.pointSize, 30)
        XCTAssertTrue(color.isEqual(DS.Colors.textPrimary))
    }

    func test_titleTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .title)
        let color = DS.Typography.color(for: .title)

        XCTAssertEqual(font.pointSize, 22)
        XCTAssertTrue(color.isEqual(DS.Colors.textPrimary))
    }

    func test_headlineTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .headline)
        let color = DS.Typography.color(for: .headline)

        XCTAssertEqual(font.pointSize, 17)
        XCTAssertTrue(color.isEqual(DS.Colors.textPrimary))
    }

    func test_bodyTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .body)
        let color = DS.Typography.color(for: .body)

        XCTAssertEqual(font.pointSize, 16)
        XCTAssertTrue(color.isEqual(DS.Colors.textPrimary))
    }

    func test_bodyMediumTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .bodyMedium)
        let color = DS.Typography.color(for: .bodyMedium)

        XCTAssertEqual(font.pointSize, 16)
        XCTAssertTrue(color.isEqual(DS.Colors.textPrimary))
    }

    func test_captionTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .caption)
        let color = DS.Typography.color(for: .caption)

        XCTAssertEqual(font.pointSize, 13)
        XCTAssertTrue(color.isEqual(DS.Colors.textSecondary))
    }

    func test_errorTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .error)
        let color = DS.Typography.color(for: .error)

        XCTAssertEqual(font.pointSize, 14)
        XCTAssertTrue(color.isEqual(DS.Colors.error))
    }

    func test_buttonTextStyle_fontAndColor() {
        let font = DS.Typography.font(for: .button)
        let color = DS.Typography.color(for: .button)

        XCTAssertEqual(font.pointSize, 16)
        XCTAssertTrue(color.isEqual(DS.Colors.textOnPrimary))
    }

    func test_labelApply_setsExpectedFontAndColor() {
        let label = UILabel()

        label.apply(.headline)

        XCTAssertEqual(label.font.pointSize, DS.Typography.font(for: .headline).pointSize)
        XCTAssertTrue(label.textColor.isEqual(DS.Typography.color(for: .headline)))
    }

    func test_primaryButton_hasExpectedCornerRadius() {
        let button = DSButton(style: .primary)

        XCTAssertEqual(button.layer.cornerRadius, DS.Radius.m)
    }

    func test_primaryButton_loadingState_hidesTitle() {
        let button = DSButton(style: .primary)
        button.configure(title: "Login")

        button.setState(.loading)

        XCTAssertNil(button.title(for: .normal))
    }

    func test_primaryButton_returnsTitleAfterBackToNormalState() {
        let button = DSButton(style: .primary)
        button.configure(title: "Login")

        button.setState(.loading)
        button.setState(.normal)

        XCTAssertEqual(button.title(for: .normal), "Login")
    }

    func test_primaryButton_disabledState_disablesInteraction() {
        let button = DSButton(style: .primary)
        button.configure(title: "Login")

        button.setState(.disabled)

        XCTAssertFalse(button.isEnabled)
    }

    func test_secondaryButton_keepsExpectedFont() {
        let button = DSButton(style: .secondary)

        XCTAssertEqual(button.titleLabel?.font.pointSize, DS.Typography.font(for: .button).pointSize)
    }

    func test_destructiveButton_keepsExpectedCornerRadius() {
        let button = DSButton(style: .destructive)

        XCTAssertEqual(button.layer.cornerRadius, DS.Radius.m)
    }

    func test_textField_errorState_canBeShownAndThenHidden() {
        let field = DSTextField(title: "Email", placeholder: "Enter email")

        field.setState(.error("Invalid email"))
        let hasVisibleErrorAfterSet = field.subviewsRecursive()
            .compactMap { $0 as? UILabel }
            .contains { $0.text == "Invalid email" && !$0.isHidden }

        XCTAssertTrue(hasVisibleErrorAfterSet)

        field.setState(.normal)
        let hasVisibleErrorAfterClear = field.subviewsRecursive()
            .compactMap { $0 as? UILabel }
            .contains { $0.text == "Invalid email" && !$0.isHidden }

        XCTAssertFalse(hasVisibleErrorAfterClear)
    }

    func test_textField_focusedState_keepsFieldEnabled() {
        let field = DSTextField(title: "Email", placeholder: "Enter email")

        field.setState(.focused)

        let textFields = field.subviewsRecursive().compactMap { $0 as? UITextField }
        XCTAssertEqual(textFields.count, 1)
        XCTAssertTrue(textFields.allSatisfy(\.isEnabled))
    }

    func test_textField_disabledState_disablesInput() {
        let field = DSTextField(title: "Email", placeholder: "Enter email")

        field.setState(.disabled)

        let textFields = field.subviewsRecursive().compactMap { $0 as? UITextField }
        XCTAssertEqual(textFields.count, 1)
        XCTAssertTrue(textFields.allSatisfy { !$0.isEnabled })
    }

    func test_stateView_loadingHidesButton() {
        let view = DSStateView()
        view.configure(state: .loading(title: "Loading", message: "Please wait"), action: nil)

        let buttons = view.subviewsRecursive().compactMap { $0 as? UIButton }
        XCTAssertTrue(buttons.allSatisfy(\.isHidden))
    }

    func test_stateView_errorShowsButtonWhenTitleProvided() {
        let view = DSStateView()
        view.configure(
            state: .error(title: "Error", message: "Retry needed", buttonTitle: "Retry"),
            action: {}
        )

        let buttons = view.subviewsRecursive().compactMap { $0 as? UIButton }
        XCTAssertTrue(buttons.contains { !$0.isHidden && $0.title(for: .normal) == "Retry" })
    }

    func test_stateView_emptyShowsButtonWhenTitleProvided() {
        let view = DSStateView()
        view.configure(
            state: .empty(title: "Empty", message: "No data", buttonTitle: "Reload"),
            action: {}
        )

        let buttons = view.subviewsRecursive().compactMap { $0 as? UIButton }
        XCTAssertTrue(buttons.contains { !$0.isHidden && $0.title(for: .normal) == "Reload" })
    }

    func test_stateView_emptyWithoutButton_hidesButton() {
        let view = DSStateView()
        view.configure(
            state: .empty(title: "Empty", message: "No data", buttonTitle: nil),
            action: nil
        )

        let buttons = view.subviewsRecursive().compactMap { $0 as? UIButton }
        XCTAssertTrue(buttons.allSatisfy(\.isHidden))
    }

    func test_stateView_errorWithoutButton_hidesButton() {
        let view = DSStateView()
        view.configure(
            state: .error(title: "Error", message: "Something went wrong", buttonTitle: nil),
            action: nil
        )

        let buttons = view.subviewsRecursive().compactMap { $0 as? UIButton }
        XCTAssertTrue(buttons.allSatisfy(\.isHidden))
    }
}

private extension UIView {
    func subviewsRecursive() -> [UIView] {
        subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}