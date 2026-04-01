import Foundation

final class TransactionsListPresenterImpl: TransactionsListPresenter {
    private weak var view: TransactionsListView?
    private let router: TransactionsListRouter
    private let fetchTransactionsPageUseCase: FetchTransactionsPageUseCase
    private let session: UserSession

    private let pageSize = 25

    private var items: [TransactionItemViewModel] = []
    private var totalCount = 0
    private var currentSkip = 0
    private var isLoading = false
    private var didLoadFirstPage = false
    private var hasMorePages = true

    private var loadTask: Task<Void, Never>?

    init(
        view: TransactionsListView,
        router: TransactionsListRouter,
        fetchTransactionsPageUseCase: FetchTransactionsPageUseCase,
        session: UserSession
    ) {
        self.view = view
        self.router = router
        self.fetchTransactionsPageUseCase = fetchTransactionsPageUseCase
        self.session = session
    }

    deinit {
        loadTask?.cancel()
    }

    func didLoad() {
        guard !didLoadFirstPage else { return }
        didLoadFirstPage = true
        loadFirstPage()
    }

    func didTapRetry() {
        loadFirstPage(forceReload: true)
    }

    func didReachListEnd() {
        guard didLoadFirstPage else { return }
        guard !isLoading else { return }
        guard hasMorePages else { return }
        loadNextPage()
    }

    func didSelectTransaction(id: TransactionID) {
        router.openTransactionDetails(id: id)
    }

    func didTapAddTransaction() {
        router.openAddTransaction()
    }

    private func loadFirstPage(forceReload: Bool = false) {
        loadTask?.cancel()
        isLoading = true
        currentSkip = 0
        totalCount = 0
        hasMorePages = true

        if forceReload {
            items = []
        }

        view?.render(.loading)

        loadTask = Task { [weak self] in
            guard let self else { return }

            do {
                let page = try await fetchTransactionsPageUseCase.execute(
                    userId: session.userId,
                    limit: pageSize,
                    skip: 0
                )

                if Task.isCancelled { return }

                let mapped = page.items.map(Self.makeViewModel)

                await MainActor.run {
                    self.isLoading = false
                    self.currentSkip = page.skip + page.items.count
                    self.totalCount = page.total
                    self.hasMorePages = page.hasMore
                    self.items = mapped

                    if mapped.isEmpty {
                        self.view?.render(.empty)
                    } else {
                        self.view?.render(.content(
                            items: mapped,
                            update: .reload,
                            pagination: .idle
                        ))
                    }
                }
            } catch {
                if case NetworkError.cancelled = error {
                    return
                }

                let message = Self.mapErrorToMessage(error)

                await MainActor.run {
                    self.isLoading = false
                    self.view?.render(.error(message))
                }
            }
        }
    }

    private func loadNextPage() {
        guard !items.isEmpty else { return }

        loadTask?.cancel()
        isLoading = true

        view?.render(.content(
            items: items,
            update: .none,
            pagination: .loading
        ))

        let nextSkip = currentSkip

        loadTask = Task { [weak self] in
            guard let self else { return }

            do {
                let page = try await fetchTransactionsPageUseCase.execute(
                    userId: session.userId,
                    limit: pageSize,
                    skip: nextSkip
                )

                if Task.isCancelled { return }

                let mapped = page.items.map(Self.makeViewModel)

                await MainActor.run {
                    self.isLoading = false
                    self.currentSkip = page.skip + page.items.count
                    self.totalCount = page.total
                    self.hasMorePages = page.hasMore
                    self.items.append(contentsOf: mapped)

                    self.view?.render(.content(
                        items: self.items,
                        update: .append(newItems: mapped),
                        pagination: .idle
                    ))
                }
            } catch {
                if case NetworkError.cancelled = error {
                    return
                }

                await MainActor.run {
                    self.isLoading = false
                    self.view?.render(.content(
                        items: self.items,
                        update: .none,
                        pagination: .idle
                    ))
                }
            }
        }
    }

    private static func makeViewModel(_ transaction: Transaction) -> TransactionItemViewModel {
        TransactionItemViewModel(
            id: transaction.id,
            title: transaction.category,
            subtitle: transaction.comment ?? "No details",
            formattedAmount: formatAmount(transaction.amount)
        )
    }

    private static func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }

    private static func mapErrorToMessage(_ error: Error) -> String {
        switch error {
        case NetworkError.transport:
            return "Network error. Check your connection."
        case NetworkError.httpStatus(let code):
            return "Server error: \(code)."
        case NetworkError.decoding:
            return "Failed to parse server response."
        case NetworkError.invalidResponse:
            return "Invalid server response."
        default:
            return "Something went wrong."
        }
    }
}
