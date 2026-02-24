import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText: String = ""

    private let service = WeerLiveService()
    private var cancellables = Set<AnyCancellable>()

    func loadWeather() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        error = nil

        service.fetchWeather(for: searchText)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(err) = completion {
                    self?.error = err.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.weather = response
            }
            .store(in: &cancellables)
    }
}
