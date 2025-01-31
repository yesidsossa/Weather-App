import UIKit

protocol SearchRouterProtocol {
    func navigateToWeatherDetails(from view: SearchViewProtocol, location: Location)
}

class SearchRouter: SearchRouterProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    static func createModule(repository: WeatherRepositoryProtocol) -> UIViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor(repository: repository)
        let router = SearchRouter(repository: repository)
        let presenter = SearchPresenter(interactor: interactor, view: view, router: router)
        view.presenter = presenter
        return view
    }

    func navigateToWeatherDetails(from view: SearchViewProtocol, location: Location) {
        let weatherDetailsVC = WeatherDetailsRouter.createModule(repository: repository, location: location.name)

        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(weatherDetailsVC, animated: true)
        }
    }
}



