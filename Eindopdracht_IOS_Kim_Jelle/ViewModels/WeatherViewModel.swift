import SwiftUI
import Combine

class KNMIViewModel: ObservableObject {
    @Published var forecastText: String = ""
    @Published var isLoading = false
    @Published var error: String?
    
    private let service = KNMIService()
    private var cancellables = Set<AnyCancellable>()
    
    func loadForecast() {
        isLoading = true
        service.fetchForecast()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(err) = completion {
                    self?.error = err.localizedDescription
                }
            } receiveValue: { [weak self] text in
                self?.forecastText = text
            }
            .store(in: &cancellables)
    }
}
