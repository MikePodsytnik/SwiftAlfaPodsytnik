import Foundation

struct TextFieldContent: Decodable {
    let title: String
    let placeholder: String
    let text: String?
    let state: BDUITextFieldStateToken?
    let errorMessage: String?
    let isSecureTextEntry: Bool?
    let keyboardType: Int?
    let returnKeyType: Int?
}
