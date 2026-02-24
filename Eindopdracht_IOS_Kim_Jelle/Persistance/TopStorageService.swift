import Foundation

final class TopStorageService {

    private let fileURL: URL

    init() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documents.appendingPathComponent("tops.json")
    }

    func load() async throws -> [TopLog] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([TopLog].self, from: data)
    }

    func save(_ tops: [TopLog]) async throws {
        let data = try JSONEncoder().encode(tops)
        try data.write(to: fileURL)
    }
}
