import Foundation
@testable import WeatherApp

class MockSearchView: SearchViewProtocol {
    var locationsReceived: [Location] = []
    var errorMessageReceived: String?
    var favoritesReceived: [FavoriteLocation] = []
    var showFavoritesCalled = false
    var showErrorCalled = false

    func showLocations(_ locations: [Location]) {
        locationsReceived = locations
    }

    func showFavorites(_ favorites: [FavoriteLocation]) {
        favoritesReceived = favorites
        showFavoritesCalled = true
    }

    func showError(_ message: String) {
        errorMessageReceived = message
        showErrorCalled = true
    }

    func isFavorite(location: FavoriteLocation) -> Bool {
        return favoritesReceived.contains(where: { $0.name == location.name })
    }
}
