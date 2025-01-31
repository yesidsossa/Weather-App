import UIKit

class WeatherDetailsRouter {
    static func createModule(repository: WeatherRepositoryProtocol, location: String) -> UIViewController {
        let view = WeatherDetailsViewController()
        let interactor = WeatherDetailsInteractor(repository: repository)
        let presenter = WeatherDetailsPresenter(interactor: interactor, view: view, location: location)
        view.presenter = presenter
        return view
    }
}
