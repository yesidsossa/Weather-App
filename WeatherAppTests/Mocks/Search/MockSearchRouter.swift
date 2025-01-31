import UIKit
@testable import WeatherApp

class MockSearchRouter: SearchRouterProtocol {
    var navigateToWeatherDetailsCalled = false
    var locationReceived: Location?

    func navigateToWeatherDetails(from view: SearchViewProtocol, location: Location) {
        navigateToWeatherDetailsCalled = true
        locationReceived = location
    }
}
