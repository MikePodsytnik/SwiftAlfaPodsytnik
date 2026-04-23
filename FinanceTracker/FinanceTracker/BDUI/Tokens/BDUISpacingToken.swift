import UIKit

enum BDUISpacingToken: String, Decodable {
    case xs
    case s
    case m
    case l
    case xl
    case xxl

    var value: CGFloat {
        switch self {
        case .xs:
            return DS.Spacing.xs
        case .s:
            return DS.Spacing.s
        case .m:
            return DS.Spacing.m
        case .l:
            return DS.Spacing.l
        case .xl:
            return DS.Spacing.xl
        case .xxl:
            return DS.Spacing.xxl
        }
    }
}
