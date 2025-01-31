import Foundation
@testable import WeatherApp

class MockFavoritesRepository: FavoritesRepositoryProtocol {
    var favorites: [FavoriteLocation] = []
    var addFavoriteCalled = false
    var removeFavoriteCalled = false

    func getFavorites() -> [FavoriteLocation] {
        return favorites
    }

    func addFavorite(_ location: FavoriteLocation) {
        addFavoriteCalled = true
        favorites.append(location)
    }

    func removeFavorite(_ location: FavoriteLocation) {
        removeFavoriteCalled = true
        favorites.removeAll { $0.name == location.name }
    }
}
