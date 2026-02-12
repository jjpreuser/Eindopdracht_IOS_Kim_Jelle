import SwiftUI
import Combine

@MainActor
final class BoulderViewModel: ObservableObject {

    @Published var boulders: [Boulder] = []
    @Published var isLoading = false

    private let service = OpenBetaService()

    func load(areaId: String) async {
        isLoading = true
        do {
            boulders = try await service.fetchBoulders(areaId: areaId)
        } catch {
            print(error)
        }
        isLoading = false
    }
}
