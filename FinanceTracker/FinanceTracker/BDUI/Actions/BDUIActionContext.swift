import UIKit

struct BDUIActionContext {
    let onRoute: ((String, UIView?) -> Void)?
    let onReload: ((UIView?) -> Void)?
    let onPrint: ((String) -> Void)?
    let onCustom: ((String, [String: AnyDecodable]?, UIView?) -> Void)?

    init(
        onRoute: ((String, UIView?) -> Void)? = nil,
        onReload: ((UIView?) -> Void)? = nil,
        onPrint: ((String) -> Void)? = nil,
        onCustom: ((String, [String: AnyDecodable]?, UIView?) -> Void)? = nil
    ) {
        self.onRoute = onRoute
        self.onReload = onReload
        self.onPrint = onPrint
        self.onCustom = onCustom
    }
}
