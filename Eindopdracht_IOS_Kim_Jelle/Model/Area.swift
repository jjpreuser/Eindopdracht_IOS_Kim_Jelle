import Foundation

struct Area: Identifiable, Codable, Hashable {
    // Use the backend-provided uuid as the stable identifier
    var id: String { uuid }

    let uuid: String
    let area_name: String
    let metadata: Metadata?

    struct Metadata: Codable, Hashable {
        let lat: Double?
        let lng: Double?
    }

    private enum CodingKeys: String, CodingKey {
        case uuid
        case area_name
        case metadata
    }

    // Hashable/Equatable are synthesized automatically using all stored properties.
    // Since id is computed, synthesis will effectively use uuid, area_name, metadata.
    // That's fine, but if you prefer to hash only by uuid, you can uncomment below:

    /*
    static func == (lhs: Area, rhs: Area) -> Bool {
        lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    */
}
