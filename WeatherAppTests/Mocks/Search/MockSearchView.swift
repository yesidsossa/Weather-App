import Foundation
@testable import WeatherApp

class MockSearchView: SearchViewProtocol {
    var locationsReceived: [Location] = []
    var errorMessageReceived: String?
    var favoritesReceived: [FavoriteLocation] = []
    var showFavoritesCalled = false

    func showLocations(_ locations: [Location]) {
        locationsReceived = locations
    }

    func showFavorites(_ favorites: [FavoriteLocation]) {
        favoritesReceived = favorites
        showFavoritesCalled = true
    }

    func showError(_ message: String) {
        errorMessageReceived = message
    }
}
