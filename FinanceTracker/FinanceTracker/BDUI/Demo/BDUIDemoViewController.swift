import UIKit

// just a demo view controller (don't blame me for my architecture)
final class BDUIDemoViewController: UIViewController {
    private lazy var actionHandler = BDUIActionHandler(
        context: BDUIActionContext(
            onRoute: { [weak self] route, _ in
                let alert = UIAlertController(
                    title: "Route",
                    message: route,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            },
            onReload: { [weak self] _ in
                self?.reloadUI()
            },
            onPrint: { message in
                print(message)
            },
            onCustom: { [weak self] name, payload, _ in
                let alert = UIAlertController(
                    title: name,
                    message: String(describing: payload ?? [:]),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        )
    )

    private lazy var renderer = BDUIRenderer(actionHandler: actionHandler)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Colors.background
        reloadUI()
    }

    private func reloadUI() {
        view.subviews.forEach { $0.removeFromSuperview() }

        guard
            let url = Bundle.main.url(forResource: "sample_bdui", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let node = try? JSONDecoder().decode(BDUINode.self, from: data)
        else {
            return
        }

        let builtView = renderer.render(node: node)
        builtView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(builtView)

        NSLayoutConstraint.activate([
            builtView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DS.Spacing.l),
            builtView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
            builtView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l)
        ])
    }
}
