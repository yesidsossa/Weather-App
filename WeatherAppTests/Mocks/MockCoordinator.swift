import UIKit
@testable import WeatherApp

class MockCoordinator: SearchCoordinatorProtocol {
    var navigationController: UINavigationController
    var didNavigateToWeatherDetails = false
    var receivedLocation: Location?

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {}

    func navigateToWeatherDetails(for location: Location) {
        didNavigateToWeatherDetails = true
        receivedLocation = location
    }
}
