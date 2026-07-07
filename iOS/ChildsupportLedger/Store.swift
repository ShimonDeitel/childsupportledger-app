import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Payment] = []
    @Published var isPro: Bool = false

    static let freeLimit = 200

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("childsupportledger_items.json")
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= Store.freeLimit
    }

    func add(_ item: Payment) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Payment) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Payment) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Payment].self, from: data) else {
            items = [
        Payment(date: Calendar.current.date(byAdding: .day, value: -0, to: Date()) ?? Date(), amount: 5.0, direction: "Sample Direction 1", notes: "Sample Notes 1"),
        Payment(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), amount: 10.0, direction: "Sample Direction 2", notes: "Sample Notes 2"),
        Payment(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), amount: 15.0, direction: "Sample Direction 3", notes: "Sample Notes 3")
            ]
            save()
            return
        }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
