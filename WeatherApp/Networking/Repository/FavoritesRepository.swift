import Foundation

protocol FavoritesRepositoryProtocol {
    func getFavorites() -> [FavoriteLocation]
    func addFavorite(_ location: FavoriteLocation)
    func removeFavorite(_ location: FavoriteLocation)
}


class FavoritesRepository: FavoritesRepositoryProtocol {
    private let favoritesKey = "favoriteLocations"

    func getFavorites() -> [FavoriteLocation] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([FavoriteLocation].self, from: data) {
            return favorites
        }
        return []
    }

    func addFavorite(_ location: FavoriteLocation) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0.name == location.name }) {
            favorites.append(location)
            saveFavorites(favorites)
        }
    }

    func removeFavorite(_ location: FavoriteLocation) {
        var favorites = getFavorites()
        favorites.removeAll { $0.name == location.name }
        saveFavorites(favorites)
    }

    private func saveFavorites(_ favorites: [FavoriteLocation]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}

