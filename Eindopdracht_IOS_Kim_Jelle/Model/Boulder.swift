import Foundation

struct Boulder: Identifiable, Codable {
    let id = UUID()
    let uuid: String
    let name: String
    let grades: Grades?
    let type: String?

    struct Grades: Codable {
        let vscale: String?
    }

    private enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case grades
        case type
    }
}
