import Foundation

protocol SearchInteractorProtocol {
    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void)
    func getFavorites() -> [FavoriteLocation]
    func addFavorite(_ location: Location)
    func removeFavorite(_ location: FavoriteLocation)
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
        repository.fetchLocations(query: query, completion: completion)
    }

    func getFavorites() -> [FavoriteLocation] {
        return favoritesRepository.getFavorites()
    }

    func addFavorite(_ location: Location) {
        let favorite = FavoriteLocation(name: location.name, country: location.country, temp: nil, icon: nil)
        favoritesRepository.addFavorite(favorite)
    }
    
    func removeFavorite(_ location: FavoriteLocation) {
           favoritesRepository.removeFavorite(location) 
       }
}
