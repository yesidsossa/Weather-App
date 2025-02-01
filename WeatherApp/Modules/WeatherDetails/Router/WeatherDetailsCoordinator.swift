import UIKit

protocol WeatherDetailsCoordinatorProtocol{
    func start()
    func navigateBack()
}

class WeatherDetailsCoordinator: WeatherDetailsCoordinatorProtocol {
    let navigationController: UINavigationController
    private let repository: WeatherRepositoryProtocol
    private let location: String

    init(navigationController: UINavigationController, repository: WeatherRepositoryProtocol, location: String) {
        self.navigationController = navigationController
        self.repository = repository
        self.location = location
    }

    func start() {
        let detailViewController = WeatherDetailsConfigurator.createModule(coordinator: self, repository: repository, location: location)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
