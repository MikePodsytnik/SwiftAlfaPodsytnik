import UIKit

struct BDUIEdgeInsets: Decodable {
    let top: BDUISpacingToken?
    let left: BDUISpacingToken?
    let bottom: BDUISpacingToken?
    let right: BDUISpacingToken?

    var uiInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: top?.value ?? 0,
            left: left?.value ?? 0,
            bottom: bottom?.value ?? 0,
            right: right?.value ?? 0
        )
    }
}
