import Foundation
@testable import WeatherApp

class MockWeatherDetailsView: WeatherDetailsViewProtocol {
    var weatherDetailsReceived: WeatherDetails?
    var errorMessageReceived: String?

    func showWeatherDetails(_ details: WeatherDetails) {
        weatherDetailsReceived = details
    }

    func showError(_ message: String) {
        errorMessageReceived = message
    }
}
