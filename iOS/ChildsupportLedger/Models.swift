import Foundation

struct Payment: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var amount: Double
    var direction: String
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), amount: Double = 0, direction: String = "", notes: String = "") {
        self.id = id
        self.date = date
        self.amount = amount
        self.direction = direction
        self.notes = notes
    }
}
