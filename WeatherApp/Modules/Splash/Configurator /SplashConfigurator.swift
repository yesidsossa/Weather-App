import UIKit

class SplashConfigurator {
    static func createModule(coordinator: SplashCoordinator) -> SplashViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let presenter = SplashPresenter(view: view, interactor: interactor, coordinator: coordinator)

        view.presenter = presenter
        return view
    }
}
