import Foundation
import Combine

class KNMIService {
    private let apiKey = "2071d0d1af"
    
    func fetchForecast() -> AnyPublisher<String, Error> {
        // replace {datasetName}/versions/{version}/files/{filename}
        let urlString = "https://api.dataplatform.knmi.nl/open-data/v1/datasets/outlook_weather_forecast/versions/1.0/files/outlook_weather_forecast.txt"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).mapError { $0 as Error }.eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in String(decoding: data, as: UTF8.self) }
            .mapError { $0 as Error }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
