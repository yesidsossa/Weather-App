import UIKit

protocol SplashRouterProtocol {
    static func createModule() -> UIViewController
    func navigateToSearch()
}

class SplashRouter: SplashRouterProtocol {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        let presenter = SplashPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        router.viewController = view
        return view
    }

    func navigateToSearch() {
        let repository = WeatherRepository()
        let searchVC = SearchRouter.createModule(repository: repository)
        let navController = UINavigationController(rootViewController: searchVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        viewController?.present(navController, animated: true, completion: nil)
    }
}
