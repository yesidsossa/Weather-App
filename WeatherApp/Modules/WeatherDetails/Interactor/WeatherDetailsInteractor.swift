import Foundation

protocol WeatherDetailsInteractorProtocol {
    func fetchWeatherDetails(location: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void)
}

class WeatherDetailsInteractor: WeatherDetailsInteractorProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func fetchWeatherDetails(location: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void) {
        repository.fetchWeatherDetails(location: location, completion: completion)
    }
}
