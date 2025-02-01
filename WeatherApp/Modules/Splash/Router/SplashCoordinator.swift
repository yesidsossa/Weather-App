import UIKit

protocol SplashCoordinatorProtocol {
    func start()
    func navigateToSearch()
}

class SplashCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let repository: WeatherRepositoryProtocol
    var finishDelegate: CoordinatorFinishDelegate?

    init(window: UIWindow, repository: WeatherRepositoryProtocol) {
        self.window = window
        self.repository = repository
        let navigationController = UINavigationController()
        super.init(navigationController: navigationController)
    }

    override func start() {
        let splashViewController = SplashConfigurator.createModule(coordinator: self)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }

    func navigateToSearch() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController, repository: repository)
        searchCoordinator.start()
        window.rootViewController = searchCoordinator.navigationController
        finish()
    }

    func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self) 
    }
}
