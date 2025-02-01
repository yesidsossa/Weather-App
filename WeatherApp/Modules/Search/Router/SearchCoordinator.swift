import UIKit

protocol SearchCoordinatorProtocol {
    func navigateToWeatherDetails(for location: Location)
}

class SearchCoordinator: BaseCoordinator, SearchCoordinatorProtocol {
    private let repository: WeatherRepositoryProtocol

    init(navigationController: UINavigationController, repository: WeatherRepositoryProtocol) {
        self.repository = repository
        super.init(navigationController: navigationController)
    }

    override func start() {
        let searchVC = SearchConfigurator.createModule(coordinator: self, repository: repository)
        navigationController.setViewControllers([searchVC], animated: false)
    }

    func navigateToWeatherDetails(for location: Location) {
        let weatherDetailsCoordinator = WeatherDetailsCoordinator(
               navigationController: navigationController,
               repository: repository,
               location: location.name
           )
           weatherDetailsCoordinator.start()
    }
}
