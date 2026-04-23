import UIKit

final class DefaultBDUIActionHandler: BDUIActionHandler {
    init() {
        super.init(
            context: BDUIActionContext(
                onRoute: { route, _ in
                    print("BDUI route: \(route)")
                },
                onReload: { _ in
                    print("BDUI reload")
                },
                onPrint: { message in
                    print(message)
                },
                onCustom: { name, payload, _ in
                    print("BDUI custom action: \(name), payload: \(payload ?? [:])")
                }
            )
        )
    }
}
