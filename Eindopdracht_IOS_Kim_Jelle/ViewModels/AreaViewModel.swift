import Foundation
internal import Combine
@MainActor
final class AreaViewModel: ObservableObject {

    @Published var areas: [Area] = []
    @Published var isLoading = false

    private let service = OpenBetaService()

    func search(name: String) async {
        isLoading = true
        do {
            areas = try await service.searchAreas(name: name)
        } catch {
            print(error)
        }
        isLoading = false
    }
}
