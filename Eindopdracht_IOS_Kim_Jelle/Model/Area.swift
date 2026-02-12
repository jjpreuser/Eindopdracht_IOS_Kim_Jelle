struct Area: Identifiable, Codable {
    let id = UUID()
    let uuid: String
    let area_name: String
    let metadata: Metadata?

    struct Metadata: Codable {
        let lat: Double?
        let lng: Double?
    }
}
