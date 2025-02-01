import UIKit

class SearchConfigurator {
    static func createModule(coordinator: SearchCoordinatorProtocol, repository: WeatherRepositoryProtocol) -> UIViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor(repository: repository)
        let presenter = SearchPresenter(interactor: interactor, view: view, coordinator: coordinator)

        view.presenter = presenter
        return view
    }
}
