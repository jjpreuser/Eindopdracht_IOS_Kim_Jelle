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
            let loaded = try await storage.load()
            tops = loaded.sorted { $0.date > $1.date } // nieuwste eerst
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
        tops.insert(newTop, at: 0)
        await save()
    }

    func delete(at offsets: IndexSet) async {
        tops.remove(atOffsets: offsets)
        await save()
    }

    func delete(top: TopLog) async {
        if let fileName = top.photoFileName {
            try? ImageStorageService.shared.deleteImage(fileName: fileName)
        }

        if let index = tops.firstIndex(where: { $0.id == top.id }) {
            tops.remove(at: index)
            await save()
        }
    }

    func update(top: TopLog, image: UIImage?) async {
        var updatedTop = top

        if image == nil {
            if let fileName = top.photoFileName {
                try? ImageStorageService.shared.deleteImage(fileName: fileName)
            }
            updatedTop.photoFileName = nil
        } else if let image {
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
        }

        tops.sort { $0.date > $1.date }
        await save()
    }

    private func save() async {
        do {
            try await storage.save(tops)
        } catch {
            print("Failed to save tops:", error)
        }
    }
}
