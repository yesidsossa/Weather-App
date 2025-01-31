import Foundation
@testable import WeatherApp

class MockSearchView: SearchViewProtocol {
    var locationsReceived: [Location] = []
    var errorMessageReceived: String?

    func showLocations(_ locations: [Location]) {
        locationsReceived = locations
    }

    func showError(_ message: String) {
        errorMessageReceived = message
    }
}
