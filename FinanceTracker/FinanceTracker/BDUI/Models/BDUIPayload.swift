import Foundation

enum BDUIPayload {
    case contentView(ContentViewContent)
    case stackView(StackViewContent)
    case label(LabelContent)
    case button(ButtonContent)
    case textField(TextFieldContent)
    case stateView(StateViewContent)
    case infoRow(InfoRowContent)
}
