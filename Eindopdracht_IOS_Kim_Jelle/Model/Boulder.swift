struct Boulder: Identifiable, Codable {
    let id = UUID()
    let uuid: String
    let name: String
    let grades: Grades?
    let type: String?

    struct Grades: Codable {
        let vscale: String?
    }
}
