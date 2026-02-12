import SwiftUI
import Combine

@MainActor
final class LogbookViewModel: ObservableObject {

    @Published var tops: [TopLog] = []

    private let storage = TopStorageService()

    func load() async {
        do {
            tops = try await storage.load()
        } catch {
            print(error)
        }
    }

    func add(top: TopLog) async {
        tops.append(top)
        await save()
    }

    func delete(at offsets: IndexSet) async {
        tops.remove(atOffsets: offsets)
        await save()
    }

    func update(top: TopLog) async {
        if let index = tops.firstIndex(where: { $0.id == top.id }) {
            tops[index] = top
            await save()
        }
    }

    private func save() async {
        do {
            try await storage.save(tops)
        } catch {
            print(error)
        }
    }
}
