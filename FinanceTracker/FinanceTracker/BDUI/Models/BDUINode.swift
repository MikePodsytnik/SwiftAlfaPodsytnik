import Foundation

struct BDUINode: Decodable {
    let type: BDUIViewType
    let layout: BDUILayout?
    let action: BDUIAction?
    let subviews: [BDUINode]
    let payload: BDUIPayload

    private enum CodingKeys: String, CodingKey {
        case type
        case content
        case layout
        case action
        case subviews
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(BDUIViewType.self, forKey: .type)
        layout = try container.decodeIfPresent(BDUILayout.self, forKey: .layout)
        action = try container.decodeIfPresent(BDUIAction.self, forKey: .action)
        subviews = try container.decodeIfPresent([BDUINode].self, forKey: .subviews) ?? []

        switch type {
        case .contentView:
            payload = .contentView(try container.decode(ContentViewContent.self, forKey: .content))
        case .stackView:
            payload = .stackView(try container.decode(StackViewContent.self, forKey: .content))
        case .label:
            payload = .label(try container.decode(LabelContent.self, forKey: .content))
        case .button:
            payload = .button(try container.decode(ButtonContent.self, forKey: .content))
        case .textField:
            payload = .textField(try container.decode(TextFieldContent.self, forKey: .content))
        case .stateView:
            payload = .stateView(try container.decode(StateViewContent.self, forKey: .content))
        case .infoRow:
            payload = .infoRow(try container.decode(InfoRowContent.self, forKey: .content))
        }
    }
}
