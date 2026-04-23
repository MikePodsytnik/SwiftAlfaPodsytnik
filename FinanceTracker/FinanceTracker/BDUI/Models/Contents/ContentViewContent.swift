import Foundation

struct ContentViewContent: Decodable {
    let backgroundColor: BDUIColorToken?
    let cornerRadius: BDUICornerRadiusToken?
    let padding: BDUIEdgeInsets?
    let axis: BDUIAxisToken?
    let spacing: BDUISpacingToken?
    let alignment: BDUIAlignmentToken?
    let distribution: BDUIDistributionToken?
}
