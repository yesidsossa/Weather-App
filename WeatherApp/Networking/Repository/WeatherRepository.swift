import Foundation

protocol WeatherRepositoryProtocol {
    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void)
    func fetchWeatherDetails(location: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void)
}


class WeatherRepository: WeatherRepositoryProtocol {
    private let remoteDataSource: WeatherRemoteDataSourceProtocol

    init(remoteDataSource: WeatherRemoteDataSourceProtocol = WeatherRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        remoteDataSource.fetchLocations(query: query, completion: completion)
    }

    func fetchWeatherDetails(location: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void) {
        remoteDataSource.fetchWeatherDetails(location: location) { result in
            switch result {
            case .success(let weatherDetails):
                completion(.success(weatherDetails))
            case .failure(let error):
                completion(.failure(error)) 
            }
        }
    }
}
