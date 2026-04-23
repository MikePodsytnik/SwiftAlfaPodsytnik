import Foundation

struct StackViewContent: Decodable {
    let axis: BDUIAxisToken?
    let spacing: BDUISpacingToken?
    let alignment: BDUIAlignmentToken?
    let distribution: BDUIDistributionToken?
}
