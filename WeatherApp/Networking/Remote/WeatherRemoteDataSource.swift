import Foundation

protocol WeatherRemoteDataSourceProtocol {
    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void)
    func fetchWeatherDetails(location: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void)
}

class WeatherRemoteDataSource: WeatherRemoteDataSourceProtocol {
    private let apiKey = "de5553176da64306b86153651221606"
    private let baseURL = "https://api.weatherapi.com/v1"

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        let urlString = "\(baseURL)/search.json?key=\(apiKey)&q=\(query)"
        fetch(urlString: urlString, completion: completion)
    }

    func fetchWeatherDetails(location: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void) {
        let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(location)&days=3"
        fetch(urlString: urlString, completion: completion)
    }

    private func fetch<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Datos no válidos"])))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
