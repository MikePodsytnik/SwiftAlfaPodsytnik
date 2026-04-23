import Foundation

enum BDUIActionType: String, Decodable {
    case print
    case route
    case reload
    case custom
    case none
}

struct BDUIAction: Decodable {
    let type: BDUIActionType
    let route: String?
    let message: String?
    let name: String?
    let payload: [String: AnyDecodable]?

    init(
        type: BDUIActionType,
        route: String? = nil,
        message: String? = nil,
        name: String? = nil,
        payload: [String: AnyDecodable]? = nil
    ) {
        self.type = type
        self.route = route
        self.message = message
        self.name = name
        self.payload = payload
    }
}
