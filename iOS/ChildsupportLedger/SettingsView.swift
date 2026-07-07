import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    @AppStorage("childsupportledger_notifyEnabled") private var notifyEnabled = true
    @AppStorage("childsupportledger_iCloudSyncEnabled") private var iCloudSyncEnabled = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Notifications", isOn: $notifyEnabled)
                        .accessibilityIdentifier("toggle_notifications")
                    Toggle("iCloud Sync (coming soon)", isOn: $iCloudSyncEnabled)
                        .accessibilityIdentifier("toggle_icloud")
                        .disabled(true)
                }
                Section("Subscription") {
                    if purchaseManager.isPurchased {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") {
                            Task { await purchaseManager.purchase() }
                        }
                        .accessibilityIdentifier("button_upgrade")
                    }
                    Button("Restore Purchases") {
                        Task { await purchaseManager.restore() }
                    }
                    .accessibilityIdentifier("button_restore")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/childsupportledger-app/privacy.html")!)
                    Text("Version 1.0")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("button_settings_done")
                }
            }
        }
    }
}
