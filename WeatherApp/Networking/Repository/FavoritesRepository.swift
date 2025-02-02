import Foundation

protocol FavoritesRepositoryProtocol {
    func getFavorites() -> Result<[FavoriteLocation], Error>
    func addFavorite(_ location: FavoriteLocation) -> Result<Void, Error>
    func removeFavorite(_ location: FavoriteLocation) -> Result<Void, Error>
}


class FavoritesRepository: FavoritesRepositoryProtocol {
    private let favoritesKey = "favoriteLocations"

    func getFavorites() -> Result<[FavoriteLocation], Error> {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {

            do {
                let favorites = try JSONDecoder().decode([FavoriteLocation].self, from: data)
                return .success(favorites)
            } catch {
                return .failure(NSError(domain: "FavoritesRepository", code: -2, userInfo: [NSLocalizedDescriptionKey: "Error al decodificar los favoritos"]))
            }
        } else {
            return .success([])
        }
    }




    func addFavorite(_ location: FavoriteLocation) -> Result<Void, Error> {
        switch getFavorites() {
        case .success(var favorites):
            if let index = favorites.firstIndex(where: { $0.name == location.name }) {
                favorites[index] = location
            } else {
                favorites.append(location)
            }

            if saveFavorites(favorites) {
                return .success(())
            } else {
                return .failure(NSError(domain: "FavoritesRepository", code: -3, userInfo: [NSLocalizedDescriptionKey: "No se pudo guardar el favorito"]))
            }

        case .failure(let error):
            return .failure(error)
        }
    }



    func removeFavorite(_ location: FavoriteLocation) -> Result<Void, Error> {
        switch getFavorites() {
        case .success(var favorites):
            favorites.removeAll { $0.name == location.name }
            
            if saveFavorites(favorites) {
                return .success(())
            }
            return .failure(NSError(domain: "FavoritesRepository", code: -3, userInfo: [NSLocalizedDescriptionKey: "No se pudo eliminar el favorito"]))
            
        case .failure(let error):
            return .failure(error)
        }
    }

    private func saveFavorites(_ favorites: [FavoriteLocation]) -> Bool {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
            return true
        }
        return false
    }
}



