import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.accent)
                    Text("Childsupport Ledger Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(.primary)
                    Text("Annual payment summary export as PDF")
                        .font(Theme.bodyFont)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 32)
                    if let product = purchaseManager.product {
                        Text("\(product.displayPrice)/month")
                            .font(Theme.headlineFont)
                            .foregroundStyle(Theme.secondaryAccent)
                    }
                    Button {
                        Task {
                            await purchaseManager.purchase()
                            if purchaseManager.isPurchased { dismiss() }
                        }
                    } label: {
                        Text("Unlock Pro")
                            .font(Theme.headlineFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("button_purchase")
                    .padding(.horizontal, 32)

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restore() }
                    }
                    .accessibilityIdentifier("button_restore_paywall")

                    Button("Not Now") { dismiss() }
                        .accessibilityIdentifier("button_dismiss_paywall")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
}
