import Foundation
@testable import WeatherApp

class MockFavoritesRepository: FavoritesRepositoryProtocol {
    var favorites: [FavoriteLocation] = []
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var shouldReturnError = false

    func getFavorites() -> Result<[FavoriteLocation], Error> {
        if shouldReturnError {
            return .failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error en favoritos"]))
        }
        return .success(favorites)
    }

    func addFavorite(_ location: FavoriteLocation) -> Result<Void, Error> {
        addFavoriteCalled = true
        if shouldReturnError {
            return .failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al agregar favorito"]))
        }
        if !favorites.contains(where: { $0.name == location.name }) {
            favorites.append(location)
        }
        return .success(())
    }

    func removeFavorite(_ location: FavoriteLocation) -> Result<Void, Error> {
        removeFavoriteCalled = true
        if shouldReturnError {
            return .failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al eliminar favorito"]))
        }
        favorites.removeAll { $0.name == location.name }
        return .success(())
    }
}

