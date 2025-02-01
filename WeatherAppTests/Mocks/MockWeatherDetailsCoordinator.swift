import UIKit
@testable import WeatherApp

class MockWeatherDetailsCoordinator: WeatherDetailsCoordinatorProtocol {

    var didNavigateBack = false
    var didStart = false

    func start() {
        didStart = true
    }

    func navigateBack() {
        didNavigateBack = true
    }
}
