import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productID = "csledger_pro_monthly"

    @Published private(set) var isPurchased: Bool = false
    @Published private(set) var product: Product?
    @Published var lastError: String?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                await self?.handle(result)
            }
        }
        Task { await load() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func load() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
            await refreshEntitlement()
        } catch {
            lastError = error.localizedDescription
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(verification)
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func restore() async {
        do {
            try await AppStore.sync()
            await refreshEntitlement()
        } catch {
            lastError = error.localizedDescription
        }
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else { return }
        await transaction.finish()
        await refreshEntitlement()
    }

    private func refreshEntitlement() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == Self.productID {
                isPurchased = true
                return
            }
        }
        isPurchased = false
    }
}
