import Foundation
@testable import WeatherApp

class MockWeatherRepository: WeatherRepositoryProtocol {
    var shouldReturnError = false
    var mockLocations: [Location] = []
    var mockWeatherDetails: WeatherDetails?

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error simulado"])))
        } else {
            completion(.success(mockLocations))
        }
    }

    func fetchWeatherDetails(location: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error simulado"])))
        } else if let details = mockWeatherDetails {
            completion(.success(details))
        } else {
            completion(.failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
        }
    }
}
