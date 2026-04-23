import Foundation

struct LabelContent: Decodable {
    let text: String
    let typography: BDUITypographyToken?
    let textColor: BDUIColorToken?
    let numberOfLines: Int?
    let textAlignment: String?
}
