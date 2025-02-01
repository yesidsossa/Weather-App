import Foundation
@testable import WeatherApp

class MockSearchInteractor: SearchInteractorProtocol {
    var fetchLocationsCalled = false
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var queryReceived: String?
    var favorites: [FavoriteLocation] = []
    var shouldReturnError = false

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        fetchLocationsCalled = true
        queryReceived = query

        if shouldReturnError {
            completion(.failure(NSError(domain: "MockSearchInteractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error simulado"])))
        } else {
            completion(.success([]))
        }
    }

    func getFavorites() -> Result<[FavoriteLocation], Error> {
        return shouldReturnError
            ? .failure(NSError(domain: "MockSearchInteractor", code: -2, userInfo: [NSLocalizedDescriptionKey: "Error en favoritos"]))
            : .success(favorites)
    }

    func addFavorite(_ location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        addFavoriteCalled = true

        if shouldReturnError {
            completion(.failure(NSError(domain: "MockSearchInteractor", code: -3, userInfo: [NSLocalizedDescriptionKey: "Error al agregar favorito"])))
        } else {
            let favorite = FavoriteLocation(name: location.name, country: location.country, temp: nil, icon: nil)
            if let index = favorites.firstIndex(where: { $0.name == location.name }) {
                favorites[index] = favorite
            } else {
                favorites.append(favorite) 
            }
            completion(.success(()))
        }
    }

    func removeFavorite(_ location: FavoriteLocation, completion: @escaping (Result<Void, Error>) -> Void) {
        removeFavoriteCalled = true
        
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockSearchInteractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al eliminar favorito"])))
        } else {
            favorites.removeAll { $0.name == location.name }
            completion(.success(()))
        }
    }

}
