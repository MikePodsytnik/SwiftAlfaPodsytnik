import Foundation

struct StateViewContent: Decodable {
    let state: BDUIStateViewStateToken
    let title: String
    let message: String?
    let buttonTitle: String?
}
