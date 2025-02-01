import UIKit

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

class AppCoordinator: BaseCoordinator, CoordinatorFinishDelegate {
    private let window: UIWindow
    private let repository: WeatherRepositoryProtocol

    init(window: UIWindow, repository: WeatherRepositoryProtocol) {
        self.window = window
        self.repository = repository
        let navigationController = UINavigationController()
        super.init(navigationController: navigationController)
    }

    override func start() {
        let splashCoordinator = SplashCoordinator(window: window, repository: repository)
        splashCoordinator.finishDelegate = self 
        splashCoordinator.start()
    }

    func coordinatorDidFinish(childCoordinator: Coordinator) {
        if childCoordinator is SplashCoordinator {
            let searchCoordinator = SearchCoordinator(navigationController: navigationController, repository: repository)
            searchCoordinator.start()
            window.rootViewController = searchCoordinator.navigationController
        }
    }
}
