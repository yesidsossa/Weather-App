
import UIKit

class WeatherDetailsConfigurator {
    static func createModule(coordinator: WeatherDetailsCoordinatorProtocol, repository: WeatherRepositoryProtocol, location: String) -> UIViewController {
        let view = WeatherDetailsViewController()
        let interactor = WeatherDetailsInteractor(repository: repository)
        let presenter = WeatherDetailsPresenter(interactor: interactor, view: view, location: location, coordinator: coordinator)
        view.presenter = presenter
        return view
    }
}
