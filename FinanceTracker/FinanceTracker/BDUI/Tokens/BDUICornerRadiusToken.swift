import UIKit

enum BDUICornerRadiusToken: String, Decodable {
    case s
    case m
    case l

    var value: CGFloat {
        switch self {
        case .s:
            return DS.Radius.s
        case .m:
            return DS.Radius.m
        case .l:
            return DS.Radius.l
        }
    }
}
