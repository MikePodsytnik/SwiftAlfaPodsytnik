import Foundation

struct ButtonContent: Decodable {
    let title: String
    let style: BDUIButtonStyleToken?
    let state: BDUIButtonStateToken?
}
