import Foundation
import UIKit

extension KeyedDecodingContainer {
    func decodeCGFloatIfPresent(forKey key: Key) throws -> CGFloat? {
        if let value = try decodeIfPresent(Double.self, forKey: key) {
            return CGFloat(value)
        }
        return nil
    }
}
