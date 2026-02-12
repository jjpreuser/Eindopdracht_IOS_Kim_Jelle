import Foundation

struct TopLog: Identifiable, Codable {
    var id: UUID
    var boulderId: String
    var boulderName: String
    var grade: String
    var date: Date
    var attempts: Int
    var rating: Int
    var notes: String
}
