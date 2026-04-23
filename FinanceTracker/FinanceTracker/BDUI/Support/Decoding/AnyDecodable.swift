import Foundation

struct AnyDecodable: Decodable, CustomStringConvertible {
    let value: Any

    var description: String {
        String(describing: value)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = intValue
            return
        }

        if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
            return
        }

        if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
            return
        }

        if let stringValue = try? container.decode(String.self) {
            value = stringValue
            return
        }

        if let arrayValue = try? container.decode([AnyDecodable].self) {
            value = arrayValue.map(\.value)
            return
        }

        if let dictValue = try? container.decode([String: AnyDecodable].self) {
            value = dictValue.mapValues(\.value)
            return
        }

        if container.decodeNil() {
            value = Optional<Any>.none as Any
            return
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unsupported JSON value"
        )
    }
}
