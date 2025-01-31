import Foundation
@testable import WeatherApp

class MockSearchInteractor: SearchInteractorProtocol {
    var fetchLocationsCalled = false
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var queryReceived: String?
    var favorites: [FavoriteLocation] = []

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        fetchLocationsCalled = true
        queryReceived = query
        completion(.success([]))
    }

    func getFavorites() -> [FavoriteLocation] {
        return favorites
    }

    func addFavorite(_ location: Location) {
        addFavoriteCalled = true
        let favorite = FavoriteLocation(name: location.name, country: location.country, temp: nil, icon: nil)
        favorites.append(favorite)
    }

    func removeFavorite(_ location: FavoriteLocation) {
        removeFavoriteCalled = true
        favorites.removeAll { $0.name == location.name }
    }
}
