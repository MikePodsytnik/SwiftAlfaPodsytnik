import UIKit

struct BDUILayout: Decodable {
    let padding: BDUIEdgeInsets?
    let width: CGFloat?
    let height: CGFloat?
    let backgroundColor: BDUIColorToken?
    let cornerRadius: BDUICornerRadiusToken?
}
