import Foundation

protocol SearchInteractorProtocol {
    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void)
}

class SearchInteractor: SearchInteractorProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        repository.fetchLocations(query: query, completion: completion)
    }
}
