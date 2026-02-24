import SwiftUI
import Combine

@MainActor
final class LogbookViewModel: ObservableObject {

    @Published var tops: [TopLog] = []

    private let storage = TopStorageService()
    
    init() {
            Task {
                await load()
            }
        }

    func load() async {
        do {
            tops = try await storage.load()
        } catch {
            print("Failed to load tops:", error)
        }
    }

    func add(top: TopLog, image: UIImage?) async {
        var newTop = top
        if let image {
            let fileName = "\(top.id.uuidString).jpg"
            do {
                try ImageStorageService.shared.saveImage(image, with: fileName)
                newTop.photoFileName = fileName
            } catch {
                print("Error saving image:", error)
            }
        }
        tops.insert(newTop, at: 0) // nieuwste eerst
        await save()
    }

    func delete(at offsets: IndexSet) async {
        tops.remove(atOffsets: offsets)
        await save()
    }

    // Added convenience method to delete by TopLog
    func delete(top: TopLog) async {
        if let index = tops.firstIndex(where: { $0.id == top.id }) {
            tops.remove(at: index)
            await save()
        }
    }

    func update(top: TopLog, image: UIImage?) async {
        var updatedTop = top
        if let image {
            let fileName = "\(top.id.uuidString).jpg"
            do {
                try ImageStorageService.shared.saveImage(image, with: fileName)
                updatedTop.photoFileName = fileName
            } catch {
                print("Error saving image:", error)
            }
        }
        if let index = tops.firstIndex(where: { $0.id == top.id }) {
            tops[index] = updatedTop
            await save()
        }
    }

    private func save() async {
        do {
            try await storage.save(tops)
        } catch {
            print("Failed to save tops:", error)
        }
    }
}
