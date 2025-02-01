import Foundation

protocol SearchInteractorProtocol {
    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void)
    func getFavorites() -> Result<[FavoriteLocation], Error>
    func addFavorite(_ location: Location, completion: @escaping (Result<Void, Error>) -> Void)
    func removeFavorite(_ location: FavoriteLocation, completion: @escaping (Result<Void, Error>) -> Void)
}


class SearchInteractor: SearchInteractorProtocol {
    private let repository: WeatherRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository(),
         favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.repository = repository
        self.favoritesRepository = favoritesRepository
    }

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        repository.fetchLocations(query: query) { result in
            switch result {
            case .success(let locations):
                completion(.success(locations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

   
    func getFavorites() -> Result<[FavoriteLocation], Error> {
        return favoritesRepository.getFavorites()
    }

    func addFavorite(_ location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let favorite = FavoriteLocation(name: location.name, country: location.country, temp: nil, icon: nil)
        completion(favoritesRepository.addFavorite(favorite))
    }

    func removeFavorite(_ location: FavoriteLocation, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(favoritesRepository.removeFavorite(location))
    }
}
