import UIKit


protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("⚠️ start() debe ser implementado en los coordinadores concretos.")
    }
}
